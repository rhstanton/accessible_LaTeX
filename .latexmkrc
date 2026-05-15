# .latexmkrc configuration for accessible LaTeX slides
# This file configures latexmk to use LuaLaTeX for proper accessibility support

# Output directory for build artifacts
$out_dir = "build";

# Post-processing command used after successful LaTeX runs.
# It first scans python executables on PATH, then probes common install paths,
# and uses the first interpreter that can import pikepdf.
$strip_af_post = '( PY=""; CANDS=$( (which -a python3 2>/dev/null; which -a python 2>/dev/null) | awk \'!seen[$0]++\' ); for CAND in $CANDS; do if "$CAND" -c "import pikepdf" >/dev/null 2>&1; then PY="$CAND"; break; fi; done; if [ -z "$PY" ]; then for CAND in /opt/anaconda3/bin/python3 /opt/homebrew/bin/python3 /usr/local/bin/python3 /usr/bin/python3; do if [ -x "$CAND" ] && "$CAND" -c "import pikepdf" >/dev/null 2>&1; then PY="$CAND"; break; fi; done; fi; if [ -n "$PY" ]; then echo "Latexmk: strip_af python: $PY"; "$PY" strip_af.py build/%B.pdf && /bin/rm -f build/%B.noaf.pdf || true; else echo "Latexmk: strip_af skipped (no python with pikepdf found)"; fi )';

# Use LuaLaTeX (mode 4) - REQUIRED for accessibility features
# Mode 1 = pdfLaTeX, Mode 4 = LuaLaTeX
# Even if -pdf flag is passed (e.g., from Emacs), we'll redirect to LuaLaTeX
$pdf_mode = 4;

# LuaLaTeX command configuration
# -interaction=nonstopmode: continue through errors without stopping
# -file-line-error: better error messages
# -synctex=1: enable forward/inverse search in editors
# -shell-escape: required for some packages (use with caution)
# Post-step: run strip_af.py on the generated PDF so strict PDF/A validators
# don't flag helper associated files left by current tagging internals.
$lualatex = "lualatex -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape %O %S && $strip_af_post";

# If pdflatex mode is somehow invoked (e.g., via -pdf flag), redirect to lualatex
# This ensures accessibility features work regardless of how latexmk is called
$pdflatex = "lualatex -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape %O %S && $strip_af_post";

# BibTeX configuration (if needed)
$bibtex = "bibtex %O %B";

# Clean up auxiliary files
$clean_ext = "aux log out toc nav snm vrb synctex.gz synctex.gz(busy) bbl blg";
