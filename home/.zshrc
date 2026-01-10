# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Resolve this file's real path even when symlinked
DOTFILES_DIR="${${(%):-%N}:A:h:h}"

export DOTFILES="$DOTFILES_DIR"

if [[ ! -f "$DOTFILES/zsh/init.zsh" ]]; then
  echo "❌ dotfiles not found at $DOTFILES" >&2
  return 1
fi

source "$DOTFILES/zsh/init.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
