# Powerlevel10k via brew:
# - file usually: /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
if [[ -r /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
fi

# Your p10k config (we'll generate it next)
[[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh
