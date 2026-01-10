# Detect repo root from this file's location (works when symlinked)
DOTFILES_DIR="${0:A:h:h}"

export DOTFILES="$DOTFILES_DIR"
source "$DOTFILES/zsh/init.zsh"
