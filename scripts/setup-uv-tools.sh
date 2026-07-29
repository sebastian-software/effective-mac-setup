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

tool_matches_configuration() {
  local package="$1"
  local executable="$2"
  local required_distribution="$3"
  local minimum_version="$4"
  local tool_python tool_executable actual_python

  tool_python="$(uv tool dir)/$package/bin/python"
  [[ -x "$tool_python" ]] || return 1

  tool_executable="$(uv tool dir --bin)/$executable"
  [[ -x "$tool_executable" ]] || return 1

  actual_python="$("$tool_python" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
  if [[ "$actual_python" != "$python_version" ]]; then
    return 1
  fi

  if [[ -n "$required_distribution" ]]; then
    if ! "$tool_python" -c '
from importlib.metadata import version
import re
import sys

distribution, minimum = sys.argv[1:]
__import__(distribution)
release = lambda value: tuple(
    int(part) for part in re.match(r"\d+(?:\.\d+)*", value).group().split(".")
)
raise SystemExit(release(version(distribution)) < release(minimum))
' "$required_distribution" "$minimum_version" >/dev/null 2>&1; then
      return 1
    fi
  fi
}

install_tool() {
  local package="$1"
  local executable="$2"
  local required_distribution="$3"
  local minimum_version="$4"
  shift 4

  if tool_matches_configuration "$package" "$executable" "$required_distribution" "$minimum_version"; then
    echo "==> $package already matches the managed uv configuration"
    return
  fi

  echo "==> Reconciling $package with the managed uv configuration"
  uv tool install --force --managed-python --python "$python_version" "$@" "$package"
}

install_tool fonttools fonttools "" ""

# huggingface-hub 1.2.x imports click in its CLI but does not declare it in the
# package metadata. Keep the compatibility dependency explicit until upstream
# restores it.
install_tool huggingface-hub hf click 8.1 --with "click>=8.1"

install_tool openai-whisper whisper "" ""
install_tool semgrep semgrep "" ""
