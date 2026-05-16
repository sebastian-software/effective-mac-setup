# effective-mac-setup

A reproducible, lightweight macOS developer setup for modern Node.js frontend development and common infrastructure tooling.

Goal: keep a macOS device fast and lean while still making it ready for modern frontend work with TypeScript, React, Node.js, Go, and Rust.

## What This Repo Manages

- `Brewfile`: Homebrew formulae, casks, and reviewed Mac App Store apps.
- `dotfiles/chezmoi`: Git and zsh dotfiles managed by `chezmoi` in symlink mode.
- `macos/defaults.sh`: curated macOS settings that are applied explicitly.
- `scripts/bootstrap.sh`: first-run helper for Homebrew packages, fnm, Node LTS, Corepack, and pnpm.

It intentionally does not manage SSH keys. GitHub SSH auth is handled through the 1Password SSH Agent.

macOS system settings are not blindly exported. Desired settings should be named, researched, and added one by one; see [ADR 0001](docs/adr-0001-macos-settings.md).

## Fresh Mac

### 1. Xcode Command Line Tools

```sh
xcode-select --install
```

### 2. Homebrew

Install Homebrew using the official instructions:

https://docs.brew.sh/Installation.html

Then verify it:

```sh
brew --version
brew doctor
```

### 3. Install Packages

```sh
brew bundle --file Brewfile
```

### 4. Configure Dotfiles

This setup uses `chezmoi` with direct symlinks into this repo:

```sh
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml <<'EOF'
sourceDir = "/Users/sebastian/Workspace/effective-mac-setup/dotfiles/chezmoi"
mode = "symlink"
EOF
chezmoi apply
```

Managed targets:

```text
~/.gitconfig
~/.gitignore_global
~/.zprofile
~/.zshrc
```

### 5. Node LTS

```sh
fnm install --lts
fnm default lts-latest
fnm use lts-latest
corepack enable
pnpm --version
```

### 6. macOS Settings

Review the curated settings first, especially mouse speed and Dock items:

```sh
sed -n '1,220p' macos/defaults.sh
macos/defaults.sh
```

## Current Defaults

- Git identity uses GitHub's noreply email address:
  `swernerx@users.noreply.github.com`
- Node.js is managed through `fnm`, not Homebrew Node.
- Package manager is `pnpm` through Corepack.
- Editor is Zed; VS Code remains a commented fallback in the Brewfile.
- GitHub Desktop, Firefox, Chrome, Go, Rust, and Mac App Store apps are tracked in the Brewfile.

## Checks

```sh
brew bundle check --no-upgrade --file Brewfile
chezmoi status
chezmoi diff
git config --global --list
node --version
pnpm --version
go version
rustc --version
```

## Recommended Project Defaults

- Primary frontend runtime: Node.js LTS via fnm
- Simple React SPAs: Vite + React + TypeScript
- Product-like web apps: Next.js App Router
- Package manager: pnpm via Corepack
- Tests: Vitest for unit/component tests, Playwright for browser/E2E tests
- Linting/formatting: ESLint + Prettier
- Infrastructure-adjacent tooling: Go and Rust via Homebrew/rustup as needed

## Still Manual

- Verify the 1Password SSH Agent in a normal terminal:
  `ssh -T git@github.com`
- Re-run `mas list` on a stable connection and compare it with the Brewfile.
- Decide whether OrbStack, VS Code, or API/database GUI tools are actually needed.
