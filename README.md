# Accessible LaTeX Templates (v1.4)

![License: CC0](https://img.shields.io/badge/license-CC0-blue)  
![TeX Live](https://img.shields.io/badge/TeX%20Live-2023%2B-green)  
![Engine](https://img.shields.io/badge/engine-LuaLaTeX-blue)

Richard Stanton — UC Berkeley  
Feb 10, 2026  

https://github.com/rhstanton/accessible_LaTeX

---

## Overview

As of **April 2026**, updated ADA rules require digital course materials—including materials on password-protected course sites—to meet accessibility standards (**WCAG 2.1 Level AA**).

Many instructors write course materials in **LaTeX**, but standard LaTeX (including Beamer) does **not automatically generate accessible PDFs**.

This repository provides **working templates and migration guidance** for creating accessible LaTeX documents that meet those requirements.

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

### Five Common Steps

1. Add `\DocumentMetadata` before `\documentclass`
2. Tag images with alt text
3. Tag table header rows
4. Use accessible color contrast
5. Compile with **LuaLaTeX**

Example:

```latex
\includegraphics[alt={Description of image}]{figure}
```

```latex
\tagpdfsetup{table/header-rows={1}}
```

### One Class-Specific Step

| Document Type | Requirement |
|---|---|
| Articles | Keep `article`, `report`, or `book` |
| Slides | Replace `beamer` with `ltx-talk` |

---

# Minimal Slides Example

```latex
\DocumentMetadata{
  pdfstandard=a-2u,   % PDF/A archival standard
  pdfstandard=ua-1,   % PDF/UA accessibility standard
  pdfversion=1.7,
  lang=en-US,
  tagging=on,
  tagging-setup={
    math/alt/use,
    math/mathml/AF=false,
    math/tex/AF=false,
    math/mathml/sources=
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

| Feature | Articles | Slides |
|---|---|---|
| Document class | `article`, `report`, `book` | `ltx-talk` |
| Class change needed | No | Yes |
| Frame environment | N/A | Yes |
| Beamer themes | N/A | Not supported |
| Accessibility steps | Same for both | Same for both |

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

```
accessible_article.tex
accessible_slides.tex
capybara.jpg
strip_af.py
.latexmkrc
```

| File | Purpose |
|---|---|
| accessible_article.tex | example accessible article |
| accessible_slides.tex | example accessible slides |
| capybara.jpg | sample figure |
| strip_af.py | optional validator cleanup script |
| .latexmkrc | build configuration |

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
  pdfstandard=a-2u,
  pdfstandard=ua-1,
  pdfversion=1.7,
  lang=en-US,
  tagging=on,
  tagging-setup={
    math/alt/use,
    math/mathml/AF=false,
    math/tex/AF=false,
    math/mathml/sources=
  }
}
```

For a complete working example in context, see `accessible_slides.tex`.

---

# Common Pitfalls

### 1. Using an incomplete `\DocumentMetadata` block

A minimal example may compile, but the recommended configuration is the one used in `accessible_slides.tex`.

### 2. Missing PDF metadata

Some validators require a document title in the XMP metadata.

```latex
\title{Document title}
\author{Author name}
```

### 3. Missing alt text on images

```latex
\includegraphics[alt={Description of image}]{file}
```

### 4. Incorrect table header tagging

```latex
\tagpdfsetup{table/header-rows={1}}
```

### 5. Using the wrong engine

Use **LuaLaTeX**, not XeLaTeX or pdfLaTeX.

### 6. Expecting `ltx-talk` to behave like Beamer

Beamer themes and templates do not transfer directly.

### 7. Starting from the wrong file

`accessible_slides.tex` is the most complete example.

---

# Validator Notes

Different accessibility tools check different aspects of a PDF.

### Ally vs archival validators

Ally checks usability and accessibility structure.  
veraPDF checks strict PDF/A archival conformance.

### Acrobat `<Lbl>` errors

```
Lbl and LBody – Failed
```

This is a known issue with Acrobat’s accessibility checker and can generally be ignored.

### PAC table-header warnings

PAC may report:

```
Table header cell has no associated subcells
```

even when header rows are tagged correctly.

### Validator disagreements

Recommended workflow:

1. Run multiple validators.
2. Compare findings.
3. Investigate structural issues but treat isolated warnings cautiously.

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

