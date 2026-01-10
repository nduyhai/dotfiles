# zsh-autosuggestions (brew path)
if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# fzf (lazy-load to avoid startup cost)
fzf_loaded=0
load_fzf() {
  ((fzf_loaded)) && return
  fzf_loaded=1
  [[ -r ~/.fzf.zsh ]] && source ~/.fzf.zsh
}

# Default fzf keybindings
load_fzf_history() {
  load_fzf
  (($ + widgets[fzf - history - widget])) || return
  zle fzf-history-widget
}

load_fzf_files() {
  load_fzf
  (($ + widgets[fzf - file - widget])) || return
  zle fzf-file-widget
}

zle -N load_fzf_history
zle -N load_fzf_files

bindkey '^R' load_fzf_history # history search
bindkey '^T' load_fzf_files   # file widget
