#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

copy_if_missing() {
  local source="$1"
  local target="$2"

  if [[ -e "$target" ]]; then
    echo "skip: $target exists"
    return
  fi

  cp "$source" "$target"
  echo "created: $target"
}

copy_if_missing "$repo_root/dotfiles/templates/git/gitconfig" "$HOME/.gitconfig"
copy_if_missing "$repo_root/dotfiles/templates/git/gitconfig.local.example" "$HOME/.gitconfig.local"
copy_if_missing "$repo_root/dotfiles/templates/git/gitignore_global" "$HOME/.gitignore_global"

echo
echo "Review ~/.gitconfig.local and set your real Git name/email."
echo "Shell templates are available in dotfiles/templates/zsh/ and should be merged manually."
