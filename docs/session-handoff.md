# Session Handoff

Stand: 2026-05-12

Dieses Dokument ist der Einstiegspunkt fuer eine neue Codex-Session.

## Repo

```text
~/Workspace/effective-mac-setup
https://github.com/sebastian-software/effective-mac-setup
```

Das GitHub-Repo ist public. `main` ist gepusht.

Letzter bekannter Commit:

```text
84b22b2 chore: initialize effective mac setup
```

Commit-Stil: Conventional Commits.

## Ziel

Ein leichtgewichtiges, schnelles MacBook-Setup als Alternative zum Mac Studio, mit Fokus auf React/TypeScript-Entwicklung.

Das Repo soll gleichzeitig Installationsanleitung, Statusprotokoll, Brewfile und spaeter Dotfile-Quelle sein.

## Erledigt

- Repo nach `~/Workspace/effective-mac-setup` verschoben.
- GitHub-Repo `sebastian-software/effective-mac-setup` angelegt.
- Initial Commit auf Conventional Commit umbenannt.
- `fnm` via Homebrew installiert.
- Node.js LTS 24.15.0 via `fnm` installiert.
- Corepack aktiviert.
- `pnpm` initialisiert.
- `gh auth status` im normalen Kontext erfolgreich verifiziert.
- SSH-Setup bewusst als 1Password SSH Agent dokumentiert.
- Erste Doku-Struktur angelegt:
  - `README.md`
  - `Brewfile`
  - `docs/status.md`
  - `docs/todo.md`
  - `docs/decisions.md`
  - `docs/dotfiles-plan.md`

## Offene Hauptidee

Dotfiles sollen wahrscheinlich nicht nur kopiert werden, sondern per Symlink aus diesem Repo verwaltet werden.

Geplantes Modell:

```text
~/.gitconfig -> repo/dotfiles/managed/gitconfig
~/.zshrc     -> repo/dotfiles/managed/zshrc
~/.zprofile  -> repo/dotfiles/managed/zprofile

~/.gitconfig.local
~/.zshrc.local
~/.zprofile.local
```

Die `.local` Dateien bleiben privat und maschinenspezifisch.

## Naechster sinnvoller Arbeitsblock

1. `dotfiles/templates` nach `dotfiles/managed` und `dotfiles/examples` umbauen.
2. TypeScript-Tooling fuer das Repo hinzufuegen.
3. `scripts/dotfiles.ts` implementieren.
4. CLI-Kommandos bereitstellen:

```sh
pnpm dotfiles:check
pnpm dotfiles:apply
pnpm dotfiles:repair
```

5. Erst nur `check` implementieren und ausfuehren.
6. Dann `apply` mit sicherem Verhalten.
7. Danach `repair` mit Backups.

Details: [dotfiles-plan.md](dotfiles-plan.md)

## Sicherheitsregeln fuer Dotfiles

- Keine echte Datei ueberschreiben.
- Vor Veraenderungen Backup anlegen.
- Private `.local` Dateien nie ins Repo kopieren.
- Symlink-Ziele muessen innerhalb dieses Repos liegen.
- `check` muss immer ohne Schreibzugriff funktionieren.
- `apply` darf nur fehlende Dinge anlegen.
- `repair` darf bestehende Dateien nur nach Backup ersetzen.

## Noch offen im Mac-Setup

- Git-Identitaet final in `~/.gitconfig.local` setzen.
- 1Password SSH Agent mit GitHub pruefen:

```sh
ssh -T git@github.com
```

- `brew bundle --file Brewfile` ausfuehren.
- Editor-Entscheidung finalisieren: VS Code, Cursor oder beide.
- Browser installieren/pruefen: Chrome, Firefox, Safari.
- OrbStack nur installieren, wenn Container/Docker lokal wirklich gebraucht werden.
- Vite React/TypeScript Smoke-Test dokumentieren.
- Next.js App Router Smoke-Test dokumentieren.

## Wichtige Konventionen

- Sprache der Doku: Deutsch, aber technische Begriffe pragmatisch Englisch.
- Dateien bisher ASCII-only.
- Commit-Messages: Conventional Commits.
- Repo soll schlank bleiben, kein grosses Dotfiles-Framework werden.

## Empfohlener Start in neuer Session

```sh
cd ~/Workspace/effective-mac-setup
git status --short --branch
git pull --ff-only
sed -n '1,220p' docs/session-handoff.md
```

Dann mit dem TypeScript-Dotfile-Manager beginnen.
