# .latexmkrc configuration for accessible LaTeX slides
# This file configures latexmk to use LuaLaTeX for proper accessibility support

# Output directory for build artifacts
$out_dir = "build";

# Use LuaLaTeX (mode 4) - REQUIRED for accessibility features
# Mode 1 = pdfLaTeX, Mode 4 = LuaLaTeX
# Even if -pdf flag is passed (e.g., from Emacs), we'll redirect to LuaLaTeX
$pdf_mode = 4;

# LuaLaTeX command configuration
# -interaction=nonstopmode: continue through errors without stopping
# -file-line-error: better error messages
# -synctex=1: enable forward/inverse search in editors
# -shell-escape: required for some packages (use with caution)
$lualatex = "lualatex -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape %O %S";

# If pdflatex mode is somehow invoked (e.g., via -pdf flag), redirect to lualatex
# This ensures accessibility features work regardless of how latexmk is called
$pdflatex = "lualatex -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape %O %S";

# BibTeX configuration (if needed)
$bibtex = "bibtex %O %B";

# Clean up auxiliary files
$clean_ext = "aux log out toc nav snm vrb synctex.gz synctex.gz(busy) bbl blg";
