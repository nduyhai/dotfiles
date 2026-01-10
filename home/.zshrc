# Resolve this file's real path even when symlinked
DOTFILES_DIR="${${(%):-%N}:A:h:h}"

export DOTFILES="$DOTFILES_DIR"

if [[ ! -f "$DOTFILES/zsh/init.zsh" ]]; then
  echo "❌ dotfiles not found at $DOTFILES" >&2
  return 1
fi

source "$DOTFILES/zsh/init.zsh"

