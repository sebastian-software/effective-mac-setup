# TODO

Priorisierte Liste fuer das React/TypeScript-Notebook.

## Erledigt

- [x] macOS-Version und Architektur geprueft.
- [x] Xcode Command Line Tools geprueft.
- [x] Homebrew geprueft.
- [x] `fnm` via Homebrew installiert.
- [x] `~/.zshrc` fuer `fnm` ergaenzt.
- [x] Node.js LTS 24.15.0 via `fnm` installiert.
- [x] Corepack aktiviert.
- [x] `pnpm` ueber Corepack initialisiert.
- [x] Dieses Setup als Git-Repo initialisiert.

## Als Naechstes

- [ ] Dotfile-Symlink-Konzept finalisieren:
  - `docs/dotfiles-plan.md`
- [x] Repo an stabilen Ort verschoben: `~/Workspace/effective-mac-setup`.
- [ ] TypeScript-Dotfile-Manager implementieren:
  - `pnpm dotfiles:check`
  - `pnpm dotfiles:apply`
  - `pnpm dotfiles:repair`
- [ ] Git Identitaet in `~/.gitconfig.local` setzen:
  - `git config --global user.name "Dein Name"`
  - `git config --global user.email "deine@email"`
- [x] GitHub CLI im normalen Terminal verifiziert:
  - `gh auth status`
- [ ] 1Password SSH Agent im normalen Terminal verifizieren:
  - `ssh -T git@github.com`
- [ ] `brew bundle --file Brewfile` ausfuehren, um fehlende CLI-Tools und Apps zu installieren.
- [ ] Neues Terminal oeffnen und Node-Setup pruefen:
  - `node --version`
  - `npm --version`
  - `pnpm --version`

## Editor

- [ ] VS Code oder Cursor entscheiden.
- [ ] VS Code Shell Command pruefen:
  - `code --version`
- [ ] Extensions installieren:
  - ESLint
  - Prettier
  - Tailwind CSS IntelliSense
  - Playwright Test for VS Code
  - Pretty TypeScript Errors
  - GitLens optional
  - Error Lens optional

## Browser und Runtime

- [ ] Chrome installieren.
- [ ] Firefox installieren.
- [ ] Safari fuer WebKit-Checks verwenden.
- [ ] OrbStack installieren, falls Docker/Container gebraucht werden.

## Projekt-Templates

- [ ] Vite React/TypeScript Smoke-Test anlegen.
- [ ] Next.js App Router Smoke-Test anlegen.
- [ ] Gemeinsame Projektstandards notieren:
  - `pnpm`
  - TypeScript strict mode
  - ESLint
  - Prettier
  - Vitest
  - Playwright

## macOS/Arbeitskomfort

- [ ] FileVault in Systemeinstellungen pruefen.
- [ ] Touch ID und Apple Watch Unlock pruefen.
- [x] 1Password vorhanden; SSH Agent wird darueber genutzt.
- [ ] Backblaze Backup-Status pruefen.
- [ ] Tailscale Login/Netzwerk pruefen.
- [ ] Raycast pruefen oder installieren.
- [ ] Zwischenablage-Tool: Maccy oder vorhandenes Pure Paste bewusst entscheiden.

## Optional

- [ ] `direnv` fuer Projekt-ENV aktivieren.
- [ ] Dotfiles-Repo anlegen oder dieses Repo dafuer erweitern.
- [ ] Brewfile nach persoenlichen Vorlieben ausduennen.
- [ ] CI-Check fuer Beispielprojekt dokumentieren.
