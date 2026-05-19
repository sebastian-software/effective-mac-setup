# Fish is the default interactive shell for Terminal and cmux. Zsh stays the
# login/system fallback shell, so keep this file explicit and boring.

function __path_prepend
    set -l dir $argv[1]
    contains -- "$dir" $PATH; or set -gx PATH "$dir" $PATH
end

__path_prepend "$HOME/.local/bin"

set -gx EDITOR "zed --wait"
set -gx VISUAL "zed --wait"
set -gx LANG "de_DE.UTF-8"
set -gx LC_ALL "de_DE.UTF-8"

if set -q NODE_OPTIONS
    if not string match -q "*--max-old-space-size=16384*" -- "$NODE_OPTIONS"
        set -gx NODE_OPTIONS "$NODE_OPTIONS --max-old-space-size=16384"
    end
else
    set -gx NODE_OPTIONS "--max-old-space-size=16384"
end

# pnpm uses PNPM_HOME for global binaries installed via "pnpm -g". Depending on
# pnpm/Corepack state it may expect PNPM_HOME itself or PNPM_HOME/bin in PATH.
set -q PNPM_HOME; or set -gx PNPM_HOME "$HOME/Library/pnpm"
mkdir -p "$PNPM_HOME/bin"
__path_prepend "$PNPM_HOME"
__path_prepend "$PNPM_HOME/bin"

set -q GOPATH; or set -gx GOPATH "$HOME/go"
set -q GOBIN; or set -gx GOBIN "$GOPATH/bin"
__path_prepend "$GOBIN"

if test -d "$HOME/.cargo/bin"
    __path_prepend "$HOME/.cargo/bin"
end

if status is-interactive; and command -q fnm
    fnm env --use-on-cd --shell fish | source
end

if status is-interactive; and command -q zoxide
    zoxide init fish | source
end

# Navigation helpers. Inspired by compact directory aliases commonly seen in
# mathiasbynens/dotfiles and holman/dotfiles.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

function mkcd
    if test (count $argv) -ne 1
        echo "usage: mkcd <directory>" >&2
        return 2
    end

    mkdir -p "$argv[1]"; and cd "$argv[1]"
end

function reload
    exec fish
end

# Better listing/search defaults without overriding POSIX muscle memory.
alias ll='eza -la --git'
alias la='eza -a'
alias search='rg'

# Shell-neutral helpers such as cleanup-dsstore, del, myip, ports, flushdns,
# repos-update, and setup-doctor live in ~/.local/bin.
alias mkdir='mkdir -p'
alias dfh='df -h'
alias duh='du -h'

function ducks
    du -cksh -- ./* ./.* 2>/dev/null | sort -hr | head -n 20
end

# Git shortcuts. Richer aliases live in Git config; these are quick shell taps.
alias g='git'
alias gs='git status --short --branch'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gl='git lg'
alias gco='git checkout'
alias gb='git branch --sort=-committerdate'
alias gundo='git reset --soft HEAD~1'

function repo
    gh repo view --web $argv
end

function pr
    gh pr view --web $argv
end

function ci
    gh pr checks $argv
end

function issues
    gh issue list --web $argv
end

function clonecd
    if test (count $argv) -ne 1
        echo "usage: clonecd <owner/repo>" >&2
        return 2
    end

    set -l repo $argv[1]
    set -l dir (basename "$repo" .git)
    gh repo clone "$repo"; and cd "$dir"
end

alias czs='chezmoi status'
alias czd='chezmoi diff'
alias brewc='brew bundle check --no-upgrade --file Brewfile'

# Language workflow aliases for the current Go/Rust/Node setup.
alias gob='go build ./...'
alias got='go test ./...'
alias gor='go run .'
alias cc='cargo check'
alias ct='cargo test'
alias cr='cargo run'
alias run='npm run -s'
alias ni='npm install'
alias nci='npm ci'
alias nr='npm run'
alias nt='npm test'
alias rgr='rg -L'

# 1Password-backed environment mapping. The mapping file is local-only and has
# the same shape as zsh uses:
#
#   LINEAR_API_KEY=op://Private/Linear/API Key
function op-env-load
    set -l quiet false
    if test (count $argv) -gt 0; and test "$argv[1]" = "--quiet"
        set quiet true
        set -e argv[1]
    end

    set -l env_file "$HOME/.config/effective-mac-setup/op-env"
    if test (count $argv) -gt 0
        set env_file "$argv[1]"
    else if set -q OP_ENV_FILE
        set env_file "$OP_ENV_FILE"
    end

    test -r "$env_file"; or return 0

    if not command -q op
        if test "$quiet" != true
            echo "1Password CLI is not installed." >&2
        end
        return 127
    end

    set -l loaded 0
    set -l failed 0

    while read -l line
        test -z "$line"; and continue
        string match -qr '^#' -- "$line"; and continue
        string match -q '*=*' -- "$line"; or continue

        set -l parts (string split -m1 '=' -- "$line")
        set -l name (string replace -ra '\s+' '' -- "$parts[1]")
        set -l ref "$parts[2]"

        if not string match -qr '^[A-Za-z_][A-Za-z0-9_]*$' -- "$name"
            if test "$quiet" != true
                echo "Skipping invalid environment variable name: $name" >&2
            end
            set failed (math $failed + 1)
            continue
        end

        set -l value (op read "$ref" 2>/dev/null)
        if test $status -eq 0
            set -gx $name "$value"
            set loaded (math $loaded + 1)
        else
            if test "$quiet" != true
                echo "Could not read 1Password secret for $name" >&2
            end
            set failed (math $failed + 1)
        end
    end < "$env_file"

    if test "$quiet" != true
        echo "Loaded $loaded 1Password-backed environment variables from $env_file."
    end

    test "$failed" -eq 0
end

function op-accounts
    command -q op; or begin
        echo "1Password CLI is not installed." >&2
        return 127
    end

    op account list
end

function op-whoami
    command -q op; or begin
        echo "1Password CLI is not installed." >&2
        return 127
    end

    op whoami
end

function ssh-agent-info
    echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
    ssh-add -l
end

function gh-ssh-test
    ssh -T git@github.com
end

if test "$OP_ENV_AUTO_LOAD" != "0"
    op-env-load --quiet; or true
end

if status is-interactive; and command -q starship
    starship init fish | source
end

functions -e __path_prepend
