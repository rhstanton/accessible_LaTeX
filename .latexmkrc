# slides/.latexmkrc
$out_dir = "build";
$pdf_mode = 1;
$pdflatex = "pdflatex -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape %O %S";
$bibtex   = "bibtex %O %B";
