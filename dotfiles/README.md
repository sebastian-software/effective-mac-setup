# Dotfile Templates

This directory contains intentionally small, reproducible templates for new Macs.

Principles:

- Version defaults, aliases, and useful tool configuration.
- Do not automatically overwrite existing files.

## Git

The global Git configuration is managed directly:

- `~/.gitconfig`: versioned defaults and public GitHub noreply identity from `templates/git/gitconfig`

The Git email uses GitHub's noreply address to avoid publishing a personal email address in commits:

```ini
[user]
  name = Sebastian Werner
  email = swernerx@users.noreply.github.com
```

Apply:

```sh
scripts/apply-dotfiles.sh
```

Then verify:

```sh
git config --global --list
```

## Shell

The shell templates are intentionally minimal:

- `templates/zsh/zprofile` loads Homebrew.
- `templates/zsh/zshrc` loads fnm and starship.

If a Mac already has its own shell files, compare first and then merge intentionally.
