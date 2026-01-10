#!/bin/bash

# kube-context.sh
# Show current Kubernetes context, interactively choose a context, and apply it.
# Extras:
#   - If fzf is installed, uses a fuzzy picker; otherwise falls back to a numbered menu.
#   - --install will add a convenient Zsh function `kctx` to your ~/.zshrc that calls this script.
#   - --set <context> switches directly to the specified context.
#
# Note:
# chmod +x scripts/kube-context.sh
#
# Usage:
#
#   ./scripts/kube-context.sh            # interactive selection
#   ./scripts/kube-context.sh --set NAME # switch directly
#   ./scripts/kube-context.sh --install  # add kctx() to ~/.zshrc
#
# Requirements: kubectl must be installed and configured.

set -euo pipefail

print_help() {
  cat <<EOF
kube-context.sh - interactively switch Kubernetes contexts

Usage:
  $0                 Start interactive selection and switch context
  $0 --set <name>    Switch directly to given context name
  $0 --install       Append a helper function 'kctx' to ~/.zshrc
  $0 --help          Show this help

The script prefers fzf if available; otherwise uses a simple numbered menu.
EOF
}

# Verify kubectl exists
if ! command -v kubectl >/dev/null 2>&1; then
  echo "❌ kubectl not found. Please install kubectl and try again." >&2
  exit 1
fi

SCRIPT_ABS_PATH="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

install_to_zshrc() {
  local ZSHRC="$HOME/.zshrc"
  local MARK_START="# >>> kctx (kubectl context helper) >>>"
  local MARK_END="# <<< kctx (kubectl context helper) <<<"

  # Remove existing block if present to avoid duplicates
  if [ -f "$ZSHRC" ] && grep -q "$MARK_START" "$ZSHRC"; then
    # Use awk to remove the block between markers
    awk -v start="$MARK_START" -v end="$MARK_END" '
      $0 ~ start {flag=1; next}
      $0 ~ end {flag=0; next}
      !flag {print}
    ' "$ZSHRC" > "$ZSHRC.tmp" && mv "$ZSHRC.tmp" "$ZSHRC"
  fi

  mkdir -p "$HOME"
  {
    echo "$MARK_START"
    echo "# Added by $SCRIPT_ABS_PATH on $(date '+%Y-%m-%d %H:%M:%S')"
    echo "kctx() {"
    echo "  \"$SCRIPT_ABS_PATH\" \"\$@\""
    echo "}"
    echo "$MARK_END"
  } >> "$ZSHRC"

  echo "✅ Installed 'kctx' function to $ZSHRC"
  echo "🔁 Run: source $ZSHRC  (or open a new terminal)"
}

list_contexts() {
  # Output only names; suppress headers
  kubectl config get-contexts -o name 2>/dev/null || true
}

current_context() {
  kubectl config current-context 2>/dev/null || true
}

use_context() {
  local target="$1"
  if [ -z "$target" ]; then
    echo "❌ No context specified" >&2
    return 1
  fi
  echo "🔄 Switching context to: $target"
  kubectl config use-context "$target"
}

fzf_pick() {
  local current="$1"
  local selection
  selection=$(list_contexts | awk -v cur="$current" '{ if ($0==cur) printf("* %s\n", $0); else print $0 }' | \
    fzf --ansi --no-multi --prompt="k8s context > " --height=50% --reverse \
        --header="Current: ${current:-<none>}  (Press ESC to cancel)" \
        --with-nth=1.. \
        --preview-window=down,hidden)

  # Remove leading * and space if present
  selection="${selection#* }"
  echo "$selection"
}

menu_pick() {
  local current="$1"
  local contexts=("$(list_contexts | tr '\n' ' ')")
  # Rebuild array properly
  IFS=' ' read -r -a contexts <<< "$(list_contexts | tr '\n' ' ')"

  if [ ${#contexts[@]} -eq 0 ]; then
    echo ""; return 0
  fi

  echo "\n📋 Available contexts:"
  local i=1
  for ctx in "${contexts[@]}"; do
    if [ "$ctx" = "$current" ]; then
      printf "  %2d) %s %s\n" "$i" "$ctx" "(current)"
    else
      printf "  %2d) %s\n" "$i" "$ctx"
    fi
    i=$((i+1))
  done
  echo "  0) Cancel"

  local choice
  while true; do
    read -rp "Select a context number: " choice || { echo ""; return 0; }
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -le ${#contexts[@]} ]; then
      break
    fi
    echo "❗ Invalid choice. Please enter a number between 0 and ${#contexts[@]}."
  done

  if [ "$choice" -eq 0 ]; then
    echo ""; return 0
  fi
  echo "${contexts[$((choice-1))]}"
}

# Parse args
if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  print_help
  exit 0
fi

if [ "${1:-}" = "--install" ]; then
  install_to_zshrc
  exit 0
fi

if [ "${1:-}" = "--set" ]; then
  if [ -z "${2:-}" ]; then
    echo "❌ Missing context name. Usage: $0 --set <name>" >&2
    exit 1
  fi
  use_context "$2"
  exit $?
fi

# Interactive flow
CURR=$(current_context)
if [ -n "$CURR" ]; then
  echo "📍 Current context: $CURR"
else
  echo "📍 Current context: <none>"
fi

# Get available contexts
if ! CTXS=$(list_contexts); then
  echo "❌ Failed to list contexts" >&2
  exit 1
fi

if [ -z "$CTXS" ]; then
  echo "❌ No contexts found in kubeconfig. Configure kubectl first."
  exit 1
fi

PICK=""
if command -v fzf >/dev/null 2>&1; then
  PICK=$(fzf_pick "$CURR")
else
  PICK=$(menu_pick "$CURR")
fi

if [ -z "$PICK" ]; then
  echo "👋 Cancelled. No changes made."
  exit 0
fi

if [ "$PICK" = "$CURR" ]; then
  echo "ℹ️ Already on context: $PICK"
  exit 0
fi

use_context "$PICK"

NEW=$(current_context)
echo "✅ Now using context: $NEW"
