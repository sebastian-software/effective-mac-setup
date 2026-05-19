# effective-mac-setup

A reproducible, lightweight macOS developer setup for modern Node.js frontend development and common infrastructure tooling.

Goal: keep a macOS device fast and lean while still making it ready for modern frontend work with TypeScript, React, Node.js, Go, and Rust.

## What This Repo Manages

- `Brewfile`: Homebrew formulae, casks, and reviewed Mac App Store apps.
- `dotfiles/chezmoi`: Git, zsh, fish, and shared shell helper files managed by `chezmoi` in symlink mode.
- `dotfiles/chezmoi/private_dot_config`: app config such as Starship, Zed, fish, and Ghostty/cmux settings.
- `macos/defaults.sh`: curated macOS settings that are applied explicitly.
- `scripts/bootstrap.sh`: first-run helper for Homebrew packages, fnm, Node LTS, Corepack, and pnpm.
- `scripts/doctor.sh`: compact health check for Brew, dotfiles, runtimes, apps, auth, and MAS.

It intentionally does not manage SSH keys. GitHub SSH auth is handled through the 1Password SSH Agent.

It also does not store plaintext API tokens. If a CLI needs global environment
variables, store the secret values in 1Password and map them locally in:

```text
~/.config/effective-mac-setup/op-env
```

Example:

```env
LINEAR_API_KEY=op://Private/Linear/API Key
CARGO_REGISTRY_TOKEN=op://Private/Cargo/Registry Token
```

`~/.zshrc` and fish load that file with `op read` when it exists. Use
`op-env-edit` to edit the local mapping and `op-env-load` to reload it in the
current shell.

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
~/.config/fish/config.fish
~/.config/ghostty/config
~/.config/starship.toml
~/.config/zed/settings.json
~/.local/bin
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

This also configures macOS Terminal and cmux/Ghostty to start fish as the
interactive shell, without changing the account login shell via `chsh`.

### 7. Setup Doctor

Run the doctor after bootstrap, after Brewfile changes, or when the shell feels off:

```sh
scripts/doctor.sh
```

It prints compact `OK`, `WARN`, and `FAIL` lines. Warnings such as flaky MAS or network checks do not fail the run. To re-apply the safe setup steps, use:

```sh
scripts/doctor.sh --fix
```

`--fix` may run `brew bundle`, configure/apply `chezmoi`, install Node LTS through `fnm`, and enable Corepack/pnpm. It does not apply `macos/defaults.sh` and does not change SSH or 1Password configuration.

## Current Defaults

- Git identity uses GitHub's noreply email address:
  `swernerx@users.noreply.github.com`
- Node.js is managed through `fnm`, not Homebrew Node.
- Node.js gets a global 16GB memory ceiling through `NODE_OPTIONS` for large frontend builds, type checks, and code-generation tasks.
- Package manager is `pnpm` through Corepack.
- Zsh remains the login/fallback shell.
- Fish is the interactive Terminal/cmux shell trial.
- Shared commands live in `~/.local/bin` so zsh, fish, Terminal, cmux, and agentic workflows use the same entrypoints.
- zoxide provides smart directory jumping for zsh and fish; fzf is intentionally not part of this first shell block.
- Editor is Zed; VS Code remains a commented fallback in the Brewfile.
- Prompt is Starship with a lean managed config.
- GitHub Desktop, cmux, Firefox, Chrome, Go, Rust, and Mac App Store apps are tracked in the Brewfile.

## Checks

```sh
scripts/doctor.sh
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
