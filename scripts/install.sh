#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

DRY_RUN=0
FORCE=0

usage() {
  cat <<'EOF'
Usage: install.sh [--dry-run] [--force]

  --dry-run   Print actions without changing anything
  --force     Replace existing destination even if it is a symlink to another target
EOF
}

log() { printf '%s\n' "$*"; }

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    log "[dry-run] $*"
    return 0
  fi
  "$@"
}

# args
while [ $# -gt 0 ]; do
  case "${1:-}" in
    --dry-run) DRY_RUN=1 ;;
    --force) FORCE=1 ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      log "Unknown arg: $1"
      usage
      exit 1
      ;;
  esac
  shift
done

run mkdir -p "$BACKUP_DIR"

backup_path() {
  local dst="$1"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    log "Backup: $dst -> $BACKUP_DIR/"
    run mv -f "$dst" "$BACKUP_DIR/" 2>/dev/null || true
  fi
}

should_replace_symlink() {
  # Return 0 (true) if we should replace dst symlink even without --force
  # - dst links to src already -> don't replace
  # - dst links into old dotfiles dir (~/.dotfiles/...) -> replace automatically
  local dst="$1"
  local src="$2"
  local cur

  cur="$(readlink "$dst" || true)"

  # Already correct?
  if [ "$cur" = "$src" ]; then
    return 1
  fi

  # Auto-replace old layout like /Users/.../.dotfiles/...
  if [[ "$cur" == "$HOME/.dotfiles/"* ]] || [[ "$cur" == "$HOME/.dotfiles"* ]]; then
    return 0
  fi

  # Otherwise replace only with --force
  if [ "$FORCE" -eq 1 ]; then
    return 0
  fi

  return 1
}

link_file() {
  local src="$1"
  local dst="$2"

  if [ ! -e "$src" ]; then
    log "Skip: source missing $src"
    return 0
  fi

  # If dst is symlink
  if [ -L "$dst" ]; then
    if should_replace_symlink "$dst" "$src"; then
      backup_path "$dst"
    else
      log "Warn: $dst is a symlink to: $(readlink "$dst" || true)"
      log "      Use --force to replace."
      return 0
    fi
  elif [ -e "$dst" ]; then
    # Existing regular file/dir
    backup_path "$dst"
  fi

  run mkdir -p "$(dirname "$dst")"
  run ln -s "$src" "$dst"
  log "Link: $dst -> $src"
}

ensure_file_if_missing() {
  local file="$1"
  if [ -f "$file" ]; then
    log "OK: exists $file"
    return 0
  fi
  run mkdir -p "$(dirname "$file")"
  if [ "$DRY_RUN" -eq 1 ]; then
    log "[dry-run] create file $file"
    return 0
  fi
  : >"$file"
  log "Create: $file"
}

write_file_if_missing() {
  local file="$1"
  shift
  if [ -f "$file" ]; then
    log "OK: exists $file"
    return 0
  fi
  run mkdir -p "$(dirname "$file")"
  if [ "$DRY_RUN" -eq 1 ]; then
    log "[dry-run] write template $file"
    return 0
  fi
  cat >"$file" <<EOF
$*
EOF
  log "Create: $file"
}

log "Repo: $REPO_ROOT"
log "Backup dir: $BACKUP_DIR"
[ "$DRY_RUN" -eq 1 ] && log "Mode: dry-run"

# Ensure cache dirs
run mkdir -p "$HOME/.cache/zsh"

# --- Zsh ---
link_file "$REPO_ROOT/home/.zshrc" "$HOME/.zshrc"
if [ -f "$REPO_ROOT/home/.zshenv" ]; then
  link_file "$REPO_ROOT/home/.zshenv" "$HOME/.zshenv"
fi

# --- Common dotfiles ---
[ -f "$REPO_ROOT/home/.ignore" ] && link_file "$REPO_ROOT/home/.ignore" "$HOME/.ignore"
[ -f "$REPO_ROOT/home/.ripgreprc" ] && link_file "$REPO_ROOT/home/.ripgreprc" "$HOME/.ripgreprc"
[ -f "$REPO_ROOT/home/.tmux.conf" ] && link_file "$REPO_ROOT/home/.tmux.conf" "$HOME/.tmux.conf"
[ -f "$REPO_ROOT/home/.vimrc" ] && link_file "$REPO_ROOT/home/.vimrc" "$HOME/.vimrc"

# --- Git ---
# Global ignore
if [ -f "$REPO_ROOT/home/.gitignore_global" ]; then
  link_file "$REPO_ROOT/home/.gitignore_global" "$HOME/.gitignore_global"
fi

# Main git config (shared)
if [ -f "$REPO_ROOT/home/.main.gitconfig" ]; then
  link_file "$REPO_ROOT/home/.main.gitconfig" "$HOME/.main.gitconfig"
fi

# Create ~/.gitconfig.local if missing (never overwrite)
write_file_if_missing "$HOME/.gitconfig.local" \
  '# Local-only Git config (DO NOT COMMIT)
# Put identities + includeIf routing here.

[user]
  name = nduyhai
  email = nduyhai@users.noreply.github.com

[includeIf "gitdir:~/workspace/"]
  path = ~/.gitconfig-personal

[includeIf "gitdir:~/company/"]
  path = ~/.gitconfig-company

[url "git@git.company.vn:"]
  insteadOf = https://git.company.vn/
'

# Ensure ~/.gitconfig is minimal include-only (safe + portable).
# If repo provides home/.gitconfig, we symlink it (and it should be include-only).
if [ -f "$REPO_ROOT/home/.gitconfig" ]; then
  link_file "$REPO_ROOT/home/.gitconfig" "$HOME/.gitconfig"
else
  # Generate one (replace existing file by backup unless it's a correct symlink)
  if [ -L "$HOME/.gitconfig" ]; then
    log "OK: ~/.gitconfig is a symlink"
  else
    if [ -e "$HOME/.gitconfig" ]; then
      backup_path "$HOME/.gitconfig"
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
      log "[dry-run] write ~/.gitconfig include-only"
    else
      cat >"$HOME/.gitconfig" <<'EOF'
[include]
  path = ~/.gitconfig.local

[include]
  path = ~/.main.gitconfig
EOF
      log "Write: ~/.gitconfig"
    fi
  fi
fi

log ""
log "Done."
log "Restart your terminal or run: exec zsh"
