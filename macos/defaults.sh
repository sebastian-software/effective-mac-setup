#!/usr/bin/env bash
set -euo pipefail

# Curated macOS settings.
#
# This file intentionally names desired behavior and applies it via the smallest
# known mechanism. Do not turn this into a blind export of ~/Library/Preferences.

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

# Restart affected user agents so changes become visible.
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
