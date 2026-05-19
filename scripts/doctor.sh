#!/usr/bin/env bash
set -uo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fix_mode=false
warns=0
fails=0
LAST_OUTPUT=""

usage() {
  cat <<EOF
Usage: scripts/doctor.sh [--fix]

Checks this macOS setup and prints compact OK/WARN/FAIL output.

Options:
  --fix   Re-run safe setup steps: brew bundle, chezmoi apply, Node LTS,
          Corepack, and pnpm activation. macOS defaults are not applied.
  -h, --help
          Show this help.
EOF
}

while (($#)); do
  case "$1" in
    --fix)
      fix_mode=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

ok() {
  printf 'OK   %s\n' "$1"
}

warn() {
  warns=$((warns + 1))
  printf 'WARN %s\n' "$1"
}

fail() {
  fails=$((fails + 1))
  printf 'FAIL %s\n' "$1"
}

detail() {
  [[ -n "${1:-}" ]] && printf '     %s\n' "$1"
}

run_with_timeout() {
  local timeout="$1"
  shift

  local out marker pid killer status
  out="$(mktemp "${TMPDIR:-/tmp}/effective-mac-doctor.out.XXXXXX")"
  marker="$(mktemp "${TMPDIR:-/tmp}/effective-mac-doctor.timeout.XXXXXX")"
  rm -f "$marker"

  "$@" >"$out" 2>&1 &
  pid=$!

  (
    sleep "$timeout"
    if kill -0 "$pid" >/dev/null 2>&1; then
      : >"$marker"
      kill -TERM "$pid" >/dev/null 2>&1 || true
      sleep 1
      kill -KILL "$pid" >/dev/null 2>&1 || true
    fi
  ) &
  killer=$!

  wait "$pid" 2>/dev/null
  status=$?
  kill "$killer" >/dev/null 2>&1 || true
  wait "$killer" 2>/dev/null || true

  LAST_OUTPUT="$(cat "$out")"
  rm -f "$out"

  if [[ -e "$marker" ]]; then
    rm -f "$marker"
    return 124
  fi

  rm -f "$marker"
  return "$status"
}

first_line() {
  printf '%s\n' "$1" | sed -n '1p'
}

command_ok() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "$cmd is available ($(command -v "$cmd"))"
  else
    fail "$cmd is missing"
  fi
}

warn_command_missing() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "$cmd is available ($(command -v "$cmd"))"
  else
    warn "$cmd is missing"
  fi
}

homebrew_tool_ok() {
  local formula="$1"
  local cmd="$2"

  if ! brew list --formula "$formula" >/dev/null 2>&1; then
    fail "$formula Homebrew formula is missing"
    if command -v "$cmd" >/dev/null 2>&1; then
      detail "$cmd resolves to $(command -v "$cmd"), but the Brewfile-managed formula is not installed."
    fi
    return
  fi

  if ! command -v "$cmd" >/dev/null 2>&1; then
    fail "$cmd is missing, though $formula Homebrew formula is installed"
    return
  fi

  local cmd_path homebrew_prefix formula_prefix
  cmd_path="$(command -v "$cmd")"
  homebrew_prefix="$(brew --prefix)"
  formula_prefix="$(brew --prefix "$formula" 2>/dev/null || true)"

  if [[ "$cmd_path" == "$homebrew_prefix/bin/"* ||
      "$cmd_path" == "$homebrew_prefix/sbin/"* ||
      ( -n "$formula_prefix" && "$cmd_path" == "$formula_prefix/bin/"* ) ||
      ( -n "$formula_prefix" && "$cmd_path" == "$formula_prefix/sbin/"* ) ]]; then
    ok "$cmd is available from Homebrew ($cmd_path)"
  else
    warn "$cmd resolves outside Homebrew ($cmd_path)"
    detail "$formula Homebrew formula is installed, but PATH prefers another command."
  fi
}

app_ok() {
  local name="$1"
  local path="$2"
  if [[ -d "$path" ]]; then
    ok "$name app is installed"
  else
    warn "$name app not found at $path"
  fi
}

section() {
  printf '\n==> %s\n' "$1"
}

fix_brew() {
  section "Fix: Homebrew"
  if command -v brew >/dev/null 2>&1; then
    brew bundle --file "$repo_root/Brewfile"
  else
    fail "Homebrew is missing; install it from https://docs.brew.sh/Installation.html"
  fi
}

fix_chezmoi() {
  section "Fix: chezmoi"
  if ! command -v chezmoi >/dev/null 2>&1; then
    fail "chezmoi is missing; run brew bundle first"
    return
  fi

  mkdir -p "$HOME/.config/chezmoi"
  cat > "$HOME/.config/chezmoi/chezmoi.toml" <<EOF
sourceDir = "$repo_root/dotfiles/chezmoi"
mode = "symlink"
EOF
  chezmoi apply
}

fix_node() {
  section "Fix: Node"
  if ! command -v fnm >/dev/null 2>&1; then
    fail "fnm is missing; run brew bundle first"
    return
  fi

  eval "$(fnm env --use-on-cd --shell bash)"
  fnm install --lts
  fnm default lts-latest
  fnm use lts-latest

  export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"
  export PATH="$PNPM_HOME:$PNPM_HOME/bin:$PATH"
  mkdir -p "$PNPM_HOME/bin"

  if command -v corepack >/dev/null 2>&1; then
    corepack enable
    corepack prepare pnpm@latest --activate
  else
    warn "corepack is missing after Node setup"
  fi
}

check_homebrew() {
  section "Homebrew"
  if command -v brew >/dev/null 2>&1; then
    ok "Homebrew is available ($(brew --prefix))"
  else
    fail "Homebrew is missing"
    return
  fi

  local no_mas
  no_mas="$(mktemp "${TMPDIR:-/tmp}/effective-mac-Brewfile.no-mas.XXXXXX")"
  sed '/^mas /d' "$repo_root/Brewfile" >"$no_mas"
  if run_with_timeout 30 env HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --no-upgrade --file "$no_mas"; then
    ok "Brewfile formulae and casks are satisfied"
  else
    local status=$?
    if [[ "$status" -eq 124 ]]; then
      warn "Brewfile formula/cask check timed out"
    else
      fail "Brewfile formulae/casks have missing dependencies"
      detail "$(first_line "$LAST_OUTPUT")"
    fi
  fi
  rm -f "$no_mas"
}

check_tools() {
  section "Core tools"
  if ! command -v brew >/dev/null 2>&1; then
    fail "Homebrew is missing; cannot validate Brewfile-managed tools"
    return
  fi

  homebrew_tool_ok git git
  homebrew_tool_ok gh gh
  homebrew_tool_ok fnm fnm
  homebrew_tool_ok starship starship
  homebrew_tool_ok fish fish
  homebrew_tool_ok zoxide zoxide
  homebrew_tool_ok ripgrep rg
  homebrew_tool_ok fd fd
  homebrew_tool_ok jq jq
  homebrew_tool_ok bat bat
  homebrew_tool_ok eza eza
  homebrew_tool_ok mas mas
  homebrew_tool_ok chezmoi chezmoi
  homebrew_tool_ok dockutil dockutil
  homebrew_tool_ok go go
  homebrew_tool_ok rustup rustup

  if brew list --formula trash >/dev/null 2>&1; then
    local trash_prefix trash_path
    trash_prefix="$(brew --prefix trash 2>/dev/null || true)"
    trash_path="${trash_prefix:-$(brew --prefix)/opt/trash}/bin/trash"
    if [[ -x "$trash_path" ]]; then
      ok "trash CLI is available from Homebrew keg ($trash_path)"
    elif command -v trash >/dev/null 2>&1; then
      warn "trash resolves to $(command -v trash), but the Homebrew keg binary was not found"
    else
      fail "trash CLI is missing, though trash Homebrew formula is installed"
    fi
  elif command -v trash >/dev/null 2>&1; then
    fail "trash Homebrew formula is missing"
    detail "trash resolves to $(command -v trash), but the Brewfile-managed formula is not installed."
  else
    fail "trash Homebrew formula is missing"
  fi
}

check_apps() {
  section "Apps"
  app_ok "GitHub Desktop" "/Applications/GitHub Desktop.app"
  app_ok "Zed" "/Applications/Zed.app"
  app_ok "Firefox" "/Applications/Firefox.app"
  app_ok "Google Chrome" "/Applications/Google Chrome.app"
  app_ok "cmux" "/Applications/cmux.app"

  if command -v zed >/dev/null 2>&1; then
    ok "Zed CLI is available"
  else
    warn "Zed CLI is missing; install it from Zed if needed"
  fi
}

check_editor_prompt() {
  section "Editor, prompt, and shells"
  local starship_config="$repo_root/dotfiles/chezmoi/private_dot_config/starship.toml"
  local zed_settings="$repo_root/dotfiles/chezmoi/private_dot_config/zed/settings.json"
  local fish_config="$repo_root/dotfiles/chezmoi/private_dot_config/fish/config.fish"
  local ghostty_config="$repo_root/dotfiles/chezmoi/private_dot_config/ghostty/config"

  if [[ -f "$starship_config" ]]; then
    if ! command -v starship >/dev/null 2>&1; then
      fail "starship is missing; cannot validate starship config"
    elif STARSHIP_CONFIG="$starship_config" starship print-config >/dev/null 2>&1; then
      ok "starship config parses"
    else
      fail "starship config does not parse"
    fi
  else
    fail "starship config is missing"
  fi

  if [[ -s "$zed_settings" ]]; then
    ok "Zed settings are tracked"
  else
    fail "Zed settings are missing or empty"
  fi

  if [[ -f "$fish_config" ]]; then
    if command -v fish >/dev/null 2>&1; then
      if fish --no-config --command "source '$fish_config'" >/dev/null 2>&1; then
        ok "fish config parses"
      else
        fail "fish config does not parse"
      fi
    else
      fail "fish is missing; cannot parse fish config"
    fi
  else
    fail "fish config is missing"
  fi

  if [[ -f "$ghostty_config" ]] &&
      grep -q '^command = /opt/homebrew/bin/fish --login --interactive$' "$ghostty_config" &&
      grep -q '^shell-integration = fish$' "$ghostty_config"; then
    ok "Ghostty/cmux fish config is tracked"
  else
    fail "Ghostty/cmux fish config is missing fish settings"
  fi

  local home_ghostty_config="$HOME/.config/ghostty/config"
  if [[ -f "$home_ghostty_config" ]]; then
    if grep -q '^command = /opt/homebrew/bin/fish --login --interactive$' "$home_ghostty_config" &&
        grep -q '^shell-integration = fish$' "$home_ghostty_config"; then
      ok "Ghostty/cmux fish config is applied"
    else
      warn "Ghostty/cmux config exists but does not select fish"
    fi
  else
    warn "Ghostty/cmux fish config is not applied yet; run chezmoi apply or macos/defaults.sh"
  fi
}

check_dotfiles() {
  section "Dotfiles"
  if bash -n "$repo_root/scripts/bootstrap.sh"; then
    ok "bootstrap.sh syntax is valid"
  else
    fail "bootstrap.sh has a syntax error"
  fi

  if [[ -f "$repo_root/scripts/doctor.sh" ]] && bash -n "$repo_root/scripts/doctor.sh"; then
    ok "doctor.sh syntax is valid"
  else
    fail "doctor.sh has a syntax error"
  fi

  local script
  for script in "$repo_root"/dotfiles/chezmoi/private_dot_local/bin/executable_*; do
    [[ -e "$script" ]] || continue
    if bash -n "$script"; then
      ok "$(basename "$script" | sed 's/^executable_//') syntax is valid"
    else
      fail "$(basename "$script" | sed 's/^executable_//') has a syntax error"
    fi
  done

  if zsh -n "$repo_root/dotfiles/chezmoi/dot_zshrc"; then
    ok "zshrc syntax is valid"
  else
    fail "zshrc has a syntax error"
  fi

  if git config --file "$repo_root/dotfiles/chezmoi/dot_gitconfig" --list >/dev/null; then
    ok "gitconfig parses"
  else
    fail "gitconfig does not parse"
  fi

  if command -v chezmoi >/dev/null 2>&1; then
    if chezmoi status >/dev/null; then
      ok "chezmoi status succeeds"
    else
      fail "chezmoi status failed"
    fi

    local chezmoi_diff
    chezmoi_diff="$(chezmoi diff)"
    if [[ -z "$chezmoi_diff" ]]; then
      ok "chezmoi has no pending diff"
    else
      warn "chezmoi has pending diff"
    fi
  else
    fail "chezmoi is missing"
  fi

  local cmd
  for cmd in setup-doctor repos-update repupd cleanup-dsstore myip ports del flushdns op-env-edit; do
    if [[ -x "$HOME/.local/bin/$cmd" ]]; then
      ok "$cmd is applied in ~/.local/bin"
    else
      warn "$cmd is not applied in ~/.local/bin yet"
    fi
  done
}

check_languages() {
  section "Languages"
  if command -v node >/dev/null 2>&1; then
    ok "node $(node --version)"
  else
    fail "node is missing"
  fi

  if command -v npm >/dev/null 2>&1; then
    ok "npm $(npm --version)"
  else
    warn "npm is missing"
  fi

  if command -v corepack >/dev/null 2>&1; then
    ok "corepack $(corepack --version)"
  else
    warn "corepack is missing"
  fi

  if command -v pnpm >/dev/null 2>&1; then
    ok "pnpm $(pnpm --version)"
    local expected_pnpm_home="${PNPM_HOME:-$HOME/Library/pnpm}"
    if PNPM_HOME="$expected_pnpm_home" PATH="$expected_pnpm_home:$expected_pnpm_home/bin:$PATH" pnpm bin -g >/dev/null 2>&1; then
      ok "pnpm global bin directory is configured"
    else
      warn "pnpm global bin directory is not ready"
      detail "Open a new managed shell or run scripts/doctor.sh --fix."
    fi
  else
    warn "pnpm is missing; run scripts/bootstrap.sh or scripts/doctor.sh --fix"
  fi

  if command -v go >/dev/null 2>&1; then
    ok "$(go version)"
  else
    fail "go is missing"
  fi

  if command -v rustup >/dev/null 2>&1; then
    ok "$(rustup --version 2>/dev/null | sed -n '1p')"
  else
    fail "rustup is missing"
  fi
}

check_auth_network() {
  section "Auth and network"
  if command -v gh >/dev/null 2>&1; then
    if run_with_timeout 8 gh auth status; then
      ok "GitHub CLI auth is available"
    else
      warn "GitHub CLI auth check failed or timed out"
      detail "$(first_line "$LAST_OUTPUT")"
    fi

    if run_with_timeout 8 gh config get git_protocol; then
      local gh_git_protocol
      gh_git_protocol="$(first_line "$LAST_OUTPUT")"
      if [[ "$gh_git_protocol" == "ssh" ]]; then
        ok "GitHub CLI git protocol is ssh"
      else
        warn "GitHub CLI git protocol is ${gh_git_protocol:-unset}, expected ssh"
        detail "Run: gh config set git_protocol ssh"
      fi
    else
      warn "GitHub CLI git protocol check failed or timed out"
      detail "$(first_line "$LAST_OUTPUT")"
    fi
  else
    fail "gh is missing"
  fi

  if [[ -n "${SSH_AUTH_SOCK:-}" ]]; then
    ok "SSH_AUTH_SOCK is set"
    local origin_url
    origin_url="$(git -C "$repo_root" remote get-url origin 2>/dev/null || true)"
    if [[ "$origin_url" == git@* || "$origin_url" == ssh://* ]]; then
      if run_with_timeout 8 git -C "$repo_root" ls-remote --heads origin main; then
        ok "Git over SSH can reach origin"
      else
        warn "Git over SSH could not reach origin from this process"
        detail "$(first_line "$LAST_OUTPUT")"
      fi
    else
      warn "origin is not an SSH remote; skipping Git SSH auth check"
    fi
  else
    warn "SSH_AUTH_SOCK is not set; 1Password SSH Agent may not be active"
  fi

  if command -v op >/dev/null 2>&1; then
    if run_with_timeout 8 op account list; then
      ok "1Password CLI can list accounts"
    else
      warn "1Password CLI is installed but not signed in or timed out"
      detail "$(first_line "$LAST_OUTPUT")"
    fi
  else
    warn "1Password CLI is not installed; Safari extension/desktop app may still be enough"
  fi

  if command -v mas >/dev/null 2>&1; then
    local mas_config_output=""
    if run_with_timeout 8 mas config; then
      ok "MAS config is available"
      mas_config_output="$LAST_OUTPUT"
    else
      warn "MAS config check failed or timed out"
      detail "$(first_line "$LAST_OUTPUT")"
      mas_config_output="$LAST_OUTPUT"
    fi

    if printf '%s\n' "$mas_config_output" | grep -q "Operation not permitted"; then
      warn "MAS app list skipped because this process has restricted App Store access"
      detail "Run scripts/doctor.sh from a normal Terminal to verify MAS."
    else
      if run_with_timeout 8 mas list; then
        ok "MAS app list is available"
      else
        warn "MAS list failed or timed out"
        detail "$(first_line "$LAST_OUTPUT")"
      fi
    fi
  else
    fail "mas is missing"
  fi
}

if [[ "$fix_mode" == true ]]; then
  fix_brew
  fix_chezmoi
  fix_node
fi

check_homebrew
check_tools
check_apps
check_editor_prompt
check_dotfiles
check_languages
check_auth_network

printf '\n==> Summary\n'
printf 'WARN %d\n' "$warns"
printf 'FAIL %d\n' "$fails"

if [[ "$fails" -gt 0 ]]; then
  exit 1
fi

exit 0
