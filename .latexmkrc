# .latexmkrc configuration for accessible LaTeX templates.
#
# Forces LuaLaTeX (required for the LaTeX Tagging Project) and runs
# tools/run_strip_af.sh on every successful build so strict PDF/A
# validators don't flag helper Associated Files that the tagging
# tooling leaves embedded.

# Output directory for build artifacts.
$out_dir = "build";

# Use LuaLaTeX (mode 4) -- REQUIRED for accessibility features.
# Mode 1 = pdfLaTeX, Mode 4 = LuaLaTeX. Even if a caller passes -pdf
# (e.g., from Emacs), we redirect pdflatex to lualatex below.
$pdf_mode = 4;

# Common flags:
#   -interaction=nonstopmode  continue through errors without stopping
#   -file-line-error          better error messages
#   -synctex=1                forward/inverse search in editors
#   -shell-escape             required by some packages (use with caution)
my $LUALATEX = "lualatex -interaction=nonstopmode -file-line-error "
             . "-synctex=1 -shell-escape %O %S "
             . "&& tools/run_strip_af.sh $out_dir/%B.pdf";

$lualatex = $LUALATEX;
# Redirect pdflatex (sometimes invoked via -pdf) to lualatex.
$pdflatex = $LUALATEX;

# BibTeX configuration.
# latexmk runs bibtex inside $out_dir, so .bib files in the project
# root won't be found via the default search path. Extend BIBINPUTS
# (and TEXINPUTS for any helper .bst etc.) to include the parent dir.
$ENV{BIBINPUTS} = '..:' . ($ENV{BIBINPUTS} // '');
$ENV{TEXINPUTS} = '..:' . ($ENV{TEXINPUTS} // '');
$bibtex = "bibtex %O %B";
# Force bibtex to run whenever a \bibdata is present (including
# \nocite-only documents like the slides), instead of latexmk's more
# conservative default that can leave \nocite entries unresolved.
$bibtex_use = 2;

# Clean up auxiliary files.
$clean_ext = "aux log out toc nav snm vrb synctex.gz synctex.gz(busy) bbl blg";
