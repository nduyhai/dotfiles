# shellcheck shell=bash
autoload -Uz compinit

# Stable cache file; avoids rewriting ~/.zcompdump constantly
ZSH_COMPDUMP="$ZSH_CACHE_DIR/zcompdump-$ZSH_VERSION"

# One-time init, then cached thereafter
if [[ ! -f "$ZSH_COMPDUMP" ]]; then
  compinit -d "$ZSH_COMPDUMP"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi

# Optional: if you want completions from brew-installed site-functions
# (uncomment if you actually need them)
# fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# Attach lazy kubectl completion without generating huge compdefs at startup
if command -v kubectl >/dev/null 2>&1; then
  compdef _kubectl_lazy_complete kubectl
fi
