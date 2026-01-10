# Quick reload
reload() { source ~/.zshrc; }

# Lazy kubectl completion (only loads when you try to complete)
_kubectl_lazy_complete() {
  unfunction _kubectl_lazy_complete 2>/dev/null
  if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
  fi
}
# We'll attach compdef in completions.zsh after compinit.
