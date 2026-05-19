#!/usr/bin/env bash
set -euo pipefail

# Curated macOS settings.
#
# This file intentionally names desired behavior and applies it via the smallest
# known mechanism. Do not turn this into a blind export of ~/Library/Preferences.

set_plist_value() {
  local plist="$1"
  local key_path="$2"
  local type="$3"
  local value="$4"

  /usr/libexec/PlistBuddy -c "Set $key_path $value" "$plist" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add $key_path $type $value" "$plist"
}

configure_terminal_profile_for_fish() {
  local profile="$1"
  local terminal_plist="$HOME/Library/Preferences/com.apple.Terminal.plist"
  local fish_command="/opt/homebrew/bin/fish --login --interactive"

  [[ -n "$profile" ]] || return 0

  if ! /usr/libexec/PlistBuddy -c "Print :'Window Settings':'$profile':name" "$terminal_plist" >/dev/null 2>&1; then
    echo "Terminal profile '$profile' was not found; skipping fish command setup." >&2
    return 0
  fi

  # Terminal profile shell settings. This sets the profile command explicitly
  # instead of changing the account login shell with chsh.
  set_plist_value "$terminal_plist" ":'Window Settings':'$profile':CommandString" string "$fish_command"
  set_plist_value "$terminal_plist" ":'Window Settings':'$profile':RunCommandAsShell" bool false
}

configure_terminal_for_fish() {
  if [[ ! -x /opt/homebrew/bin/fish ]]; then
    echo "fish is not installed at /opt/homebrew/bin/fish; skipping Terminal shell setup." >&2
    return 0
  fi

  local default_profile startup_profile profile
  default_profile="$(defaults read com.apple.Terminal 'Default Window Settings' 2>/dev/null || true)"
  startup_profile="$(defaults read com.apple.Terminal 'Startup Window Settings' 2>/dev/null || true)"

  for profile in "$default_profile" "$startup_profile"; do
    configure_terminal_profile_for_fish "$profile"
  done
}

configure_ghostty_for_fish() {
  if [[ ! -x /opt/homebrew/bin/fish ]]; then
    echo "fish is not installed at /opt/homebrew/bin/fish; skipping Ghostty/cmux shell setup." >&2
    return 0
  fi

  local ghostty_config="$HOME/.config/ghostty/config"
  local target="$ghostty_config"
  local tmp

  mkdir -p "$(dirname "$ghostty_config")"

  if [[ -L "$ghostty_config" ]]; then
    target="$(readlink "$ghostty_config")"
    if [[ "$target" != /* ]]; then
      target="$(cd "$(dirname "$ghostty_config")" && cd "$(dirname "$target")" && pwd)/$(basename "$target")"
    fi
  fi

  tmp="$(mktemp "${TMPDIR:-/tmp}/effective-mac-ghostty.XXXXXX")"
  if [[ -f "$target" ]]; then
    awk '
      /^# BEGIN effective-mac-setup fish shell$/ { skip = 1; next }
      /^# END effective-mac-setup fish shell$/ { skip = 0; next }
      skip != 1 { print }
    ' "$target" > "$tmp"
  fi

  {
    printf '\n# BEGIN effective-mac-setup fish shell\n'
    printf 'command = /opt/homebrew/bin/fish --login --interactive\n'
    printf 'shell-integration = fish\n'
    printf '# END effective-mac-setup fish shell\n'
  } >> "$tmp"

  cat "$tmp" > "$target"
  rm -f "$tmp"
}

# Mouse pointer speed.
#
# Domain/key: NSGlobalDomain com.apple.mouse.scaling
# Why: keep pointer tracking predictable on fresh Macs.
# Note: macOS does not always persist this key until the setting is changed.
MOUSE_TRACKING_SPEED="2.5"
defaults write -g com.apple.mouse.scaling -float "$MOUSE_TRACKING_SPEED"

# Dock: do not show recent/suggested apps.
#
# Domain/key: com.apple.dock show-recents
# Why: keep the Dock intentional instead of letting macOS add transient items.
defaults write com.apple.dock show-recents -bool false

# Dock: keep the current compact-ish icon size.
#
# Domain/key: com.apple.dock tilesize
# Why: serialize the current local preference without also forcing magnification.
# Inspired by the Dock defaults commonly documented in mathiasbynens/dotfiles.
defaults write com.apple.dock tilesize -int 45

# Dock: pinned app list.
#
# Tool: dockutil
# Why: Dock entries are stored as Apple bookmark data; dockutil is clearer and
# more stable than writing persistent-apps directly.
if command -v dockutil >/dev/null 2>&1; then
  safari_app="/System/Applications/Safari.app"
  if [[ ! -e "$safari_app" ]]; then
    safari_app="/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
  fi

  dockutil --remove all --no-restart
  dockutil --add "/System/Applications/Apps.app" --no-restart
  dockutil --add "$safari_app" --no-restart
  dockutil --add "/Applications/Google Chrome.app" --no-restart
  dockutil --add "/System/Applications/Messages.app" --no-restart
  dockutil --add "/System/Applications/Mail.app" --no-restart
  dockutil --add "/Applications/Things3.app" --no-restart
  dockutil --add "/System/Applications/Calendar.app" --no-restart
  dockutil --add "/System/Applications/TV.app" --no-restart
  dockutil --add "/System/Applications/Music.app" --no-restart
  dockutil --add "/Applications/Zed.app" --no-restart
  dockutil --add "$HOME/Downloads" --view fan --display folder --sort dateadded --no-restart
else
  echo "dockutil is not installed; skipping Dock app layout." >&2
fi

# Screenshots: keep captures off the Desktop root and remove window shadows.
#
# Domain/keys: com.apple.screencapture location, disable-shadow
# Why: cleaner Desktop and cleaner screenshots for issues, docs, and sharing.
# As seen in mathiasbynens/dotfiles-style macOS defaults.
SCREENSHOT_DIR="$HOME/Desktop/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
defaults write com.apple.screencapture location -string "$SCREENSHOT_DIR"
defaults write com.apple.screencapture disable-shadow -bool true

# Finder and global file handling.
#
# Domain/keys: NSGlobalDomain AppleShowAllExtensions,
# com.apple.finder FXEnableExtensionChangeWarning, NewWindowTarget
# Why: development workflows benefit from visible extensions and fewer rename
# prompts; new Finder windows should start somewhere stable and personal.
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# Keyboard repeat.
#
# Domain/keys: NSGlobalDomain KeyRepeat, InitialKeyRepeat
# Why: make keyboard navigation feel snappier without using extreme values.
# Inspired by common developer macOS defaults in paulirish/dotfiles.
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15

# iCloud Drive: keep Desktop and Documents in iCloud Drive.
#
# Domain/keys: com.apple.finder FXICloudDriveDesktop, FXICloudDriveDocuments
# Why: preserve the current preference and make the expectation visible.
# Note: this depends on iCloud Drive being enabled for the signed-in Apple ID.
defaults write com.apple.finder FXICloudDriveDesktop -bool true
defaults write com.apple.finder FXICloudDriveDocuments -bool true

# Interactive shells: use fish in Terminal and cmux/Ghostty without chsh.
#
# Why: fish is the default UI shell for owned terminals, while zsh remains the
# account login shell and system fallback. Terminal profiles are only touched
# when they already exist. cmux uses Ghostty configuration for terminal rendering.
configure_terminal_for_fish
configure_ghostty_for_fish

# Restart affected user agents so changes become visible.
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
