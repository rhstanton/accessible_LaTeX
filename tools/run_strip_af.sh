#!/usr/bin/env bash
# tools/run_strip_af.sh
#
# Wrapper invoked by .latexmkrc after each successful build.
# Locates a Python interpreter that has `pikepdf` installed, then
# runs strip_af.py against the given PDF. If no suitable Python is
# found, prints a notice and exits 0 (the build is not blocked).
#
# Usage:   tools/run_strip_af.sh build/foo.pdf

set -u

PDF=${1:-}
if [ -z "$PDF" ]; then
  echo "run_strip_af.sh: missing PDF argument" >&2
  exit 2
fi

# Script lives in tools/; the actual strip script is one level up.
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
STRIP_PY="$SCRIPT_DIR/../strip_af.py"

find_python() {
  # 1. Any python3/python on PATH (in PATH order, deduplicated).
  local candidates
  candidates=$(
    { command -v -a python3 2>/dev/null; command -v -a python 2>/dev/null; } \
      | awk '!seen[$0]++'
  )
  # 2. Common install paths as a fallback.
  local fallback="/opt/anaconda3/bin/python3 /opt/homebrew/bin/python3 /usr/local/bin/python3 /usr/bin/python3"

  for c in $candidates $fallback; do
    if [ -x "$c" ] && "$c" -c "import pikepdf" >/dev/null 2>&1; then
      echo "$c"
      return 0
    fi
  done
  return 1
}

PY=$(find_python)
if [ -z "$PY" ]; then
  echo "Latexmk: strip_af skipped (no python with pikepdf found)"
  exit 0
fi

echo "Latexmk: strip_af python: $PY"
"$PY" "$STRIP_PY" "$PDF"
