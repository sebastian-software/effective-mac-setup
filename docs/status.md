# Status

Date: 2026-05-13

## System

| Area | Status |
| --- | --- |
| macOS | 26.5, build 25F71 |
| Architecture | Apple Silicon `arm64` |
| Xcode Command Line Tools | Installed: `/Library/Developer/CommandLineTools` |
| Homebrew | 5.1.11 |
| Homebrew prefix | `/opt/homebrew` |

## Development

| Tool | Status |
| --- | --- |
| Git | Homebrew Git 2.54.0 installed |
| Git user.name | `Sebastian Werner` through `~/.gitconfig.local` |
| Git user.email | `swernerx@users.noreply.github.com` through `~/.gitconfig.local` |
| GitHub CLI | 2.92.0 installed |
| GitHub Login | Verified in a normal terminal: account `swernerx`, SSH protocol, token in the keyring. |
| SSH Agent | Intentionally handled by the 1Password SSH Agent; not meaningful to verify from the Codex sandbox. |
| fnm | 1.39.0 installed |
| Node.js | 24.15.0 LTS via fnm |
| npm | 11.12.1 |
| Corepack | 0.34.6 |
| pnpm | 11.1.1 |
| Go | 1.26.3 installed |
| Rust | rustup 1.29.0 with rustc/cargo 1.95.0 stable installed |
| chezmoi | 2.70.3 installed and configured in symlink mode |
| mas | 7.0.0 installed; `mas config` works, `mas list` hung during train-network setup |

## Apps Found

- 1Password
- Backblaze
- Codex
- Fantastical
- Firefox
- GitHub Desktop
- Zed 1.1.8
- Google Chrome (installed, but intentionally not tracked in the Brewfile yet)
- Lungo
- Microsoft Office apps
- Pure Paste
- Safari
- Tailscale
- Velja
- Xcode

## Changes Already Made

Homebrew Bundle has installed the curated Brewfile. The deprecated `tap "homebrew/bundle"` entry was removed because the tap is now empty/deprecated.

`chezmoi` is configured locally:

```toml
sourceDir = "/Users/sebastian/Workspace/effective-mac-setup/dotfiles/chezmoi"
mode = "symlink"
```

Managed home files are symlinks into this repo:

```text
~/.gitconfig
~/.gitignore_global
~/.zprofile
~/.zshrc
```

Private local files stay outside the repo:

```text
~/.gitconfig.local
~/.zprofile.local
~/.zshrc.local
```

`~/.zshrc` loads fnm, starship, Cargo when available, and `~/.zshrc.local`:

```sh
eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(starship init zsh)"
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
```

`~/.zprofile` loads Homebrew and `~/.zprofile.local`:

```sh
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
[[ -f "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
```

## Repo

Stable path:

```text
~/Workspace/effective-mac-setup
```

## Assumptions

- SSH keys are not generated or managed directly under `~/.ssh`; they are handled by the 1Password SSH Agent.
- GitHub CLI login is verified in a normal terminal/keychain context. Codex may see a different access context.
