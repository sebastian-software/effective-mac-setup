# Homebrew Inventory

Date: 2026-05-13

This inventory separates explicit top-level installs from dependencies pulled in by Homebrew.

## Brewfile Top-Level Formulae

These are intentionally tracked in the Brewfile:

```text
bat 0.26.1
chezmoi 2.70.3
eza 0.23.4
fd 10.4.2
fnm 1.39.0
gh 2.92.0
git 2.54.0
go 1.26.3
jq 1.8.1
mas 7.0.0
ripgrep 15.1.0
rustup 1.29.0
starship 1.25.1
```

## Installed Formulae Including Dependencies

These are currently installed. Dependency formulae are documented here but not listed directly in the Brewfile unless they are also top-level choices.

```text
bat 0.26.1
ca-certificates 2026-03-19
chezmoi 2.70.3
eza 0.23.4
fd 10.4.2
fnm 1.39.0
gettext 1.0
gh 2.92.0
git 2.54.0
go 1.26.3
jq 1.8.1
libgit2 1.9.3
libssh2 1.11.1_1
libunistring 1.4.2
llhttp 9.4.1
mas 7.0.0
oniguruma 6.9.10
openssl@3 3.6.2
pcre2 10.47_1
ripgrep 15.1.0
rustup 1.29.0
starship 1.25.1
```

## Installed Casks

All currently installed Homebrew Casks are tracked in the Brewfile:

```text
firefox 150.0.3
github 3.5.8-b1d863ab
google-chrome 148.0.7778.97
zed 1.1.8
```
