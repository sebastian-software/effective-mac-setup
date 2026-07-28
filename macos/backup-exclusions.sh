#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exclusions_file="${BACKUP_EXCLUSIONS_FILE:-$repo_root/macos/backup-exclusions.txt}"
backblaze_cli="${BACKBLAZE_CLI:-/Applications/Backblaze.app/Contents/MacOS/bzcli}"
tmutil_bin="${TMUTIL_BIN:-/usr/bin/tmutil}"
sudo_bin="${SUDO_BIN:-sudo}"
mode="${1:---check}"

usage() {
  cat <<'EOF'
Usage: macos/backup-exclusions.sh [--apply|--check|--dry-run]

Applies or checks the paths in macos/backup-exclusions.txt for both Time
Machine and Backblaze.

Options:
  --apply    Add all configured exclusions. Run this script as your normal
             user; it invokes sudo only for Time Machine.
  --check    Check the effective configuration without changing it (default).
  --dry-run  Print the resolved paths and Backblaze JSON without changing
             either backup system.
  -h, --help Show this help.
EOF
}

case "$mode" in
  --apply|--check|--dry-run)
    ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown argument: $mode" >&2
    usage >&2
    exit 2
    ;;
esac

if [[ ! -f "$exclusions_file" ]]; then
  echo "Backup exclusions file not found: $exclusions_file" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required; install the Brewfile first." >&2
  exit 1
fi

declare -a exclusion_paths=()
while IFS= read -r entry || [[ -n "$entry" ]]; do
  [[ -z "$entry" || "$entry" == \#* ]] && continue

  if [[ "$entry" == /* ]]; then
    exclusion_paths+=("$entry")
  else
    exclusion_paths+=("$HOME/$entry")
  fi
done < "$exclusions_file"

if [[ "${#exclusion_paths[@]}" -eq 0 ]]; then
  echo "No backup exclusions are configured in $exclusions_file" >&2
  exit 1
fi

backblaze_json() {
  jq -n --args \
    '{settings: {bzdirfilter_add: [$ARGS.positional[] | {dir: ., whichfiles: "none"}]}}' \
    "${exclusion_paths[@]}"
}

normalize_backblaze_path() {
  local path="${1%/}"
  printf '%s' "$path" | tr '[:upper:]' '[:lower:]'
}

time_machine_skip_paths_json() {
  if ! defaults export /Library/Preferences/com.apple.TimeMachine - 2>/dev/null |
      plutil -extract SkipPaths json -o - - 2>/dev/null; then
    printf '[]\n'
  fi
}

time_machine_path_is_excluded() {
  local path="$1"
  local skip_paths_json="$2"

  if "$tmutil_bin" isexcluded "$path" 2>/dev/null |
      grep -q '^\[Excluded\]'; then
    return 0
  fi

  jq -e --arg path "$path" 'index($path) != null' \
    >/dev/null 2>&1 <<< "$skip_paths_json"
}

check_time_machine() {
  local skip_paths_json
  local path
  local missing=0

  skip_paths_json="$(time_machine_skip_paths_json)"
  for path in "${exclusion_paths[@]}"; do
    if ! time_machine_path_is_excluded "$path" "$skip_paths_json"; then
      printf '     Time Machine missing: %s\n' "$path"
      missing=$((missing + 1))
    fi
  done

  if [[ "$missing" -eq 0 ]]; then
    printf 'OK   Time Machine has all %d configured exclusions\n' \
      "${#exclusion_paths[@]}"
    return 0
  fi

  printf 'WARN Time Machine is missing %d of %d configured exclusions\n' \
    "$missing" "${#exclusion_paths[@]}"
  return 1
}

check_backblaze() {
  local configured_json
  local normalized
  local path
  local missing=0

  if [[ ! -x "$backblaze_cli" ]]; then
    printf 'WARN Backblaze CLI is not installed at %s\n' "$backblaze_cli"
    return 1
  fi

  if ! configured_json="$("$backblaze_cli" report \
      --value /settings/bzdirfilter_add 2>/dev/null)"; then
    printf 'WARN Backblaze is installed but its exclusions could not be read\n'
    return 1
  fi

  for path in "${exclusion_paths[@]}"; do
    normalized="$(normalize_backblaze_path "$path")"
    if ! jq -e --arg path "$normalized" '
        any(.[];
          .whichfiles == "none" and
          ((.dir | ascii_downcase | sub("/+$"; "")) == $path)
        )
      ' >/dev/null 2>&1 <<< "$configured_json"; then
      printf '     Backblaze missing: %s\n' "$path"
      missing=$((missing + 1))
    fi
  done

  if [[ "$missing" -eq 0 ]]; then
    printf 'OK   Backblaze has all %d configured exclusions\n' \
      "${#exclusion_paths[@]}"
    return 0
  fi

  printf 'WARN Backblaze is missing %d of %d configured exclusions\n' \
    "$missing" "${#exclusion_paths[@]}"
  return 1
}

check_all() {
  local status=0

  check_time_machine || status=1
  check_backblaze || status=1
  return "$status"
}

apply_time_machine() {
  if [[ "$EUID" -eq 0 ]]; then
    echo "Run this script as your normal user, not with sudo." >&2
    echo "It invokes sudo only for the Time Machine command." >&2
    return 1
  fi

  printf 'Applying %d fixed-path Time Machine exclusions...\n' \
    "${#exclusion_paths[@]}"
  if ! "$sudo_bin" "$tmutil_bin" addexclusion -p "${exclusion_paths[@]}"; then
    echo "Time Machine exclusions failed." >&2
    echo "Give your terminal Full Disk Access, then run this command again." >&2
    return 1
  fi
}

apply_backblaze() {
  local config_json status

  if [[ ! -x "$backblaze_cli" ]]; then
    echo "Backblaze is not installed at $backblaze_cli; skipping it." >&2
    return 1
  fi

  config_json="$(mktemp "${TMPDIR:-/tmp}/effective-mac-backblaze.XXXXXX")"
  backblaze_json > "$config_json"

  printf 'Applying %d Backblaze directory exclusions...\n' \
    "${#exclusion_paths[@]}"
  if "$backblaze_cli" configure --json "$config_json"; then
    rm -f "$config_json"
  else
    status=$?
    rm -f "$config_json"
    return "$status"
  fi
}

case "$mode" in
  --dry-run)
    printf 'Resolved backup exclusions:\n'
    printf '  %s\n' "${exclusion_paths[@]}"
    printf '\nBackblaze configuration:\n'
    backblaze_json
    ;;
  --check)
    if check_all; then
      exit 0
    else
      exit 1
    fi
    ;;
  --apply)
    apply_status=0
    apply_time_machine || apply_status=1
    apply_backblaze || apply_status=1

    printf '\nVerifying backup exclusions...\n'
    check_all || apply_status=1
    exit "$apply_status"
    ;;
esac
