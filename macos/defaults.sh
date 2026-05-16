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
