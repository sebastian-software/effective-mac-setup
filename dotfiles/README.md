# Dotfile Templates

This directory contains intentionally small, reproducible templates for new Macs.

Principles:

- Version defaults, aliases, and useful tool configuration.
- Keep private values local.
- Do not automatically overwrite existing files.

## Git

The global Git configuration is split into two parts:

- `~/.gitconfig`: versioned defaults from `templates/git/gitconfig`
- `~/.gitconfig.local`: private identity, not versioned

Example `~/.gitconfig.local`:

```ini
[user]
  name = Sebastian Werner
  email = sebastian@example.com
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
