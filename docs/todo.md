# TODO

Prioritized list for the macOS developer setup.

## New Session

- [ ] Read the entry point in [session-handoff.md](session-handoff.md).
- [ ] Check repository status:
  - `git status --short --branch`
  - `git pull --ff-only`

## Done

- [x] Checked macOS version and architecture.
- [x] Checked Xcode Command Line Tools.
- [x] Checked Homebrew.
- [x] Reviewed and trimmed the initial Brewfile.
- [x] Installed `fnm` via Homebrew.
- [x] Extended `~/.zshrc` for `fnm`.
- [x] Installed Node.js LTS 24.15.0 via `fnm`.
- [x] Enabled Corepack.
- [x] Initialized `pnpm` through Corepack.
- [x] Initialized this setup as a Git repository.

## Next

- [x] Evaluate `chezmoi` for dotfile management:
  - `docs/dotfiles-plan.md`
- [x] Moved the repo to a stable path: `~/Workspace/effective-mac-setup`.
- [x] Install and initialize `chezmoi`.
- [x] Migrate Git and zsh dotfiles into `chezmoi` one by one.
- [x] Set Git identity in `~/.gitconfig.local`:
  - `git config --global user.name "Your Name"`
  - `git config --global user.email "your@email"`
- [x] Verified GitHub CLI in a normal terminal:
  - `gh auth status`
- [ ] Verify the 1Password SSH Agent in a normal terminal:
  - `ssh -T git@github.com`
- [x] Run `brew bundle --file Brewfile` to install missing CLI tools, Go/Rust tooling, and apps.
- [ ] Add reviewed Mac App Store apps through `mas` entries:
  - `docs/mas-inventory.md`
- [x] Open a new terminal and verify the Node setup:
  - `node --version`
  - `npm --version`
  - `pnpm --version`

## Editor

- [x] Track Zed in the Brewfile.
- [x] Install and verify Zed:
  - `zed --version`
- [ ] Decide whether VS Code is needed as a fallback.
- [ ] Check the VS Code shell command only if VS Code is installed:
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

- [ ] Evaluate Helium as the daily browser.
- [ ] Install Chrome only if a fallback Chromium browser is needed.
- [x] Install Firefox.
- [ ] Use Safari for WebKit checks.
- [ ] Install OrbStack if Docker/containers are actually needed.

## Project Templates

- [ ] Create a Vite React/TypeScript smoke test.
- [ ] Create a Next.js App Router smoke test.
- [x] Verify Go toolchain:
  - `go version`
- [x] Verify Rust toolchain:
  - `rustc --version`
  - `cargo --version`
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
- [x] Trim the Brewfile to personal preferences.
- [ ] Document a CI check for an example project.
