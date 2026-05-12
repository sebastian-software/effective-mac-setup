# Status

Date: 2026-05-12

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
| Git | Apple Git 2.50.1 available; Homebrew Git is listed in the Brewfile |
| Git user.name | Still open |
| Git user.email | Still open |
| GitHub CLI | 2.92.0 installed |
| GitHub Login | Verified in a normal terminal: account `swernerx`, SSH protocol, token in the keyring. |
| SSH Agent | Intentionally handled by the 1Password SSH Agent; not meaningful to verify from the Codex sandbox. |
| fnm | 1.39.0 installed |
| Node.js | 24.15.0 LTS via fnm |
| npm | 11.12.1 |
| Corepack | 0.34.6 |
| pnpm | 11.1.1 |
| Go | Planned in Brewfile; not yet verified |
| Rust | Planned in Brewfile; not yet verified |

## Apps Found

- 1Password
- Backblaze
- Codex
- Fantastical
- Lungo
- Microsoft Office apps
- Pure Paste
- Safari
- Tailscale
- Velja
- Xcode

## Changes Already Made

`~/.zshrc` was extended for fnm:

```sh
# Node.js version manager
eval "$(fnm env --use-on-cd --shell zsh)"
```

`~/.zprofile` already contained the Homebrew shellenv setup:

```sh
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

## Repo

Stable path:

```text
~/Workspace/effective-mac-setup
```

## Assumptions

- SSH keys are not generated or managed directly under `~/.ssh`; they are handled by the 1Password SSH Agent.
- GitHub CLI login is verified in a normal terminal/keychain context. Codex may see a different access context.
