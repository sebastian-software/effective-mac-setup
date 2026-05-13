# Dotfiles Plan

Goal: this repo should become the source of truth for shared dotfiles while keeping private and machine-specific values outside the public repository.

## Recommendation

Use `chezmoi` instead of building a custom TypeScript dotfile manager.

`chezmoi` already solves the hard parts that were planned for a custom script:

- track dotfiles in a source directory
- preview changes before applying them
- apply dotfiles safely across machines
- support machine-specific templates
- keep secrets out of the public repo
- run setup scripts when needed
- integrate with password managers and encryption workflows later

This keeps the repository lean and avoids maintaining our own dotfile framework.

## Why Not Build Our Own Manager?

The previous plan proposed a TypeScript CLI with:

- `pnpm dotfiles:check`
- `pnpm dotfiles:apply`
- `pnpm dotfiles:repair`

That would work, but most of the complexity is not specific to this setup:

- detecting files vs symlinks
- handling broken or wrong links
- showing diffs
- backing up existing files
- applying changes idempotently
- supporting machine-specific variations
- avoiding accidental leakage of private values

Those are exactly the long-lived edge cases a dedicated dotfile manager should own.

## Proposed Model

Use Homebrew Bundle for installing `chezmoi`:

```ruby
brew "chezmoi"
```

Use this repo as the user-facing setup repository. Dotfiles can either stay inside this repo or move into a dedicated dotfiles repo later if the setup grows.

For now, keep the scope small:

```text
dotfiles/
  templates/
    git/
    zsh/
```

Then migrate into `chezmoi` deliberately:

```text
~/.local/share/chezmoi/
  dot_gitconfig
  dot_gitignore_global
  dot_zprofile
  dot_zshrc
```

Private values should remain local:

```text
~/.gitconfig.local
~/.zshrc.local
~/.zprofile.local
```

The managed files should continue to load those local files.

## Safety Rules

- Do not overwrite existing home-directory files without reviewing `chezmoi diff`.
- Do not commit private `.local` files.
- Keep Git identity, private aliases, tokens, hostnames, and machine-specific paths outside the repo.
- Prefer `chezmoi diff` before `chezmoi apply`.
- Prefer small migrations over importing a whole home directory.

## Initial Workflow

Install:

```sh
brew bundle --file Brewfile
```

Inspect current state:

```sh
chezmoi doctor
chezmoi status
```

Initialize dotfile management when ready:

```sh
chezmoi init
```

Add files one by one:

```sh
chezmoi add ~/.gitconfig
chezmoi add ~/.gitignore_global
chezmoi add ~/.zprofile
chezmoi add ~/.zshrc
```

Review before applying:

```sh
chezmoi diff
chezmoi apply
```

## Open Questions

- Should dotfiles live in this setup repo or in a separate dotfiles repo?
- Should `chezmoi` use plain files first, or templates immediately?
- Should 1Password integration be used later for private values, or should `.local` files remain purely local?

## Decision

Adopt `chezmoi` as the dotfile manager candidate and add it to the Brewfile.

Do not implement the custom TypeScript dotfile manager unless `chezmoi` proves too heavy or mismatched in practice.
