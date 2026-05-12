# Session Handoff

Date: 2026-05-12

This document is the entry point for a new Codex session.

## Repo

```text
~/Workspace/effective-mac-setup
https://github.com/sebastian-software/effective-mac-setup
```

The GitHub repo is public. `main` is pushed.

GitHub Description:

```text
Effective macOS setup for a lightweight React and TypeScript development environment.
```

GitHub Topics:

```text
developer-setup, dotfiles, homebrew, macos, react, typescript
```

Additional Labels:

```text
setup, dotfiles, macos, typescript, automation, safe-change
```

Latest known commit before this translation work:

```text
6ce9bb5 docs: document github metadata
```

Commit style: Conventional Commits.

## Goal

A lightweight, fast MacBook setup as an alternative to the Mac Studio, focused on React/TypeScript development.

The repo should serve as installation guide, status log, Brewfile, and eventually the dotfile source of truth.

## Done

- Moved the repo to `~/Workspace/effective-mac-setup`.
- Created GitHub repo `sebastian-software/effective-mac-setup`.
- Made the GitHub repo public.
- Renamed the initial commit to a Conventional Commit.
- Installed `fnm` via Homebrew.
- Installed Node.js LTS 24.15.0 via `fnm`.
- Enabled Corepack.
- Initialized `pnpm`.
- Verified `gh auth status` in a normal terminal context.
- Documented SSH setup as intentionally using the 1Password SSH Agent.
- Created the initial documentation structure:
  - `README.md`
  - `Brewfile`
  - `docs/status.md`
  - `docs/todo.md`
  - `docs/decisions.md`
  - `docs/dotfiles-plan.md`

## Main Open Idea

Dotfiles should probably not be copied. They should be managed as symlinks from this repo.

Planned model:

```text
~/.gitconfig -> repo/dotfiles/managed/gitconfig
~/.zshrc     -> repo/dotfiles/managed/zshrc
~/.zprofile  -> repo/dotfiles/managed/zprofile

~/.gitconfig.local
~/.zshrc.local
~/.zprofile.local
```

The `.local` files stay private and machine-specific.

## Next Useful Work Block

1. Reorganize `dotfiles/templates` into `dotfiles/managed` and `dotfiles/examples`.
2. Add TypeScript tooling for the repo.
3. Implement `scripts/dotfiles.ts`.
4. Provide CLI commands:

```sh
pnpm dotfiles:check
pnpm dotfiles:apply
pnpm dotfiles:repair
```

5. Implement and run `check` first.
6. Then implement safe `apply` behavior.
7. Afterwards implement `repair` with backups.

Details: [dotfiles-plan.md](dotfiles-plan.md)

## Safety Rules for Dotfiles

- Do not overwrite real files.
- Create backups before changes.
- Never copy private `.local` files back into the repo.
- Symlink targets must point inside this repo.
- `check` must always work without write access.
- `apply` may only create missing things.
- `repair` may replace existing files only after creating a backup.

## Still Open in the Mac Setup

- Set final Git identity in `~/.gitconfig.local`.
- Verify the 1Password SSH Agent with GitHub:

```sh
ssh -T git@github.com
```

- Run `brew bundle --file Brewfile`.
- Finalize editor decision: VS Code, Cursor, or both.
- Install/check browsers: Chrome, Firefox, Safari.
- Install OrbStack only if local Docker/container workflows are actually needed.
- Document a Vite React/TypeScript smoke test.
- Document a Next.js App Router smoke test.

## Important Conventions

- Documentation language: English.
- Files should stay ASCII-only unless there is a clear reason otherwise.
- Commit messages: Conventional Commits.
- The repo should stay lean, not become a large dotfiles framework.

## Recommended Start in a New Session

```sh
cd ~/Workspace/effective-mac-setup
git status --short --branch
git pull --ff-only
sed -n '1,220p' docs/session-handoff.md
```

Then start with the TypeScript dotfile manager.
