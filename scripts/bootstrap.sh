#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Checking Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Install it first:"
  echo "https://docs.brew.sh/Installation.html"
  exit 1
fi

echo "==> Installing packages from Brewfile"
brew bundle --file "$repo_root/Brewfile"

echo "==> Checking fnm"
if ! command -v fnm >/dev/null 2>&1; then
  echo "fnm is still not available. Open a new terminal or check Homebrew shellenv."
  exit 1
fi

echo "==> Installing latest Node.js LTS"
eval "$(fnm env --use-on-cd --shell bash)"
fnm install --lts
fnm default lts-latest
fnm use lts-latest

echo "==> Enabling Corepack"
corepack enable

echo "==> Checking chezmoi"
if command -v chezmoi >/dev/null 2>&1; then
  mkdir -p "$HOME/.config/chezmoi"
  cat > "$HOME/.config/chezmoi/chezmoi.toml" <<EOF
sourceDir = "$repo_root/dotfiles/chezmoi"
mode = "symlink"
EOF
  chezmoi apply
else
  echo "chezmoi is not available yet. Re-run after brew bundle completes."
fi

echo "==> Versions"
node --version
npm --version
corepack --version
pnpm --version

echo "==> Done"
