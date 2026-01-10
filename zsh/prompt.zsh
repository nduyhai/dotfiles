# shellcheck shell=bash
# shellcheck disable=SC1090

# Powerlevel10k via brew:
# - file usually: /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
# shellcheck source=/dev/null
[[ -r /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]] &&
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Your p10k config (we'll generate it next)
[[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh
