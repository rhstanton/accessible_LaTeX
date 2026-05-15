# Validation status

This file records which accessibility validators have been run against
the example PDFs in this repository, what they reported, and which of
those reports are false positives that can be ignored.

Dated claims are concentrated here so the templates and the README
don't carry information that silently rots. If you re-run the
validators, please update the dates in the per-validator table below.

## Quick summary

The templates target:

- **WCAG 2.1 Level AA** for accessibility.
- **PDF/UA-2** for tagged-PDF accessibility conformance.
- **PDF/A-4** for archival conformance (after `strip_af.py` post-processing).

**The meaningful conformance check today is veraPDF**, which supports
PDF/UA-2 and PDF/A-4 and passes both example PDFs cleanly. Other
common checkers (Ally, PAC, Acrobat) have not yet caught up to
PDF/UA-2; their reports include a predictable set of false positives
documented below — they are not regressions in the templates.

## Why some validators report errors (the v2.0 context)

Template v2.0 upgraded the metadata target from PDF/UA-1 + PDF/A-2
(PDF 1.7) to **PDF/UA-2 + PDF/A-4 (PDF 2.0)**. UA-2 is newer, stricter,
and more accessible — but most accessibility checkers are still
calibrated for UA-1 / PDF 1.7 and don't yet recognize the new
structure tags, role names, or metadata conventions that UA-2
introduces. The false positives listed below are the visible
consequence: a more standards-compliant PDF that existing tools
haven't fully learned to read yet.

If you must score 100% in a UA-1-era checker (e.g., for an LMS
gatekeeping check), you can revert to the older profile by changing
`\DocumentMetadata{...}` to `pdfstandard=ua-1, pdfstandard=a-2u`
(and rolling back the `tagging-setup`). You will lose the
accessibility improvements of UA-2 in exchange for cleaner reports.

## Per-validator status

| Validator       | Last checked | Result                                                           |
| --------------- | ------------ | ---------------------------------------------------------------- |
| veraPDF         | 2026-05-15   | **pass** (both PDFs, PDF/A-4 + UA-2) after `strip_af.py` runs.   |
| Blackboard Ally | 2026-05-15   | reports ~9 false positives per PDF; all documented below.        |
| PAC 26.1.0      | 2026-05-15   | non-trivial failure count; PAC has no UA-2 checker — see below.  |
| Adobe Acrobat   | 2026-05-15   | pass with one persistent false positive on `<Lbl>`/`<LBody>`.    |

## False positives — per-tool quirks (also present under UA-1)

These false positives are validator bugs unrelated to the UA-2 upgrade;
they would appear under any modern LaTeX tagging workflow.

- **Acrobat: `Lbl and LBody — Failed`.** Acrobat's accessibility
  checker raises this on tagged lists, figure captions, table
  captions, and numbered sections even when the `<Lbl>` tag is
  structurally correct. Reference:
  <https://tex.stackexchange.com/a/709655/2388>.
- **PAC: `Table header cell has no associated subcells`.** PAC
  reports this even when `\tagpdfsetup{table/header-rows={...}}`
  is set correctly. Still present in PAC 26.1.0 (March 2026); no
  fix listed in the release notes. Track:
  <https://pac.pdf-accessibility.org/en/resources/release-notes>.

## False positives — UA-2 / PDF 2.0 checker-coverage gaps

These appeared with template v2.0's upgrade to PDF/UA-2 + PDF/A-4 +
PDF 2.0. They reflect checkers that haven't caught up to the newer
standards, not bugs in the templates.

- **PAC validates against PDF/UA-1 even on PDF/UA-2 files.** At open,
  PAC pops up a dialog saying it "currently fully supports documents
  up to and including PDF standard 1.7." The test report then shows
  `Standard: PDF/UA-1` regardless of what the file targets — PAC has
  no UA-2 checker and silently falls back to UA-1. As a result, PAC
  reports a non-trivial failure count on files like these. In a
  2026-05-15 run of `accessible_slides.pdf`: 27 Structure-elements
  failures, 29 Role-mapping failures, 9 Alternative-Descriptions
  failures, 260 Structure-tree warnings. These are not real
  conformance bugs — they are "this doesn't match UA-1" reports
  against a deliberately UA-2 file. For a real UA-2 conformance
  check, use veraPDF.

- **Ally: "Image without a description" on every inline equation.**
  Ally doesn't yet parse UA-2 MathML content tags, so it reports
  every rendered inline equation as an untagged image. In
  `accessible_slides.pdf`, this surfaces on ~8 items, including
  the `\$1234567890\%.$` font-comparison lines on "Slide content:
  mostly the same as Beamer", the `$\Rightarrow$` on the
  caption-vs-alt slide, the `$\leftarrow$` arrows annotating the
  table example, and the math in the "Tables: header rows" headers
  (`$DF_\text{pay}$`, `$T_\text{expiry}$`, `$\Delta$`). In
  `accessible_article.pdf` the same issue affects the
  `$\mathit{math}$` example in "The basics" and the column-header
  math in the example table. The math *is* tagged as MathML; Ally
  hasn't learned to read it.

- **Ally: "The PDF does not have a title."** Ally checks the legacy
  Document Information Dictionary `/Title` key, which PDF 2.0
  deprecates in favor of XMP `dc:title`. The LaTeX kernel writes
  XMP correctly under `\DocumentMetadata`; veraPDF accepts it; Ally
  has not caught up.

  > **Do not accept any of Ally's offered "fixes" for these
  > findings.** Accepting the title fix has been observed to rewrite
  > the file as **PDF 1.7**, destroying both PDF/UA-2 and PDF/A-4
  > conformance. Other fixes (e.g., the math-as-image findings) are
  > untested but plausibly behave the same way. The correct title
  > metadata is already present in XMP, and the math is already
  > tagged as MathML — leave the source PDF alone and treat the
  > Ally findings as false positives.

## Known limitations (real, not false positives)

- **Syntax-highlighted code listings aren't tagging-compatible yet.**
  As of TeX Live 2026:
  - `listings` produces unbalanced tagpdf paragraph-hook boundaries
    and untagged blocks. Tracked:
    <https://github.com/latex3/tagging-project/issues/41>,
    <https://github.com/latex3/tagging-project/issues/70>.
  - `minted` hits the same problem because it loads `fvextra`, which
    clobbers the kernel's tagging firstaid for `fancyvrb`. Tracked:
    <https://github.com/latex3/tagging-project/issues/1060>.
  - Empirically, `\SuspendTagging` / `\ResumeTagging` + artifact MC
    wrapping does **not** rescue the listings case in TeX Live 2026
    inside an `ltx-talk` frame — the structure tree still ends up
    half-closed and tagpdf errors at `\end{document}`.

  **Current workaround used in these templates:** `fancyvrb`'s
  `\VerbatimInput`. It tags cleanly (it's what `ltx-talk`'s own
  examples use) but does not syntax-highlight. When the upstream
  issues are fixed, the templates can switch back to `listings` or
  `minted`; the slides/article preambles show the WCAG-AA color
  palette to use.

## How to re-run the validators

1. Rebuild the PDFs: `latexmk accessible_slides.tex` and
   `latexmk accessible_article.tex`.
2. **veraPDF** — the meaningful UA-2 / PDF/A-4 check:
   `verapdf --profile ua-2 build/accessible_slides.pdf` (and the
   article). The `tools/run_strip_af.sh` post-processing must have
   run; otherwise `/AF` warnings will fire.
3. **Ally** — upload each PDF to a bCourses test course (or any LMS
   with Ally enabled) and read the per-file score panel. Expect the
   false positives listed above.
4. **PAC** — open the PDF in the latest PAC (26.1.0 or later) and
   run the full check. The dialog warning and the `Standard:
   PDF/UA-1` line in the report are expected.
5. **Adobe Acrobat** — Pro > Tools > Accessibility > Full Check.
   Expect the `<Lbl>`/`<LBody>` false positive.

If any **new** issues appear that aren't already listed above, treat
them as real findings and either fix the source or document the new
behavior here.
