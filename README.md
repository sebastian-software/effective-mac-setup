# effective-mac-setup

An opinionated, reproducible macOS setup for people who want a fast developer
machine without turning their home directory into a mystery box.

It installs a curated set of tools, manages dotfiles with `chezmoi`, keeps common
shell helpers in `~/.local/bin`, and applies only the macOS defaults that are
explicitly documented in this repo.

The setup is tuned for modern application and frontend-adjacent development:
Node.js, pnpm, GitHub, Zed, Go, Rust, containers, shell tooling, browsers,
media utilities, communication apps, and a clean terminal experience. It is
intentionally small enough to understand and fork.

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
- `dotfiles/chezmoi`: Git, zsh, fish, Starship, Zed, Ghostty/cmux, Colima, and shared helper commands.
- `macos/defaults.sh`: small, named macOS settings that are safe to review before applying.
- `scripts/bootstrap.sh`: first-run installer for packages, dotfiles, Node LTS, Corepack, and pnpm.
- `scripts/doctor.sh`: health check for packages, apps, dotfiles, runtimes, auth, MAS, and shell setup.
- `docs/adr-0001-macos-settings.md`: why macOS settings are curated one by one instead of blindly exported.

## Included Apps And Tools

The `Brewfile` is the source of truth. This visual index shows the main tools
and apps the setup brings along, grouped by role.

| Area | Included |
| --- | --- |
| Development | <a href="https://git-scm.com"><img src="https://www.google.com/s2/favicons?domain=git-scm.com&sz=32" width="18" alt=""> Git</a> · <a href="https://git-lfs.com"><img src="https://www.google.com/s2/favicons?domain=git-lfs.com&sz=32" width="18" alt=""> Git LFS</a> · <a href="https://cli.github.com"><img src="https://www.google.com/s2/favicons?domain=cli.github.com&sz=32" width="18" alt=""> GitHub CLI</a> · <a href="https://desktop.github.com"><img src="https://www.google.com/s2/favicons?domain=desktop.github.com&sz=32" width="18" alt=""> GitHub Desktop</a> · <a href="https://zed.dev"><img src="https://www.google.com/s2/favicons?domain=zed.dev&sz=32" width="18" alt=""> Zed</a> · <a href="https://developers.openai.com/codex"><img src="https://www.google.com/s2/favicons?domain=developers.openai.com&sz=32" width="18" alt=""> Codex</a> · <a href="https://go.dev"><img src="https://www.google.com/s2/favicons?domain=go.dev&sz=32" width="18" alt=""> Go</a> · <a href="https://rust-lang.github.io/rustup"><img src="https://www.google.com/s2/favicons?domain=rust-lang.org&sz=32" width="18" alt=""> Rustup</a> |
| Shell And CLI | <a href="https://fishshell.com"><img src="https://www.google.com/s2/favicons?domain=fishshell.com&sz=32" width="18" alt=""> fish</a> · <a href="https://starship.rs"><img src="https://www.google.com/s2/favicons?domain=starship.rs&sz=32" width="18" alt=""> Starship</a> · <a href="https://github.com/ajeetdsouza/zoxide"><img src="https://www.google.com/s2/favicons?domain=github.com&sz=32" width="18" alt=""> zoxide</a> · <a href="https://github.com/BurntSushi/ripgrep"><img src="https://www.google.com/s2/favicons?domain=github.com&sz=32" width="18" alt=""> ripgrep</a> · <a href="https://github.com/sharkdp/fd"><img src="https://www.google.com/s2/favicons?domain=github.com&sz=32" width="18" alt=""> fd</a> · <a href="https://jqlang.github.io/jq"><img src="https://www.google.com/s2/favicons?domain=jqlang.github.io&sz=32" width="18" alt=""> jq</a> · <a href="https://github.com/sharkdp/bat"><img src="https://www.google.com/s2/favicons?domain=github.com&sz=32" width="18" alt=""> bat</a> · <a href="https://eza.rocks"><img src="https://www.google.com/s2/favicons?domain=eza.rocks&sz=32" width="18" alt=""> eza</a> · <a href="https://semgrep.dev"><img src="https://www.google.com/s2/favicons?domain=semgrep.dev&sz=32" width="18" alt=""> Semgrep</a> · <a href="https://github.com/sharkdp/hyperfine"><img src="https://www.google.com/s2/favicons?domain=github.com&sz=32" width="18" alt=""> hyperfine</a> · <a href="https://www.gnu.org/software/wget/"><img src="https://www.google.com/s2/favicons?domain=gnu.org&sz=32" width="18" alt=""> wget</a> |
| Containers | <a href="https://www.docker.com"><img src="https://www.google.com/s2/favicons?domain=docker.com&sz=32" width="18" alt=""> Docker CLI</a> · <a href="https://github.com/abiosoft/colima"><img src="https://www.google.com/s2/favicons?domain=github.com&sz=32" width="18" alt=""> Colima</a> |
| Browsers And Web Testing | <a href="https://www.mozilla.org/firefox/"><img src="https://www.google.com/s2/favicons?domain=mozilla.org&sz=32" width="18" alt=""> Firefox</a> · <a href="https://www.google.com/chrome/"><img src="https://www.google.com/s2/favicons?domain=google.com&sz=32" width="18" alt=""> Chrome</a> · <a href="https://helium.computer"><img src="https://www.google.com/s2/favicons?domain=helium.computer&sz=32" width="18" alt=""> Helium</a> · <a href="https://polypane.app"><img src="https://www.google.com/s2/favicons?domain=polypane.app&sz=32" width="18" alt=""> Polypane</a> · <a href="https://sindresorhus.com/velja"><img src="https://www.google.com/s2/favicons?domain=sindresorhus.com&sz=32" width="18" alt=""> Velja</a> |
| AI And Agents | <a href="https://claude.ai/download"><img src="https://www.google.com/s2/favicons?domain=claude.ai&sz=32" width="18" alt=""> Claude</a> · <a href="https://developers.openai.com/codex"><img src="https://www.google.com/s2/favicons?domain=developers.openai.com&sz=32" width="18" alt=""> Codex</a> · <a href="https://ollama.com"><img src="https://www.google.com/s2/favicons?domain=ollama.com&sz=32" width="18" alt=""> Ollama</a> · <a href="https://cmux.com/docs/getting-started"><img src="https://www.google.com/s2/favicons?domain=cmux.com&sz=32" width="18" alt=""> cmux</a> |
| Creative And Media | <a href="https://affinity.serif.com"><img src="https://www.google.com/s2/favicons?domain=affinity.serif.com&sz=32" width="18" alt=""> Affinity</a> · <a href="https://iina.io"><img src="https://www.google.com/s2/favicons?domain=iina.io&sz=32" width="18" alt=""> IINA</a> · <a href="https://imageoptim.com/mac"><img src="https://www.google.com/s2/favicons?domain=imageoptim.com&sz=32" width="18" alt=""> ImageOptim</a> · <a href="https://software.charliemonroe.net/downie/"><img src="https://www.google.com/s2/favicons?domain=software.charliemonroe.net&sz=32" width="18" alt=""> Downie</a> · <a href="https://software.charliemonroe.net/permute/"><img src="https://www.google.com/s2/favicons?domain=software.charliemonroe.net&sz=32" width="18" alt=""> Permute</a> · <a href="https://www.makemkv.com"><img src="https://www.google.com/s2/favicons?domain=makemkv.com&sz=32" width="18" alt=""> MakeMKV</a> · <a href="https://apps.apple.com/app/id984968384"><img src="https://www.google.com/s2/favicons?domain=apps.apple.com&sz=32" width="18" alt=""> Redacted</a> |
| Writing And Office | <a href="https://www.apple.com/pages/"><img src="https://www.google.com/s2/favicons?domain=apple.com&sz=32" width="18" alt=""> Pages</a> · <a href="https://www.apple.com/keynote/"><img src="https://www.google.com/s2/favicons?domain=apple.com&sz=32" width="18" alt=""> Keynote</a> · <a href="https://www.apple.com/numbers/"><img src="https://www.google.com/s2/favicons?domain=apple.com&sz=32" width="18" alt=""> Numbers</a> · <a href="https://www.microsoft.com/microsoft-365/word"><img src="https://www.google.com/s2/favicons?domain=microsoft.com&sz=32" width="18" alt=""> Word</a> · <a href="https://www.microsoft.com/microsoft-365/excel"><img src="https://www.google.com/s2/favicons?domain=microsoft.com&sz=32" width="18" alt=""> Excel</a> · <a href="https://www.microsoft.com/microsoft-365/powerpoint"><img src="https://www.google.com/s2/favicons?domain=microsoft.com&sz=32" width="18" alt=""> PowerPoint</a> · <a href="https://ia.net/writer"><img src="https://www.google.com/s2/favicons?domain=ia.net&sz=32" width="18" alt=""> iA Writer</a> · <a href="https://pdfexpert.com"><img src="https://www.google.com/s2/favicons?domain=pdfexpert.com&sz=32" width="18" alt=""> PDF Expert</a> |
| Communication And Planning | <a href="https://www.whatsapp.com/download"><img src="https://www.google.com/s2/favicons?domain=whatsapp.com&sz=32" width="18" alt=""> WhatsApp</a> · <a href="https://telegram.org"><img src="https://www.google.com/s2/favicons?domain=telegram.org&sz=32" width="18" alt=""> Telegram</a> · <a href="https://zoom.us/download"><img src="https://www.google.com/s2/favicons?domain=zoom.us&sz=32" width="18" alt=""> Zoom</a> · <a href="https://culturedcode.com/things/"><img src="https://www.google.com/s2/favicons?domain=culturedcode.com&sz=32" width="18" alt=""> Things</a> · <a href="https://flexibits.com/fantastical"><img src="https://www.google.com/s2/favicons?domain=flexibits.com&sz=32" width="18" alt=""> Fantastical</a> · <a href="https://parcel.app"><img src="https://www.google.com/s2/favicons?domain=parcel.app&sz=32" width="18" alt=""> Parcel</a> |
| System And Personal Utilities | <a href="https://1password.com"><img src="https://www.google.com/s2/favicons?domain=1password.com&sz=32" width="18" alt=""> 1Password</a> · <a href="https://www.backblaze.com"><img src="https://www.google.com/s2/favicons?domain=backblaze.com&sz=32" width="18" alt=""> Backblaze</a> · <a href="https://tailscale.com"><img src="https://www.google.com/s2/favicons?domain=tailscale.com&sz=32" width="18" alt=""> Tailscale</a> · <a href="https://daisydiskapp.com"><img src="https://www.google.com/s2/favicons?domain=daisydiskapp.com&sz=32" width="18" alt=""> DaisyDisk</a> · <a href="https://moneymoney-app.com"><img src="https://www.google.com/s2/favicons?domain=moneymoney-app.com&sz=32" width="18" alt=""> MoneyMoney</a> · <a href="https://sindresorhus.com/pure-paste"><img src="https://www.google.com/s2/favicons?domain=sindresorhus.com&sz=32" width="18" alt=""> Pure Paste</a> · <a href="https://sindresorhus.com/lungo"><img src="https://www.google.com/s2/favicons?domain=sindresorhus.com&sz=32" width="18" alt=""> Lungo</a> · <a href="https://noiz.io"><img src="https://www.google.com/s2/favicons?domain=noiz.io&sz=32" width="18" alt=""> Noizio</a> |

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
~/.colima/default/colima.yaml
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
- Containers use the Docker CLI with Colima as the lightweight local runtime.
- Colima is configured for native Apple Silicon with VZ, virtiofs, Docker runtime, BuildKit, no default amd64 emulation, and a writable `~/Workspace` mount.
- Browser coverage includes Firefox, Chrome, Helium, and Polypane.
- App coverage includes GitHub Desktop, cmux, Claude, Codex, Ollama, creative/media utilities, communication apps, backup, finance, and reviewed Mac App Store apps.

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
colima status
docker context ls
```

## Adapting This For Yourself

Start with these files:

- `Brewfile`: remove apps you do not use and add your own.
- `dotfiles/chezmoi/dot_gitconfig`: change identity, signing, and aliases.
- `dotfiles/chezmoi/private_dot_config/fish/config.fish`: adjust shell defaults.
- `dotfiles/chezmoi/private_dot_config/ghostty/config`: adjust cmux/Ghostty behavior.
- `dotfiles/chezmoi/private_dot_colima/default/colima.yaml`: adjust the default Colima VM resources and mounts.
- `macos/defaults.sh`: review every setting before applying it.

Good first customizations:

- Replace the Git identity and signing key.
- Review Mac App Store entries.
- Adjust Dock items in `macos/defaults.sh`.
- Decide which browsers, communication apps, creative/media tools, cmux, Zed, Go, Rust, and container tools fit your workflow.
- Add or remove shell helpers in `dotfiles/chezmoi/private_dot_local/bin`.

## Still Manual

- Sign in to 1Password and enable the SSH Agent.
- Sign in to GitHub CLI with `gh auth login`.
- Verify GitHub SSH auth in a normal terminal:
  `ssh -T git@github.com`
- Sign in to the Mac App Store before relying on MAS checks.
- Re-run `scripts/doctor.sh` after changing packages, dotfiles, or macOS defaults.
