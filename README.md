# effective-mac-setup

A reproducible, lightweight macOS developer setup for modern Node.js frontend development and common infrastructure tooling.

Goal: keep a macOS device fast and lean while still making it ready for modern frontend work with TypeScript, React, Node.js, Go, and Rust.

## Current Status

Checked on 2026-05-12:

- macOS 26.5, build 25F71
- Apple Silicon (`arm64`)
- Xcode Command Line Tools installed
- Homebrew 5.1.11 at `/opt/homebrew`
- GitHub CLI 2.92.0 installed and authenticated
- `fnm` 1.39.0 installed
- Node.js LTS 24.15.0 via `fnm`
- Go and Rust planned as standard infrastructure toolchains
- npm 11.12.1
- Corepack 0.34.6
- pnpm 11.1.1

Details are tracked in [docs/status.md](docs/status.md).

## Quick Start on a Fresh Mac

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

### 4. Configure the Shell for Homebrew and fnm

`~/.zprofile`:

```sh
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

`~/.zshrc`:

```sh
eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(starship init zsh)"
```

Open a new terminal window afterwards.

### 5. Install Node LTS

```sh
fnm install --lts
fnm default lts-latest
fnm use lts-latest
corepack enable
pnpm --version
```

### 6. Configure Git

```sh
git config --global user.name "Your Name"
git config --global user.email "your@email"
gh auth login
```

## Recommended Project Defaults

- Primary frontend runtime: Node.js LTS via fnm
- Simple React SPAs: Vite + React + TypeScript
- Product-like web apps: Next.js App Router
- Package manager: pnpm via Corepack
- Tests: Vitest for unit/component tests, Playwright for browser/E2E tests
- Linting/formatting: ESLint + Prettier
- Infrastructure-adjacent tooling: Go and Rust via Homebrew/rustup as needed

## Package Management

The `Brewfile` is curated before installation. It includes the approved baseline tools, `chezmoi` for dotfile management, Go/Rust for OSS work such as Ferrocat, Firefox, GitHub Desktop, and `mas` so Mac App Store apps can be added later as reproducible entries.

Chrome, VS Code, container tooling, API clients, and database GUIs are intentionally left commented out until they are explicitly needed.

## Next Steps

The prioritized list lives in [docs/todo.md](docs/todo.md).

For starting a new Codex session, use the compact handoff:

[docs/session-handoff.md](docs/session-handoff.md)

## Dotfiles

Reusable Git and shell templates live in [dotfiles/](dotfiles/).

Dotfile management should use `chezmoi` instead of a custom script. The Git configuration is intentionally split into two parts:

- Versioned defaults: `dotfiles/templates/git/gitconfig`
- Private identity: `~/.gitconfig.local`

The current templates can still be applied manually while the `chezmoi` migration is prepared:

```sh
scripts/apply-dotfiles.sh
```

The migration plan lives in [docs/dotfiles-plan.md](docs/dotfiles-plan.md).
