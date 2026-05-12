# effective-mac-setup

Reproduzierbare, leichtgewichtige Entwicklungsumgebung fuer React- und TypeScript-Projekte auf macOS.

Ziel: Das Notebook bleibt schnell und schlank, ist aber fuer moderne Webentwicklung sofort nutzbar.

## Aktueller Stand

Geprueft am 2026-05-12:

- macOS 26.5, Build 25F71
- Apple Silicon (`arm64`)
- Xcode Command Line Tools installiert
- Homebrew 5.1.11 unter `/opt/homebrew`
- GitHub CLI 2.92.0 installiert, Login muss erneuert werden
- `fnm` 1.39.0 installiert
- Node.js LTS 24.15.0 via `fnm`
- npm 11.12.1
- Corepack 0.34.6
- pnpm 11.1.1

Details stehen in [docs/status.md](docs/status.md).

## Schnellstart auf einem frischen Mac

### 1. Xcode Command Line Tools

```sh
xcode-select --install
```

### 2. Homebrew

Homebrew nach offizieller Anleitung installieren:

https://docs.brew.sh/Installation.html

Danach pruefen:

```sh
brew --version
brew doctor
```

### 3. Pakete installieren

```sh
brew bundle --file Brewfile
```

### 4. Shell fuer Homebrew und fnm einrichten

`~/.zprofile`:

```sh
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

`~/.zshrc`:

```sh
eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(starship init zsh)"
```

Danach ein neues Terminalfenster oeffnen.

### 5. Node LTS installieren

```sh
fnm install --lts
fnm default lts-latest
fnm use lts-latest
corepack enable
pnpm --version
```

### 6. Git einrichten

```sh
git config --global user.name "Dein Name"
git config --global user.email "deine@email"
gh auth login
```

## Empfohlene Projekt-Defaults

- Neue einfache React-SPAs: Vite + React + TypeScript
- Produktnahe Webapps: Next.js App Router
- Package Manager: pnpm via Corepack
- Tests: Vitest fuer Unit/Component-Tests, Playwright fuer Browser/E2E
- Linting/Formatierung: ESLint + Prettier

## Naechste Schritte

Die priorisierte Liste steht in [docs/todo.md](docs/todo.md).

Fuer den Start in einer neuen Codex-Session gibt es ein kompaktes Handoff:

[docs/session-handoff.md](docs/session-handoff.md)

## Dotfiles

Wiederverwendbare Vorlagen fuer Git und Shell liegen in [dotfiles/](dotfiles/).

Die Git-Konfiguration ist absichtlich zweigeteilt:

- Versionierbare Defaults: `dotfiles/templates/git/gitconfig`
- Private Identitaet lokal: `~/.gitconfig.local`

Anwenden:

```sh
scripts/apply-dotfiles.sh
```
