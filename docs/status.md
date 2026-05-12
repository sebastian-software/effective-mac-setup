# Status

Stand: 2026-05-12

## System

| Bereich | Status |
| --- | --- |
| macOS | 26.5, Build 25F71 |
| Architektur | Apple Silicon `arm64` |
| Xcode Command Line Tools | Installiert: `/Library/Developer/CommandLineTools` |
| Homebrew | 5.1.11 |
| Homebrew Prefix | `/opt/homebrew` |

## Entwicklung

| Tool | Status |
| --- | --- |
| Git | Apple Git 2.50.1 vorhanden; Homebrew Git im Brewfile vorgesehen |
| Git user.name | Noch offen |
| Git user.email | Noch offen |
| GitHub CLI | 2.92.0 installiert |
| GitHub Login | Verifiziert im normalen Terminal: Account `swernerx`, SSH-Protokoll, Token im Keyring. |
| SSH-Agent | Laeuft bewusst ueber 1Password SSH Agent; in Codex-Sandbox nicht sinnvoll pruefbar. |
| fnm | 1.39.0 installiert |
| Node.js | 24.15.0 LTS via fnm |
| npm | 11.12.1 |
| Corepack | 0.34.6 |
| pnpm | 11.1.1 |

## Apps gefunden

- 1Password
- Backblaze
- Codex
- Fantastical
- Lungo
- Microsoft Office Apps
- Pure Paste
- Safari
- Tailscale
- Velja
- Xcode

## Bereits geaendert

`~/.zshrc` wurde um fnm erweitert:

```sh
# Node.js version manager
eval "$(fnm env --use-on-cd --shell zsh)"
```

`~/.zprofile` enthielt bereits Homebrew shellenv:

```sh
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

## Repo

Stabiler Pfad:

```text
~/Workspace/effective-mac-setup
```

## Bewusste Annahmen

- SSH-Keys werden nicht klassisch unter `~/.ssh` generiert oder verwaltet, sondern ueber den 1Password SSH Agent.
- GitHub CLI Login wird im normalen Terminal/Keychain-Kontext geprueft. Codex kann hier einen anderen Zugriffskontext sehen.
