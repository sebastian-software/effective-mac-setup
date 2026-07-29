#!/usr/bin/env bash
set -euo pipefail

python_version="3.12"

if ! command -v uv >/dev/null 2>&1; then
  echo "uv is missing. Install it from the Brewfile first." >&2
  exit 1
fi

echo "==> Installing uv-managed Python $python_version"
uv python install "$python_version"

echo "==> Pinning the default uv Python to $python_version"
uv python pin --global "$python_version"

tool_is_installed() {
  local package="$1"
  uv tool list | grep -Fq "$package v"
}

install_tool() {
  local package="$1"
  shift

  if tool_is_installed "$package"; then
    echo "==> $package is already managed by uv"
    return
  fi

  echo "==> Installing $package with uv"
  uv tool install --managed-python --python "$python_version" "$@" "$package"
}

install_tool fonttools

# huggingface-hub 1.2.x imports click in its CLI but does not declare it in the
# package metadata. Keep the compatibility dependency explicit until upstream
# restores it.
install_tool huggingface-hub --with "click>=8.1"

install_tool openai-whisper
install_tool semgrep
