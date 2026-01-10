# shellcheck shell=bash
# shellcheck disable=SC2206

# ---------- Basic options ----------
setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt NO_BEEP

# If globs don't match, don't error (prevents: "no matches found")
setopt NONOMATCH

# ---------- Paths (dedupe) ----------
typeset -U path
path=(
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  "$HOME/bin"
  /opt/homebrew/bin
  $path
)
export PATH

# ---------- Cache ----------
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
mkdir -p "$ZSH_CACHE_DIR"

# ---------- Load modules ----------
source "$DOTFILES/zsh/env.zsh"
source "$DOTFILES/zsh/aliases.zsh"
source "$DOTFILES/zsh/functions.zsh"
source "$DOTFILES/zsh/completions.zsh"
source "$DOTFILES/zsh/plugins.zsh"
source "$DOTFILES/zsh/prompt.zsh"
