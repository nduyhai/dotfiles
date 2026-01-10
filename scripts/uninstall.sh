#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

unlink_if_points_to_repo() {
  local dst="$1"

  if [ -L "$dst" ]; then
    local target
    target="$(readlink "$dst")"
    case "$target" in
      "$REPO_ROOT"/*)
        rm "$dst"
        echo "Removed symlink: $dst -> $target"
        ;;
      *)
        echo "Skip: $dst is a symlink but not to this repo ($target)"
        ;;
    esac
  else
    echo "Skip: $dst is not a symlink"
  fi
}

unlink_if_points_to_repo "$HOME/.zshrc"
unlink_if_points_to_repo "$HOME/.zshenv"

echo "Done."
