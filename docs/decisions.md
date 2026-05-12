# Entscheidungen

Kurze Begruendung fuer die wichtigsten Setup-Entscheidungen.

## Node via fnm statt Homebrew Node

Homebrew bleibt der Paketmanager fuer CLI-Tools und Apps. Node.js selbst wird ueber `fnm` verwaltet, weil React/TypeScript-Projekte haeufig verschiedene Node-Versionen erwarten.

Vorteile:

- Projektnahe Node-Versionen ueber `.node-version` oder aehnliche Dateien.
- Schneller und schlanker als viele aeltere Node-Version-Manager.
- Weniger globale Kopplung als `brew install node`.
- Gute Kombination mit Corepack und pnpm.

## pnpm via Corepack

Corepack ist bei modernen Node-Versionen dabei und kann pnpm projektbezogen bereitstellen. Dadurch muss pnpm nicht zwingend als separates globales npm-Paket installiert werden.

## SSH ueber 1Password

SSH-Keys werden ueber den 1Password SSH Agent verwaltet. Dieses Setup erzeugt daher keinen neuen lokalen SSH-Key und aendert keine `~/.ssh/config`, solange das nicht explizit gewuenscht ist.

Pruefung im normalen Terminal:

```sh
ssh -T git@github.com
```

## GitHub CLI

`gh` ist installiert. Der Login sollte im normalen Terminal geprueft werden, weil Codex/Sandbox-Zugriffe auf Token oder Keychain abweichen koennen.

```sh
gh auth status
```

## Brewfile

Das `Brewfile` ist die reproduzierbare Paketliste. Es sollte bewusst klein bleiben und nur Tools enthalten, die auf diesem Notebook wirklich gebraucht werden.

## Dotfiles als Templates

Globale Konfigurationen wie Git, zsh und Aliase koennen in diesem Repo als Templates liegen. Private Werte werden ausgelagert.

Fuer Git wird diese Struktur verwendet:

- `~/.gitconfig`: gemeinsame Defaults
- `~/.gitconfig.local`: private Identitaet

Dadurch kann die gemeinsame Konfiguration versioniert werden, ohne Name, E-Mail oder maschinenspezifische Daten fest ins Repo zu schreiben.

Naechster Ausbau: Die Dotfiles sollen wahrscheinlich nicht nur kopiert, sondern per Symlink verwaltet werden. Der detaillierte Plan steht in [dotfiles-plan.md](dotfiles-plan.md).

## Scope dieses Repos

Dieses Repo dokumentiert:

- Maschinenstatus
- Installationsschritte
- Paketliste
- bewusste Entscheidungen
- naechste TODOs
- kleine Dotfile-Templates

Es soll kein grosses Dotfiles-Framework werden, kann spaeter aber Dotfiles aufnehmen, wenn das wirklich nuetzlich wird.
