#!/usr/bin/env bash
set -euo pipefail

echo "==> Bootstrapping dotfiles dependencies"
echo "NOTE: This script only INSTALLS missing tools."
echo "      It does NOT remove or overwrite existing ones."
echo

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found."
  echo "Install from: https://brew.sh"
  exit 1
fi

TOOLS=(
  powerlevel10k
  zsh-autosuggestions
  fzf
  shellcheck
  shfmt
  gitleaks
  trivy
)

for tool in "${TOOLS[@]}"; do
  if brew list "$tool" >/dev/null 2>&1; then
    echo "✔ $tool already installed"
  else
    echo "➕ Installing $tool"
    brew install "$tool"
  fi
done

# fzf post-install (safe mode)
if [ -x "$(brew --prefix)/opt/fzf/install" ]; then
  echo
  echo "Configuring fzf (no rc modification)"
  "$(brew --prefix)/opt/fzf/install" --no-update-rc --no-bash --no-fish || true
fi

echo
echo "Bootstrap complete."
