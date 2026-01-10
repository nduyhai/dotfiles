#!/usr/bin/env bash
set -euo pipefail

echo "==> Dotfiles doctor"
echo

check() {
  local name="$1"
  local cmd="$2"

  if command -v "$cmd" >/dev/null 2>&1; then
    echo "✔ $name ($(command -v "$cmd"))"
  else
    echo "✘ $name (missing)"
  fi
}

echo "-- Core --"
check "zsh" zsh
check "git" git

echo
echo "-- Shell tools --"
check "fzf" fzf
check "zsh-autosuggestions" zsh-autosuggestions
check "powerlevel10k" p10k

echo
echo "-- Dev / CI tools --"
check "shellcheck" shellcheck
check "shfmt" shfmt
check "gitleaks" gitleaks
check "trivy" trivy

echo
echo "-- Docker (optional) --"
check "docker" docker
if command -v docker >/dev/null 2>&1; then
  if docker info >/dev/null 2>&1; then
    echo "✔ docker daemon running"
  else
    echo "⚠ docker installed but daemon not running"
  fi
fi

echo
echo "-- Zsh config --"
if [ -L "$HOME/.zshrc" ]; then
  echo "✔ ~/.zshrc is symlink -> $(readlink "$HOME/.zshrc")"
else
  echo "⚠ ~/.zshrc is not a symlink"
fi

if [ -f "$HOME/.p10k.zsh" ]; then
  echo "✔ ~/.p10k.zsh exists"
else
  echo "⚠ ~/.p10k.zsh missing (run: p10k configure)"
fi

echo
echo "Doctor finished."
