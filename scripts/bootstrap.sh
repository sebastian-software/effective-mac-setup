#!/usr/bin/env bash
set -euo pipefail

echo "==> Checking Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Install it first:"
  echo "https://docs.brew.sh/Installation.html"
  exit 1
fi

echo "==> Installing packages from Brewfile"
brew bundle --file Brewfile

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

echo "==> Versions"
node --version
npm --version
corepack --version
pnpm --version

echo "==> Done"
