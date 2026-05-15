;; slides/.dir-locals.el
;;
;; Build policy:
;; - Default build: latexmk
;; - Manual lualatex + bibtex available
;; - minted support: -shell-escape
;; - ALL outputs (pdf/aux/log/synctex/_minted/...) go to slides/build/
;;
;; Usage:
;; - C-c C-c  -> runs latexmk by default
;; - C-c C-c  -> choose lualatex or bibtex if needed

((latex-mode
  . ((TeX-command-default . "LatexMk (build)")
     (eval
      . (progn
          (require 'tex)

          ;; Tell AUCTeX where outputs live so it parses the right log/aux/bbl
          (setq-local TeX-output-dir "build/")

          ;; Ensure build dir exists
          (unless (file-directory-p "build")
            (make-directory "build" t))

          ;; Common TeX flags (minted needs -shell-escape)
          (defconst my/tex-flags
            "-interaction=nonstopmode -file-line-error -synctex=1 -shell-escape")

          ;; latexmk default
          (add-to-list 'TeX-command-list
                       `("LatexMk (build)"
                         ,(concat
                           "latexmk -lualatex " my/tex-flags " -outdir=build %s"
                           " && python3 strip_af.py build/%b.pdf")
                         TeX-run-TeX nil t
                         :help "latexmk (lualatex) + strip_af.py -> build/"))

          ;; manual lualatex
          (add-to-list 'TeX-command-list
                       `("LuaLaTeX (build)"
                         ,(concat "lualatex " my/tex-flags " -output-directory=build %s")
                         TeX-run-TeX nil t
                         :help "lualatex -> build/"))

          ;; BibTeX must run on aux in build/
          (add-to-list 'TeX-command-list
                       '("BibTeX (build)"
                         "job=$(basename %s .tex) && (cd build && bibtex ${job})"
                         TeX-run-BibTeX nil t
                         :help "bibtex (run in build/)"))

          ;; Clean build dir
          (add-to-list 'TeX-command-list
                       '("Clean (build)"
                         "latexmk -C -outdir=build"
                         TeX-run-command nil t
                         :help "latexmk -C in build/"))

          ;; SyncTeX support
          (setq TeX-source-correlate-mode t)
          (setq TeX-source-correlate-start-server t)

          ;; IMPORTANT: keep latexmk as the default even if AUCTeX suggests BibTeX
          (setq-local TeX-command-default "LatexMk (build)")

          ))))))

