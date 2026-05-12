# Dotfiles Plan

Goal: this repo becomes the source of truth for shared dotfiles. Private or machine-specific values stay in `.local` files outside the repo.

## Core Model

Hybrid model using symlinks plus local extensions:

```text
~/.gitconfig -> <repo>/dotfiles/managed/gitconfig
~/.zshrc     -> <repo>/dotfiles/managed/zshrc
~/.zprofile  -> <repo>/dotfiles/managed/zprofile

~/.gitconfig.local  # private, not versioned
~/.zshrc.local      # private, not versioned
~/.zprofile.local   # private, not versioned
```

The versioned files load local extensions:

```ini
# gitconfig
[include]
  path = ~/.gitconfig.local
```

```sh
# zshrc
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
```

## Why Symlinks?

- Dotfile changes are immediately visible in the repo.
- New Macs can be brought to the same state with one command.
- The setup stays transparent: `ls -la ~/.zshrc` clearly points to this repo.

## Why `.local` Files?

- Name, email, private aliases, tokens, and machine-specific paths stay outside the repo.
- Different Macs can have small differences without forking the dotfiles.
- The repo stays shareable/public.

## Why TypeScript Instead of Bash?

A dotfile manager gets complex quickly:

- detect existing files
- distinguish real files from symlinks
- repair broken symlinks
- create timestamped backups
- support check mode without writes
- print clear diff/status output
- collect and report errors clearly

TypeScript makes this logic more robust and testable than a growing Bash script.

## Proposed Structure

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

Managed links should not be scattered through the code. They should live in a manifest:

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

## CLI Behavior

```sh
pnpm dotfiles:check
pnpm dotfiles:apply
pnpm dotfiles:repair
```

### `check`

Read-only; changes nothing.

Output per file:

- `linked`: target points correctly into the repo
- `missing`: target is missing
- `file`: target is a real file
- `wrong-link`: target is a symlink, but points elsewhere
- `broken-link`: target is a broken symlink
- `local-missing`: `.local` file is missing

### `apply`

Safe default mode:

- missing targets are linked
- missing `.local` files are created from examples
- existing real files are not overwritten
- conflicts are reported

### `repair`

Active repair mode:

- wrong or broken symlinks are replaced
- existing real files are backed up with a timestamp
- the correct symlink is set afterwards

Backup format:

```text
~/.zshrc.backup-20260512-163000
```

## Safety Rules

- Do not delete files.
- Do not overwrite real files.
- Always create a backup before replacing anything.
- Symlink targets must point inside this repo.
- Private `.local` files are never copied back into the repo.

## Implementation Steps

1. Reorganize the current `dotfiles/templates` into `dotfiles/managed` and `dotfiles/examples`.
2. Add `package.json` with `tsx` or a direct Node TypeScript runner.
3. Implement `scripts/dotfiles.ts` with the manifest and `check`.
4. Implement `apply`.
5. Implement `repair`.
6. Update README and TODO.
7. Run `pnpm dotfiles:check` first, then inspect manually.
8. Run `pnpm dotfiles:apply` afterwards.

## Open Decision

The repo has already been moved to a stable location:

```text
~/Workspace/effective-mac-setup
```

This path is suitable for symlink-managed dotfiles.
