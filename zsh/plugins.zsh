# zsh-autosuggestions (brew path)
if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# fzf (lazy-load to avoid startup cost)
fzf_loaded=0
load_fzf() {
  (( fzf_loaded )) && return
  fzf_loaded=1
  [[ -r ~/.fzf.zsh ]] && source ~/.fzf.zsh
}

# Default fzf keybindings
bindkey '^R' load_fzf   # history search
bindkey '^T' load_fzf   # file widget

