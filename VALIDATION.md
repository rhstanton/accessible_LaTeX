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
| veraPDF         | 2026-05-15   | **pass** (both PDFs, PDF/A-4 + UA-2) after `strip_af.py` runs. Also enforced in CI on every push — see below. |
| Blackboard Ally | 2026-05-19   | reports two false positives ("missing title" and "image without description" on every equation); both documented below. |
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

- **Ally: "The PDF does not have a title."** Ally checks the legacy
  Document Information Dictionary `/Title` key, which PDF 2.0
  deprecates in favor of XMP `dc:title`. The LaTeX kernel writes
  XMP correctly under `\DocumentMetadata`; veraPDF accepts it; Ally
  has not caught up.

  > **Do not accept Ally's offered "fix" for this finding.**
  > Accepting the title fix has been observed to rewrite the file
  > as **PDF 1.7**, destroying both PDF/UA-2 and PDF/A-4
  > conformance. The correct title metadata is already present in
  > XMP — leave the source PDF alone and treat the Ally finding as
  > a false positive.

- **Ally: "Image without a description" on every inline equation.**
  Under PDF/UA-2 the LaTeX kernel attaches **MathML** (not `/Alt`) to
  each math `Formula` structure element via `math/setup=mathml-SE`,
  and that MathML is what carries the equation to a screen reader.
  Ally only checks for an `/Alt` attribute and has no PDF/UA-2
  support, so it reports the formula as undescribed. veraPDF accepts
  the MathML tagging; Ally has not caught up. **Treat it as a false
  positive.**

  > **Do not silence this with `\tagpdfsetup{math/alt/use}`.**
  > Template versions through v2.0.1 set that option specifically to
  > quiet this Ally finding — it makes the kernel attach the raw
  > LaTeX source as `/Alt` on each `Formula`. But per PDF/UA a screen
  > reader reads an element's `/Alt` *instead of* descending into its
  > children, and the generated MathML lives in those children. So
  > the option **hides the MathML**: instead of the rendered equation
  > the user hears verbatim LaTeX ("backslash frac open brace…") read
  > aloud. We verified this against the built PDFs — each `Formula`
  > carried both an `/Alt` LaTeX string *and* the MathML subtree, with
  > the `/Alt` shadowing the MathML. The templates removed the line as
  > of v2.1.0 so the MathML reaches assistive technology. Reported by
  > a user; the trade-off (a checker false positive, in exchange for
  > correct screen-reader math) follows the same principle as the
  > `/Title` finding above: don't degrade real accessibility to please
  > a checker.

  > Status: Ally staff have acknowledged the PDF 2.0 / UA-2 gap
  > (covering both the `/Title` finding and this math-formula
  > finding) as a roadmap priority on the Ally user forum:
  > <https://usergroup.ally.ac/s/discussion/post/post/view?id=2362>.
  > Until Ally adds PDF/UA-2 support, treat both findings as false
  > positives.

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
   `verapdf -f ua2 build/accessible_slides.pdf` and `verapdf -f 4
   build/accessible_slides.pdf` (and likewise for the article). The
   `tools/run_strip_af.sh` post-processing must have run; otherwise
   `/AF` warnings will fire. veraPDF exits 0 when the file conforms
   and 1 when it does not.

   This is automated: the `validate` job in
   `.github/workflows/build.yml` runs `verapdf/cli` against all four
   built PDFs against both flavours (`ua2` and `4`) on every push and
   pull request, and fails the build if any PDF stops conforming. So
   the dated row above is re-confirmed continuously, not just at the
   manual checks below. If you have Docker locally you can reproduce
   the CI check with:
   `docker run --rm -v "$PWD/build:/data" verapdf/cli -f ua2 /data/accessible_slides.pdf`
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
