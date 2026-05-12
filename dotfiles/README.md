# Dotfile Templates

Dieser Ordner enthaelt bewusst kleine, replizierbare Vorlagen fuer neue Macs.

Prinzip:

- Versioniert werden Defaults, Aliase und sinnvolle Tool-Konfiguration.
- Private Werte bleiben lokal.
- Bestehende Dateien werden nicht automatisch ueberschrieben.

## Git

Die globale Git-Konfiguration wird in zwei Teile getrennt:

- `~/.gitconfig`: versionierbare Defaults aus `templates/git/gitconfig`
- `~/.gitconfig.local`: private Identitaet, nicht versionieren

Beispiel fuer `~/.gitconfig.local`:

```ini
[user]
  name = Sebastian Werner
  email = sebastian@example.com
```

Anwenden:

```sh
scripts/apply-dotfiles.sh
```

Danach pruefen:

```sh
git config --global --list
```

## Shell

Die Shell-Templates sind bewusst minimal:

- `templates/zsh/zprofile` laedt Homebrew.
- `templates/zsh/zshrc` laedt fnm und starship.

Falls ein Mac bereits eigene Shell-Dateien hat, erst vergleichen und dann gezielt uebernehmen.
