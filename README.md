# effective-mac-setup

An opinionated, reproducible macOS setup for people who want a fast developer
machine without turning their home directory into a mystery box.

It installs a curated set of tools, manages dotfiles with `chezmoi`, keeps common
shell helpers in `~/.local/bin`, and applies only the macOS defaults that are
explicitly documented in this repo.

The setup is tuned for modern application and frontend-adjacent development:
Node.js, pnpm, GitHub, Zed, Go, Rust, shell tooling, and a clean terminal
experience. It is intentionally small enough to understand and fork.

## Why This Exists

Fresh Macs are pleasant, but rebuilding the same developer setup by hand is not.
This repo keeps the important choices in version control:

- which Homebrew tools and apps should be installed
- which Mac App Store apps are part of the setup
- which Git, shell, editor, prompt, and terminal settings are managed
- which macOS defaults are intentional
- which checks prove the setup is healthy

It is not a complete backup of a Mac. It does not dump every preference file, it
does not store secrets, and it does not try to own the whole machine.

## What It Manages

- `Brewfile`: Homebrew formulae, casks, taps, and reviewed Mac App Store apps.
- `dotfiles/chezmoi`: Git, zsh, fish, Starship, Zed, Ghostty/cmux, and shared helper commands.
- `macos/defaults.sh`: small, named macOS settings that are safe to review before applying.
- `scripts/bootstrap.sh`: first-run installer for packages, dotfiles, Node LTS, Corepack, and pnpm.
- `scripts/doctor.sh`: health check for packages, apps, dotfiles, runtimes, auth, MAS, and shell setup.
- `docs/adr-0001-macos-settings.md`: why macOS settings are curated one by one instead of blindly exported.

## Design Principles

- Keep the setup readable. Prefer boring files over clever loaders.
- Track decisions close to the config they affect.
- Use direct symlinks through `chezmoi` so edits stay visible in this repo.
- Keep secrets out of Git. Use 1Password for SSH and optional environment variables.
- Leave zsh as the account login shell, but use fish as the default interactive shell for owned terminals.
- Make destructive or surprising commands explicit.
- Treat macOS defaults as code: document the desired behavior, then apply the smallest known setting.

## Quick Start

### 1. Install Xcode Command Line Tools

```sh
xcode-select --install
```

### 2. Install Homebrew

Follow the official Homebrew instructions:

https://docs.brew.sh/Installation.html

Then verify it:

```sh
brew --version
brew doctor
```

### 3. Clone This Repo

Use your own fork if you want to make this setup personal:

```sh
mkdir -p ~/Workspace
git clone git@github.com:sebastian-software/effective-mac-setup.git ~/Workspace/effective-mac-setup
cd ~/Workspace/effective-mac-setup
```

### 4. Bootstrap the Machine

```sh
scripts/bootstrap.sh
```

This runs `brew bundle`, prepares Node through `fnm`, enables Corepack/pnpm, and
applies the managed dotfiles with `chezmoi`.

### 5. Review and Apply macOS Defaults

The macOS settings are intentionally separate from the bootstrap step. Read them
first, then apply them when they match what you want:

```sh
sed -n '1,240p' macos/defaults.sh
macos/defaults.sh
```

This also configures macOS Terminal and cmux/Ghostty to start fish without
changing the account login shell via `chsh`.

### 6. Run the Doctor

```sh
scripts/doctor.sh
```

The doctor prints compact `OK`, `WARN`, and `FAIL` lines. Warnings are useful
signals, but flaky network, MAS, or auth checks do not fail the run. To re-apply
safe setup steps, use:

```sh
scripts/doctor.sh --fix
```

`--fix` may run `brew bundle`, configure/apply `chezmoi`, install Node LTS
through `fnm`, create the pnpm global bin directory, and enable Corepack/pnpm.
It does not apply `macos/defaults.sh` and does not change SSH or 1Password
configuration.

## Managed Dotfiles

This setup uses `chezmoi` in symlink mode. The source directory is inside this
repo:

```toml
sourceDir = "/Users/sebastian/Workspace/effective-mac-setup/dotfiles/chezmoi"
mode = "symlink"
```

If you fork this repo or clone it somewhere else, adjust `sourceDir` accordingly.
The bootstrap script writes this config for the current checkout.

Managed targets include:

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

## Shell Setup

Fish is the default interactive shell for macOS Terminal and cmux. Zsh remains
the account login shell and fallback.

Shared helper commands live in `~/.local/bin` so zsh, fish, Terminal, cmux, and
agentic workflows call the same entrypoints. Examples:

```text
setup-doctor
repos-update
repupd
cleanup-dsstore
del
myip
ports
flushdns
op-env-edit
```

Node is managed by `fnm`. pnpm comes through Corepack. Global pnpm CLIs use:

```sh
PNPM_HOME=$HOME/Library/pnpm
PATH=$PNPM_HOME:$PNPM_HOME/bin:$PATH
```

## Secrets and SSH

This repo intentionally does not manage SSH keys. GitHub SSH auth is expected to
run through the 1Password SSH Agent.

It also does not store plaintext API tokens. If a CLI needs global environment
variables, store the values in 1Password and map them locally in:

```text
~/.config/effective-mac-setup/op-env
```

Example:

```env
LINEAR_API_KEY=op://Private/Linear/API Key
CARGO_REGISTRY_TOKEN=op://Private/Cargo/Registry Token
```

Zsh and fish load that file with `op read` when it exists. Use `op-env-edit` to
edit the local mapping and `op-env-load` to reload it in the current shell.

## Current Defaults

- Git uses SSH commit signing through 1Password.
- Node.js is managed through `fnm`, not Homebrew Node.
- Node.js gets a global 16GB memory ceiling through `NODE_OPTIONS`.
- Package manager is `pnpm` through Corepack.
- Fish is the default interactive shell for Terminal and cmux.
- Zsh remains the account login shell and fallback.
- Prompt is Starship.
- Editor is Zed.
- zoxide provides smart directory jumping.
- Git LFS, hyperfine, wget, and Semgrep are tracked as useful baseline CLI tools.
- GitHub Desktop, cmux, Firefox, Chrome, Go, Rust, and reviewed Mac App Store apps are tracked in the Brewfile.

## Useful Checks

```sh
scripts/doctor.sh
brew bundle check --no-upgrade --file Brewfile
chezmoi status
chezmoi diff
git config --global --list
node --version
pnpm --version
pnpm bin -g
go version
rustc --version
```

## Adapting This For Yourself

Start with these files:

- `Brewfile`: remove apps you do not use and add your own.
- `dotfiles/chezmoi/dot_gitconfig`: change identity, signing, and aliases.
- `dotfiles/chezmoi/private_dot_config/fish/config.fish`: adjust shell defaults.
- `dotfiles/chezmoi/private_dot_config/ghostty/config`: adjust cmux/Ghostty behavior.
- `macos/defaults.sh`: review every setting before applying it.

Good first customizations:

- Replace the Git identity and signing key.
- Review Mac App Store entries.
- Adjust Dock items in `macos/defaults.sh`.
- Decide whether Chrome, Firefox, cmux, Zed, Go, and Rust fit your workflow.
- Add or remove shell helpers in `dotfiles/chezmoi/private_dot_local/bin`.

## Still Manual

- Sign in to 1Password and enable the SSH Agent.
- Sign in to GitHub CLI with `gh auth login`.
- Verify GitHub SSH auth in a normal terminal:
  `ssh -T git@github.com`
- Sign in to the Mac App Store before relying on MAS checks.
- Re-run `scripts/doctor.sh` after changing packages, dotfiles, or macOS defaults.
