#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP_DIR"

link_file() {
  local src="$1"
  local dst="$2"

  # If dst exists and isn't a symlink to src, back it up
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
      echo "OK: already linked $dst -> $src"
      return
    fi
    echo "Backup: $dst -> $BACKUP_DIR/"
    mv "$dst" "$BACKUP_DIR/" 2>/dev/null || true
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "Link: $dst -> $src"
}

echo "Repo: $REPO_ROOT"
echo "Backup dir: $BACKUP_DIR"

# Ensure cache dirs
mkdir -p "$HOME/.cache/zsh"

# Symlink zsh entrypoint
link_file "$REPO_ROOT/home/.zshrc" "$HOME/.zshrc"

# Optional: if you also manage .zshenv
if [ -f "$REPO_ROOT/home/.zshenv" ]; then
  link_file "$REPO_ROOT/home/.zshenv" "$HOME/.zshenv"
fi

echo ""
echo "Done. Restart your terminal or run: exec zsh"

