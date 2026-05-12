# TODO

Prioritized list for the React/TypeScript notebook setup.

## New Session

- [ ] Read the entry point in [session-handoff.md](session-handoff.md).
- [ ] Check repository status:
  - `git status --short --branch`
  - `git pull --ff-only`

## Done

- [x] Checked macOS version and architecture.
- [x] Checked Xcode Command Line Tools.
- [x] Checked Homebrew.
- [x] Installed `fnm` via Homebrew.
- [x] Extended `~/.zshrc` for `fnm`.
- [x] Installed Node.js LTS 24.15.0 via `fnm`.
- [x] Enabled Corepack.
- [x] Initialized `pnpm` through Corepack.
- [x] Initialized this setup as a Git repository.

## Next

- [ ] Finalize the dotfile symlink concept:
  - `docs/dotfiles-plan.md`
- [x] Moved the repo to a stable path: `~/Workspace/effective-mac-setup`.
- [ ] Implement the TypeScript dotfile manager:
  - `pnpm dotfiles:check`
  - `pnpm dotfiles:apply`
  - `pnpm dotfiles:repair`
- [ ] Set Git identity in `~/.gitconfig.local`:
  - `git config --global user.name "Your Name"`
  - `git config --global user.email "your@email"`
- [x] Verified GitHub CLI in a normal terminal:
  - `gh auth status`
- [ ] Verify the 1Password SSH Agent in a normal terminal:
  - `ssh -T git@github.com`
- [ ] Run `brew bundle --file Brewfile` to install missing CLI tools and apps.
- [ ] Open a new terminal and verify the Node setup:
  - `node --version`
  - `npm --version`
  - `pnpm --version`

## Editor

- [ ] Decide on VS Code, Cursor, or both.
- [ ] Check the VS Code shell command:
  - `code --version`
- [ ] Install extensions:
  - ESLint
  - Prettier
  - Tailwind CSS IntelliSense
  - Playwright Test for VS Code
  - Pretty TypeScript Errors
  - GitLens optional
  - Error Lens optional

## Browsers and Runtime

- [ ] Install Chrome.
- [ ] Install Firefox.
- [ ] Use Safari for WebKit checks.
- [ ] Install OrbStack if Docker/containers are actually needed.

## Project Templates

- [ ] Create a Vite React/TypeScript smoke test.
- [ ] Create a Next.js App Router smoke test.
- [ ] Document shared project standards:
  - `pnpm`
  - TypeScript strict mode
  - ESLint
  - Prettier
  - Vitest
  - Playwright

## macOS and Work Comfort

- [ ] Check FileVault in System Settings.
- [ ] Check Touch ID and Apple Watch Unlock.
- [x] 1Password is installed; the SSH Agent is used through it.
- [ ] Check Backblaze backup status.
- [ ] Check Tailscale login/network status.
- [ ] Check or install Raycast.
- [ ] Decide between Maccy and the existing Pure Paste setup for clipboard handling.

## Optional

- [ ] Enable `direnv` for project-specific environments.
- [ ] Create a separate dotfiles repo or extend this repo for that purpose.
- [ ] Trim the Brewfile to personal preferences.
- [ ] Document a CI check for an example project.
