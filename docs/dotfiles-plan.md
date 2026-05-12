# Dotfiles Plan

Ziel: Dieses Repo wird die Quelle der Wahrheit fuer gemeinsam nutzbare Dotfiles. Private oder maschinenspezifische Werte bleiben in `.local` Dateien ausserhalb des Repos.

## Grundmodell

Hybrid aus Symlinks und lokalen Erweiterungen:

```text
~/.gitconfig -> <repo>/dotfiles/managed/gitconfig
~/.zshrc     -> <repo>/dotfiles/managed/zshrc
~/.zprofile  -> <repo>/dotfiles/managed/zprofile

~/.gitconfig.local  # privat, nicht versioniert
~/.zshrc.local      # privat, nicht versioniert
~/.zprofile.local   # privat, nicht versioniert
```

Die versionierten Dateien laden lokale Erweiterungen:

```ini
# gitconfig
[include]
  path = ~/.gitconfig.local
```

```sh
# zshrc
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
```

## Warum Symlinks?

- Aenderungen an Dotfiles sind sofort im Repo sichtbar.
- Neue Macs koennen mit einem Befehl auf denselben Stand gebracht werden.
- Das Setup bleibt transparent: `ls -la ~/.zshrc` zeigt klar auf dieses Repo.

## Warum `.local` Dateien?

- Name, E-Mail, private Aliase, Tokens und maschinenspezifische Pfade bleiben ausserhalb des Repos.
- Unterschiedliche Macs koennen kleine Unterschiede haben, ohne Forks der Dotfiles.
- Das Repo bleibt teilbar/veroeffentlichbar.

## Warum TypeScript statt Bash?

Ein Dotfile-Manager wird schnell komplex:

- bestehende Dateien erkennen
- echte Dateien von Symlinks unterscheiden
- kaputte Symlinks reparieren
- Backups mit Zeitstempel anlegen
- Check-Modus ohne Aenderungen
- klare Diff-/Status-Ausgabe
- Fehler gesammelt und lesbar melden

TypeScript macht diese Logik robuster und testbarer als ein wachsendes Bash-Script.

## Vorgeschlagene Struktur

```text
dotfiles/
  managed/
    gitconfig
    gitignore_global
    zprofile
    zshrc
  examples/
    gitconfig.local
    zshrc.local
    zprofile.local

scripts/
  dotfiles.ts

package.json
tsconfig.json
```

## Dotfile Manifest

Die verwalteten Links sollten nicht im Code verstreut sein, sondern in einem Manifest:

```ts
const links = [
  {
    name: "gitconfig",
    source: "dotfiles/managed/gitconfig",
    target: "~/.gitconfig",
    localExample: "dotfiles/examples/gitconfig.local",
    localTarget: "~/.gitconfig.local",
  },
  {
    name: "zshrc",
    source: "dotfiles/managed/zshrc",
    target: "~/.zshrc",
    localExample: "dotfiles/examples/zshrc.local",
    localTarget: "~/.zshrc.local",
  },
];
```

## CLI Verhalten

```sh
pnpm dotfiles:check
pnpm dotfiles:apply
pnpm dotfiles:repair
```

### `check`

Nur lesen, nichts aendern.

Ausgabe pro Datei:

- `linked`: Ziel zeigt korrekt ins Repo
- `missing`: Ziel fehlt
- `file`: Ziel ist eine echte Datei
- `wrong-link`: Ziel ist ein Symlink, aber zeigt woanders hin
- `broken-link`: Ziel ist ein kaputter Symlink
- `local-missing`: `.local` Datei fehlt

### `apply`

Sicherer Standardmodus:

- fehlende Ziele werden verlinkt
- fehlende `.local` Dateien werden aus Examples erstellt
- bestehende echte Dateien werden nicht ueberschrieben
- Konflikte werden gemeldet

### `repair`

Aktiver Reparaturmodus:

- falsche oder kaputte Symlinks werden ersetzt
- bestehende echte Dateien werden mit Zeitstempel gesichert
- danach wird der korrekte Symlink gesetzt

Backup-Format:

```text
~/.zshrc.backup-20260512-163000
```

## Sicherheitsregeln

- Keine Datei loeschen.
- Keine echte Datei ueberschreiben.
- Vor Ersetzen immer Backup anlegen.
- Symlink-Ziele muessen innerhalb dieses Repos liegen.
- Private `.local` Dateien werden nie zurueck ins Repo kopiert.

## Umsetzungsschritte

1. Aktuelle `dotfiles/templates` nach `dotfiles/managed` und `dotfiles/examples` umbauen.
2. `package.json` mit `tsx` oder direktem Node-TypeScript-Runner anlegen.
3. `scripts/dotfiles.ts` mit Manifest und `check` implementieren.
4. `apply` implementieren.
5. `repair` implementieren.
6. README und TODO aktualisieren.
7. Erst `pnpm dotfiles:check`, dann manuell pruefen.
8. Danach `pnpm dotfiles:apply`.

## Offene Entscheidung

Das Repo sollte vor dem echten Symlink-Setup an einen stabilen Ort umziehen, z.B.:

```text
~/Workspace/effective-mac-setup
```

Der aktuelle Codex-Arbeitsordner ist fuer Experimente okay, wirkt aber nicht wie der dauerhafte Zielpfad fuer ein Dotfiles-Repo.
