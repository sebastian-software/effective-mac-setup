# Decisions

Short rationale for the main setup decisions.

## Node via fnm Instead of Homebrew Node

Homebrew remains the package manager for CLI tools and apps. Node.js itself is managed through `fnm` because modern frontend projects often expect different Node versions.

Benefits:

- Project-specific Node versions through `.node-version` or similar files.
- Faster and leaner than many older Node version managers.
- Less global coupling than `brew install node`.
- Works well with Corepack and pnpm.

## pnpm via Corepack

Corepack ships with modern Node versions and can provide pnpm per project. That means pnpm does not need to be installed as a separate global npm package.

## SSH via 1Password

SSH keys are managed through the 1Password SSH Agent. This setup does not generate a new local SSH key and does not change `~/.ssh/config` unless explicitly requested.

Check it in a normal terminal:

```sh
ssh -T git@github.com
```

## GitHub CLI

`gh` is installed. Login should be checked in a normal terminal because Codex/sandbox access to tokens or the keychain can differ.

```sh
gh auth status
```

## Brewfile

The `Brewfile` is the reproducible package list. It should stay intentionally small and include only the tools that are actually useful on a lean macOS developer machine.

## Go and Rust

Go and Rust are included because they commonly appear next to modern frontend work in infrastructure, CLIs, build tooling, developer platforms, and edge/runtime ecosystems. They should be available without turning this setup into a heavy backend workstation.

## Dotfiles as Templates

Global configuration such as Git, zsh, and aliases can live in this repo as templates. Private values are kept outside the repo.

For Git, the structure is:

- `~/.gitconfig`: shared defaults
- `~/.gitconfig.local`: private identity

This allows the shared configuration to be versioned without committing names, email addresses, or machine-specific data.

Next improvement: dotfiles should probably be managed through symlinks rather than copied. The detailed plan lives in [dotfiles-plan.md](dotfiles-plan.md).

## Scope of This Repo

This repo documents:

- machine status
- installation steps
- package list
- explicit decisions
- next TODOs
- small dotfile templates

It should not become a large dotfiles framework, though it can absorb dotfiles later if that becomes useful.
