# Accessible LaTeX Templates (v2.0.1)

![Build](https://github.com/rhstanton/accessible_LaTeX/actions/workflows/build.yml/badge.svg)
![License: CC0](https://img.shields.io/badge/license-CC0-blue)
![TeX Live](https://img.shields.io/badge/TeX%20Live-2023%2B-green)
![Engine](https://img.shields.io/badge/engine-LuaLaTeX-blue)

Richard Stanton — UC Berkeley

https://github.com/rhstanton/accessible_LaTeX

---

> [!IMPORTANT]
> **If you run the example PDFs through Blackboard Ally and see a "missing title" error, don't worry — and don't click Ally's "fix."**
>
> v2.0 of this template upgraded from PDF/UA-1 + PDF/A-2 to **PDF/UA-2 + PDF/A-4** (PDF 2.0), the newer/stricter accessibility standard. Ally still checks a legacy PDF-1.x `/Title` key that PDF 2.0 deprecated, so it reports the file as untitled even though the title is correctly present in XMP. The PDFs pass **veraPDF** (the strict PDF/A conformance checker) cleanly. **Don't accept Ally's offered "fix" — it may downgrade the file to PDF 1.7 and destroy both PDF/UA-2 and PDF/A-4 conformance.** Full details in [VALIDATION.md](VALIDATION.md).

> [!IMPORTANT]
> **If you adapt these templates, keep the `\tagpdfsetup{math/alt/use}` line in the preamble.** Without it, Ally reports every inline equation as "image without description." Under PDF/UA-2 the LaTeX kernel does not attach `/Alt` to math `Formula` tags by default (the embedded MathML is meant to suffice), but Ally still checks for `/Alt`. Opting in silences that false positive.

---

## Overview

As of **May 11, 2026**, updated ADA rules require digital course materials—including materials on password-protected course sites—to meet accessibility standards (**WCAG 2.1 Level AA**).

Many instructors write course materials in **LaTeX**, but standard LaTeX (including Beamer) does **not automatically generate accessible PDFs**.

This repository provides **working templates and migration guidance** for creating accessible LaTeX documents that meet those requirements.

## Glossary

A few terms used throughout this README and in the templates:

- **WCAG 2.1 AA** — Web Content Accessibility Guidelines, level AA. The legal target for digital course materials.
- **PDF tagging** — invisible structure tree embedded in the PDF that tells screen readers what's a heading, list, paragraph, table, etc. Enabled by `tagging=on` in `\DocumentMetadata`.
- **PDF/UA-2** — ISO standard for tagged-PDF accessibility. The tagging output targets this.
- **PDF/A-4** — ISO standard for archival PDFs (long-term readable, no external dependencies). The templates target this profile.
- **MathML** — XML representation of math equations that screen readers can read. LuaLaTeX generates this automatically when the metadata is set up.
- **Alt text** — short text description on an image, read instead of the image by screen readers (`alt={...}` on `\includegraphics`).
- **Ally** — Anthology's accessibility checker, integrated into bCourses (Canvas) and several other LMSs.
- **veraPDF / PAC** — third-party PDF conformance validators (open-source and free, respectively).

📊 **Example output**

- [accessible_slides.pdf](accessible_slides.pdf)
- [accessible_article.pdf](accessible_article.pdf)

The slides document is the most complete example and the best place to start.

Two templates are included:

- **`accessible_slides.tex`** — accessible presentation slides using `ltx-talk`
- **`accessible_article.tex`** — accessible article-style documents

---

# Quick Summary (TL;DR)

Making LaTeX accessible requires **five common steps**.

These apply to both **slides and articles**.

---

## Converting Existing Documents? What to ADD

If you're converting existing LaTeX/Beamer files, here's what to add:

### Required for ALL documents

1. **At the very top** (before `\documentclass`):
   ```latex
   \DocumentMetadata{
     pdfstandard=a-4,
     pdfstandard=ua-2,
     lang=en-US,
     tagging=on,
     tagging-setup={
       math/setup=mathml-SE
     }
   }
   ```

  The snippets in this README use the current PDF/A-4 + PDF/UA-2 profile.

2. **In every `\includegraphics`**:
   ```latex
   \includegraphics[alt={Description of image}]{figure}
   ```

3. **Before every table**:
   ```latex
   \tagpdfsetup{table/header-rows={1}}
   ```

4. **Use accessible color contrast** — WCAG 2.1 AA requires ≥4.5:1 contrast for normal text. Avoid plain `yellow`/`cyan` for text; use darkened variants such as `red!80!black`, `green!40!black`.

5. **Change compiler to LuaLaTeX**

### Additional for Beamer slides

6. **Change document class**:
   ```latex
   \documentclass[frame-title-arg]{ltx-talk}  % was \documentclass{beamer}
   ```
   - Keep your `\begin{frame}` environments as-is
   - Remove Beamer themes/templates/colors
   - Recreate styling with standard LaTeX packages

---

## Five Common Steps Summary

1. Add `\DocumentMetadata` before `\documentclass`
2. Tag images with alt text
3. Tag table header rows
4. Use accessible color contrast
5. Compile with **LuaLaTeX**

### One Class-Specific Step

| Document Type | Requirement                         |
| ------------- | ----------------------------------- |
| Articles      | Keep `article`, `report`, or `book` |
| Slides        | Replace `beamer` with `ltx-talk`    |

---

# Minimal Slides Example

```latex
\DocumentMetadata{
  pdfstandard=a-4,    % PDF/A-4 archival standard
  pdfstandard=ua-2,   % PDF/UA-2 accessibility standard
  lang=en-US,
  tagging=on,
  tagging-setup={
    math/setup=mathml-SE
  }
}

\documentclass[frame-title-arg]{ltx-talk}

\tagpdfsetup{role/new-tag=frametitle/H1}

\ExplSyntaxOn
\AtBeginDocument{
  \NewTaggingSocketPlug{talk/sec/title}{none}{}
  \AssignTaggingSocketPlug{talk/sec/title}{none}
}
\ExplSyntaxOff

\title{Accessible LaTeX Slides}
\author{Richard Stanton}

\begin{document}

\maketitle

\begin{frame}{Example Slide}
Accessible math: \(E = mc^2\)
\includegraphics[alt={Example image}]{capybara}
\end{frame}

\end{document}
```

Compile with:

```bash
lualatex example.tex
```

For full configuration and validator workarounds, see `accessible_slides.tex`.

---

# Who This Repository Is For

This repository is intended for:

- instructors creating **course materials in LaTeX**
- researchers preparing **accessible PDFs**
- users migrating **existing LaTeX documents to WCAG-compliant PDFs**

---

# Article vs Slides

| Feature             | Articles                    | Slides        |
| ------------------- | --------------------------- | ------------- |
| Document class      | `article`, `report`, `book` | `ltx-talk`    |
| Class change needed | No                          | Yes           |
| Frame environment   | N/A                         | Yes           |
| Beamer themes       | N/A                         | Not supported |
| Accessibility steps | Same for both               | Same for both |

---

# The LaTeX Tagging Project

Both templates use infrastructure from the **LaTeX Tagging Project**.

https://latex3.github.io/tagging-project/

This provides:

- automatic **PDF tagging**
- **MathML generation**
- structured headings
- accessible lists and tables
- PDF/A archival compatibility

Requirements:

- **LaTeX kernel 2025-11-01 or later**
- **TeX Live 2023+ with updates applied**

---

# Quick Start

Clone the repository:

```bash
git clone https://github.com/rhstanton/accessible_LaTeX.git
cd accessible_LaTeX
```

Compile:

```bash
lualatex accessible_slides.tex
```

or

```bash
lualatex accessible_article.tex
```

If you cloned and aren't sure your local LaTeX is recent enough, run:

```bash
tools/check_env.sh
```

It checks LuaLaTeX, the kernel date, `ltx-talk.cls`, and whether
`pikepdf` is available for `strip_af.py`.

---

# Requirements

Minimum environment:

- **TeX Live 2023+**
- **LaTeX kernel 2025-11-01+**
- **LuaLaTeX**

Update packages if necessary:

```bash
tlmgr update --all
```

### Platform-specific setup

**macOS (MacTeX):**

```bash
sudo tlmgr update --self --all   # update everything
```

In TeXShop, set `Typeset > LaTeX` to **LuaLaTeX**.

**Linux (TeX Live):**

```bash
sudo tlmgr update --self --all
```

If `tlmgr` is missing on Debian/Ubuntu, install upstream TeX Live
directly from <https://tug.org/texlive/> — the apt-packaged TeX Live
typically lags behind the kernel date required here.

**Windows (MiKTeX or TeX Live):**

- MiKTeX: open MiKTeX Console > **Updates** > **Check for updates**.
- TeX Live: open the **TeX Live Manager** GUI and apply all updates.

In TeXstudio / TeXworks, set **Options > Configure > Build** (or
**Edit > Preferences > Typesetting**) to use the LuaLaTeX command.
In VS Code with LaTeX Workshop, set
`"latex-workshop.latex.tools"` to invoke `lualatex` and pick that
tool in your recipe.

**Overleaf** (any OS): see the dedicated section below.

---

# Using Overleaf

This template works on **Overleaf** using the **Labs environment**.

Steps:

1. Join the Overleaf Labs program  
2. Enable **Rolling TeX Live releases**
3. Set compiler to **LuaLaTeX**

https://www.overleaf.com/labs/participate

---

# Repository Layout

| File / directory       | Purpose                                                |
| ---------------------- | ------------------------------------------------------ |
| accessible_article.tex | full annotated accessible article                      |
| accessible_slides.tex  | full annotated accessible slide deck (most complete example) |
| minimal_article.tex    | smallest runnable article example (~40 lines)          |
| minimal_slides.tex     | smallest runnable slides example (~40 lines)           |
| slide_utils.sty        | optional: section-separator slides + PDF bookmarks      |
| slide_bib.sty          | optional: multi-page bibliography (auto-splits .bbl)   |
| rsbibsplit.lua         | Lua script that splits .bbl into per-frame chunks      |
| sample.bib             | sample BibTeX entries used by the slides example       |
| capybara.jpg           | sample figure                                          |
| BerkeleyHaas.png       | logo used on the slides title page                     |
| strip_af.py            | post-build cleanup for strict PDF/A validators (needs `pikepdf`) |
| tools/run_strip_af.sh  | wrapper that finds a Python with `pikepdf` and runs strip_af.py |
| tools/check_env.sh     | preflight check for LuaLaTeX, kernel date, ltx-talk, pikepdf |
| VALIDATION.md          | current validator status and known false positives     |
| .latexmkrc             | build configuration (forces LuaLaTeX, runs strip_af.py) |
| .dir-locals.el         | Emacs/AUCTeX project-local commands                    |
| .github/workflows/     | CI: builds all four templates on every push            |
| build/                 | latexmk output directory (gitignored)                  |

---

# Key Accessibility Features

Both templates demonstrate:

- tagged document structure
- accessible math (MathML)
- accessible tables
- alt text for images
- accessible color contrast
- accessible links

---

# DocumentMetadata Configuration

Every accessible document must begin with a `\DocumentMetadata{...}` block before `\documentclass`.

```latex
\DocumentMetadata{
  pdfstandard=a-4,
  pdfstandard=ua-2,
  lang=en-US,
  tagging=on,
  tagging-setup={
    math/setup=mathml-SE
  }
}
```

For a complete working example in context, see `accessible_slides.tex`.

## Documents in other languages

`lang=` is the document's primary language. Use a BCP-47 tag — e.g.,
`lang=es-ES` for Spanish (Spain), `lang=fr-FR` for French, `lang=de`
for German, `lang=zh-CN` for simplified Chinese. Screen readers use
this to pick a voice and pronunciation.

For passages in a different language inside an otherwise-English
document, load `babel` with both languages and wrap the passage with
`\foreignlanguage`:

```latex
\usepackage[english,french]{babel}
...
\foreignlanguage{french}{Bonjour le monde.}
```

The tagged PDF then carries the inner language attribute, so screen
readers switch voices at the boundary.

---

# Common Pitfalls

### 1. Using an incomplete `\DocumentMetadata` block

A minimal example may compile, but the recommended configuration is the one used in `accessible_slides.tex`.

### 2. Confusing PDF tagging with PDF bookmarks

**Important distinction:**

- **PDF tagging** (`tagging=on`): Creates structure tree for screen readers
  - REQUIRED for accessibility compliance
  - Happens automatically once enabled
  
- **PDF bookmarks**: Navigation outline in the left pane
  - NOT required for accessibility
  - Do NOT generate automatically from `tagging=on`
  - Require custom code (see `accessible_slides.tex` for example)
  - For articles, use `\tableofcontents` or the `bookmark` package

If you want bookmarks in your PDFs, you need to add bookmark-generation code yourself. The slides template includes example code for this.

### 3. Missing PDF metadata

Some validators require a document title in the XMP metadata.

```latex
\title{Document title}
\author{Author name}
```

### 4. Missing alt text on images

```latex
\includegraphics[alt={Description of image}]{file}
```

### 5. Incorrect table header tagging

```latex
\tagpdfsetup{table/header-rows={1}}
```

### 6. Using the wrong engine

Use **LuaLaTeX**, not XeLaTeX or pdfLaTeX.

### 7. Expecting `ltx-talk` to behave like Beamer

Beamer themes and templates do not transfer directly.

### 8. Starting from the wrong file

`accessible_slides.tex` is the most complete example.

---

# Validator Notes

Different accessibility checkers test different things; no single tool catches everything. The practical workflow is to run more than one and compare findings.

- **veraPDF** is the meaningful PDF/UA-2 + PDF/A-4 conformance check; both example PDFs pass it cleanly (after `strip_af.py` runs).
- **Ally** reports a single false positive ("missing title") under PDF/UA-2; **PAC and Adobe Acrobat** have not fully caught up to PDF/UA-2 either and produce a small predictable set of false positives on these files.

See [VALIDATION.md](VALIDATION.md) for the per-tool status, the full list of known false positives, and the **important warning about not accepting Ally's offered "fix"** for the missing-title finding (which would silently downgrade the PDF to PDF 1.7 and destroy UA-2 / PDF/A-4 conformance).

---

# Optional Validator Cleanup

```bash
python strip_af.py build/yourfile.pdf
pip install pikepdf
```

---

# Troubleshooting

### Undefined `\DocumentMetadata`

Upgrade to **TeX Live 2023+**.

### `ltx-talk.cls` not found

Update your TeX distribution.

### Compilation is slow

LuaLaTeX is slower than pdfLaTeX.

---

# Tested Environments

- TeX Live 2025  
- MacTeX  
- Overleaf Rolling TeX Live  
- LuaLaTeX  

---

# Resources

LaTeX Tagging Project  
https://latex3.github.io/tagging-project/

WCAG 2.1  
https://www.w3.org/WAI/standards-guidelines/wcag/

---

# Acknowledgments

- Andrei Kurbatov — https://github.com/andreigithubK

---

# License

Released under **CC0 1.0 Universal**.

No restrictions. No warranty.
