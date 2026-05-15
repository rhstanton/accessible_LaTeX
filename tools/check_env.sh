#!/usr/bin/env bash
# tools/check_env.sh
#
# Diagnostic helper: verify the local environment can build the
# accessible LaTeX templates. Reports a single PASS/FAIL line per
# check and exits non-zero if anything required is missing.
#
# Required:
#   * lualatex on PATH
#   * ltx-talk.cls findable by kpsewhich
#   * LaTeX format date >= 2025-11-01
# Recommended:
#   * pikepdf available to some python on PATH (for strip_af.py)

set -u

PASS="\033[32mPASS\033[0m"
FAIL="\033[31mFAIL\033[0m"
WARN="\033[33mWARN\033[0m"

# Disable colors if output isn't a terminal.
if [ ! -t 1 ]; then
  PASS="PASS"
  FAIL="FAIL"
  WARN="WARN"
fi

fail_count=0
warn_count=0

report_pass() { printf "  [%b] %s\n" "$PASS" "$1"; }
report_fail() { printf "  [%b] %s\n" "$FAIL" "$1"; fail_count=$((fail_count + 1)); }
report_warn() { printf "  [%b] %s\n" "$WARN" "$1"; warn_count=$((warn_count + 1)); }

echo "Checking environment for accessible LaTeX templates..."
echo

# --- LuaLaTeX -------------------------------------------------------------
if command -v lualatex >/dev/null 2>&1; then
  ver=$(lualatex --version 2>/dev/null | head -n 1)
  report_pass "lualatex found: $ver"
else
  report_fail "lualatex not on PATH (install TeX Live / MacTeX / MiKTeX)"
fi

# --- ltx-talk.cls ---------------------------------------------------------
if command -v kpsewhich >/dev/null 2>&1; then
  cls=$(kpsewhich ltx-talk.cls 2>/dev/null || true)
  if [ -n "$cls" ]; then
    report_pass "ltx-talk.cls found: $cls"
  else
    report_fail "ltx-talk.cls not found (run: tlmgr install ltx-talk)"
  fi
else
  report_warn "kpsewhich not available; cannot check ltx-talk.cls"
fi

# --- LaTeX format date ----------------------------------------------------
# Compile a tiny probe document that prints \fmtversion to stdout via
# \message{}. The probe goes to a temp dir; nothing is left behind.
required="2025-11-01"
if command -v lualatex >/dev/null 2>&1; then
  tmp=$(mktemp -d)
  probe="$tmp/probe.tex"
  cat >"$probe" <<'EOF'
\message{ACCESSIBLE_LATEX_FMTVERSION=\fmtversion^^J}
\csname @@end\endcsname
EOF
  log=$(cd "$tmp" && lualatex -interaction=batchmode -halt-on-error probe.tex 2>&1 || true)
  fmt=$(printf "%s" "$log" | sed -n 's/.*ACCESSIBLE_LATEX_FMTVERSION=\([0-9-]*\).*/\1/p' | head -n 1)
  rm -rf "$tmp"
  if [ -n "$fmt" ]; then
    # String comparison works because format is YYYY-MM-DD.
    if [ "$fmt" \> "$required" ] || [ "$fmt" = "$required" ]; then
      report_pass "LaTeX format date $fmt (>= $required)"
    else
      report_fail "LaTeX format date $fmt is older than $required (run: tlmgr update --all)"
    fi
  else
    report_warn "could not parse \\fmtversion from probe compile"
  fi
fi

# --- pikepdf -------------------------------------------------------------
found_py=""
for c in $(command -v -a python3 2>/dev/null) \
         $(command -v -a python 2>/dev/null) \
         /opt/anaconda3/bin/python3 /opt/homebrew/bin/python3 \
         /usr/local/bin/python3 /usr/bin/python3; do
  if [ -x "$c" ] && "$c" -c "import pikepdf" >/dev/null 2>&1; then
    found_py="$c"
    break
  fi
done
if [ -n "$found_py" ]; then
  report_pass "pikepdf available via $found_py"
else
  report_warn "no python with pikepdf found (strip_af.py post-processing will be skipped)"
fi

echo
if [ "$fail_count" -gt 0 ]; then
  echo "Result: $fail_count blocking issue(s), $warn_count warning(s)."
  exit 1
fi
echo "Result: ready to build ($warn_count warning(s))."
exit 0
