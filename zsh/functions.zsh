# Quick reload
reload() { source ~/.zshrc; }

# Lazy kubectl completion (only loads when you try to complete)
_kubectl_lazy_complete() {
  unfunction _kubectl_lazy_complete 2>/dev/null
  if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
  fi
}

# kubectl context switcher
kctx() {
  local script="${DOTFILES:-$HOME/.dotfiles}/scripts/functions/kube-context.sh"
  if [[ ! -x "$script" ]]; then
    echo "kctx: missing executable: $script" >&2
    return 1
  fi
  "$script" "$@"
}
