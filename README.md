# Accessible LaTeX Slides Template (v1.0)

A template for creating **accessible presentation slides** in LaTeX that comply with **WCAG 2.1 Level AA** accessibility standards and ADA digital accessibility requirements.

**Author**: Richard Stanton, UC Berkeley  
**Repository**: https://github.com/rhstanton/accessible_LaTeX

## What is this?

This project provides a working template for migrating existing Beamer-based teaching materials to the new `ltx-talk` document class, which generates fully accessible PDF presentations. The template achieves a **100% accessibility score** from the bCourses (Canvas) Ally accessibility checker.

**📄 [View the example PDF](accessible.pdf)** to see the template output without compiling.

### About ltx-talk

`ltx-talk` is a presentation document class created by the [LaTeX Project team](https://latex3.github.io/tagging-project/) specifically for producing accessible slides with PDF tagging support. Key features:

- **Purpose-built for accessibility**: Designed from the ground up to generate tagged PDFs that meet WCAG 2.1 Level AA standards
- **Beamer-compatible syntax**: Uses familiar `\begin{frame}...\end{frame}` syntax to minimize migration effort
- **Part of the LaTeX Tagging Project**: Actively maintained and developed alongside the core LaTeX accessibility infrastructure
- **Automatic tagging**: Handles document structure, headings, lists, and other elements automatically
- **Included in modern TeX distributions**: Available in TeX Live 2023+ (no separate installation needed)

## Why does this exist?

As of April 2026, the updated requirements of the ADA mandate that digital course materials, including those in password-protected course sites, must comply with accessibility standards ([WCAG 2.1 Level AA](https://www.w3.org/WAI/standards-guidelines/wcag/)). 

**The problem**: Beamer is not **and never will be** compatible with these requirements.

**The solution**: The LaTeX community has developed a [Beamer replacement](https://latex3.github.io/tagging-project/) that:

- ✅ Generates accessible output
- ✅ Requires minimal modification to existing Beamer source
- ✅ Requires no manual processing of the resulting PDF file

## Features

This template demonstrates:

- **Accessible images** with alt text
- **Accessible tables** with properly tagged header rows
- **Accessible math** with MathML output
- **Accessible colors** with sufficient contrast
- **Proper document structure** with tagged headings
- **Accessible links** with underlines for visibility
- Working examples of text, figures, tables, and equations

## Quick Start

### Requirements

- **LaTeX Distribution**: TeX Live 2023 or later (TeX Live 2024 strongly recommended)
- **LaTeX Engine**: LuaLaTeX (strongly recommended - see below)
- **Fonts**: Lato and LeteSansMath.otf (optional - included in TeX Live 2023+)

**Note on fonts**: The font configuration in this template is **optional** and purely for visual consistency. The accessibility features work with any font. Lato and LeteSansMath.otf are included in TeX Live 2023+, so if you have a modern TeX distribution, they're already installed.

#### Why LuaLaTeX?

LuaLaTeX is **strongly recommended** for full accessibility features:

1. **Automatic MathML Generation**: LuaLaTeX can automatically generate MathML for equations through the built-in `luamml` package, making math accessible to screen readers without any extra work.

2. **PDF Tagging Support**: While the LaTeX tagging project now supports both pdfLaTeX and LuaLaTeX, LuaLaTeX provides the most complete and automatic accessibility support.

3. **Modern Font Support**: LuaLaTeX handles OpenType fonts (like Lato and LeteSansMath.otf) natively, essential for proper Unicode support and consistent rendering.

4. **Full UTF-8 Support**: Crucial for accessibility, especially for screen readers and international character sets.

**Note on pdfLaTeX**: While pdfLaTeX has partial support for PDF tagging, it requires manually providing MathML in separate files for equations, which is tedious and error-prone. For this reason, **this template requires LuaLaTeX**.

**XeLaTeX**: Does NOT support the tagging features and should not be used.

#### TeX Version Requirements

- **Minimum**: TeX Live 2023 (late 2023 release with updated packages)
  - If using TeX Live 2023, run `tlmgr update --all` to get the latest packages
- **Recommended**: TeX Live 2024 or later (includes latest accessibility improvements)
- **Will NOT work**: TeX Live 2022 or earlier

**Why these versions?** The accessibility features require:

- Modern LaTeX kernel with `\DocumentMetadata` support (added in 2023)
- Updated `tagpdf` package integrated into the kernel
- `ltx-talk` document class dependencies

If you're using an older TeX distribution, you **must upgrade** before using this template.

### Using this template

1. **Clone or download** this repository
2. **Copy** `accessible.tex` as a starting point for your slides
3. **Modify** the content, keeping the accessibility features intact
4. **Compile** with LuaLaTeX

### Compilation

**This template requires LuaLaTeX** for automatic MathML generation and full accessibility support.

Command line:
```bash
lualatex accessible.tex
```

Or configure your LaTeX editor:

- **TeXShop**: Select "LuaLaTeX" from the typeset menu
- **TeXworks**: Select "LuaLaTeX" from the dropdown
- **VS Code with LaTeX Workshop**: Add LuaLaTeX recipe (see extension docs)
- **Emacs/AUCTeX**: See local variables at end of .tex file
- **Overleaf**: Set compiler to "LuaLaTeX" in menu

## Key Accessibility Features

### 1. Document Metadata
Every document must start with:
```latex
\DocumentMetadata{
  pdfstandard=A-2u,
  lang=en-US,
  tagging=on
}
```

### 2. Images with Alt Text
```latex
\includegraphics[alt={Descriptive text here}]{imagefile}
```

### 3. Tables with Header Rows
```latex
% For a table with 1 header row:
\tagpdfsetup{table/header-rows={1}}

% For a table with 2 header rows:
\tagpdfsetup{table/header-rows={1,2}}

% For a table with 3 header rows:
\tagpdfsetup{table/header-rows={1,2,3}}

\begin{tabular}{ccc}
  % table content
\end{tabular}
```
**Note**: List ALL header row numbers. If your header spans 2 rows, you must use `{1,2}`, not just `{1}`.

### 4. Accessible Math
```latex
\tagpdfsetup{math/alt/use}
```

## Migrating from Beamer

The good news: **Most of your existing Beamer code works as-is!**

Key changes needed:

1. Update the document preamble (use this template's preamble)
2. Change document class from `beamer` to `ltx-talk`
3. Add `alt` text to all images
4. Add `table/header-rows` tags to tables
5. **Compile with LuaLaTeX** (strongly recommended for automatic MathML generation)

See [`accessible.tex`](accessible.tex) for a complete working example with inline code examples.

## Common Pitfalls

### Color Contrast

One of the most frequent accessibility failures involves insufficient color contrast. WCAG 2.1 Level AA requires:

- **Normal text**: Minimum contrast ratio of 4.5:1 against the background
- **Large text** (18pt+, or 14pt+ bold): Minimum contrast ratio of 3:1 against the background

**Common mistakes:**

- Using light colors on white backgrounds (e.g., `yellow`, `cyan`)
- Using bright red or green without darkening (standard `red` and `green` can be borderline)
- Relying solely on color to convey information (must also use text, symbols, or patterns)

**Solutions:**

- Use darker versions of problematic colors: `red!80!black`, `green!40!black`
- Standard `blue` is typically fine and meets WCAG requirements
- Test color combinations with a [contrast checker](https://webaim.org/resources/contrastchecker/)
- Always provide text labels or patterns in addition to color coding

**Example from this template:**
```latex
\definecolor{AccessibleRed}{named}{red!80!black}
\definecolor{AccessibleGreen}{named}{green!40!black}
```

This template includes pre-tested accessible colors that meet WCAG requirements.

## File Structure

- `accessible.tex` - Main template file with examples and extensive comments
- `accessible.pdf` - Pre-compiled example output (view without compiling)
- `capybara.jpg` - Sample image used in the template
- `.latexmkrc` - Configuration for latexmk build tool
- `build/` - Build artifacts (PDF, HTML with MathML)
- `auto/` - Auto-generated auxiliary files

## Resources

- [LaTeX Tagging Project](https://latex3.github.io/tagging-project/) - Official documentation
- [Detailed Usage Instructions](https://latex3.github.io/tagging-project/documentation/usage-instructions)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/standards-guidelines/wcag/)

## Testing Accessibility

To verify your slides meet accessibility requirements:

1. Upload your PDF to Canvas/bCourses
2. Check the Ally accessibility score (should be 100%)
3. Use a screen reader to test navigation
4. Verify PDF/A-2u compliance

## Troubleshooting

### Common Issues

**"Undefined control sequence \DocumentMetadata"**

- Your TeX distribution is too old (pre-2023)
- Solution: Upgrade to TeX Live 2023 or later, or run `tlmgr update --all`

**"Font not found" errors**

- If using TeX Live 2023+, fonts should be included
- Solution: The font configuration is optional - you can comment out or remove the `\setmainfont`, `\setsansfont`, and `\setmathfont` lines. Accessibility will still work fine.

**Compilation takes a long time**

- LuaLaTeX is slower than pdfLaTeX (this is normal)
- First compilation generates MathML files
- Subsequent compilations are faster

**"ltx-talk.cls not found"**

- Your TeX distribution doesn't include ltx-talk
- Solution: Upgrade to TeX Live 2023 or later

**Math doesn't render correctly**

- Make sure you're using LuaLaTeX, not pdfLaTeX or XeLaTeX
- Check that `\tagpdfsetup{math/alt/use}` is in your preamble

### Getting Help

- [LaTeX Tagging Project Issues](https://github.com/latex3/tagging-project/issues)
- [LaTeX Tagging Project Discussions](https://github.com/latex3/tagging-project/discussions)
- Email the template author: richard.stanton@berkeley.edu

## Frequently Asked Questions

**Q: Can I use pdfLaTeX instead of LuaLaTeX?**
A: Yes, but you'll need to manually create MathML files for every equation. LuaLaTeX does this automatically, saving significant time and effort.

**Q: Will my existing Beamer slides work with ltx-talk?**
A: Most Beamer code works with minimal changes. See the "Migrating from Beamer" section above.

**Q: Do I need to install any packages?**
A: No. If you have TeX Live 2023+, everything you need is already included.

**Q: Can I use my own fonts?**
A: Yes! The font configuration is optional. Just remove or modify the `\setmainfont`, `\setsansfont`, and `\setmathfont` commands in the preamble.

**Q: Does this work on Overleaf?**
A: Yes! Just set your compiler to LuaLaTeX in the Overleaf menu.

**Q: How do I check my TeX Live version?**
A: Run `tlmgr --version` in your terminal.

**Q: What if my accessibility score isn't 100%?**
A: Check that all images have `alt` text, all tables have `table/header-rows` specified, and you're compiling with LuaLaTeX.

## Questions or Suggestions?

**Author**: Richard Stanton, UC Berkeley  
**Contact**: [richard.stanton@berkeley.edu](mailto:richard.stanton@berkeley.edu)  
**Repository**: https://github.com/rhstanton/accessible_LaTeX

## License

This template is released into the **public domain** under the [CC0 1.0 Universal (CC0 1.0) Public Domain Dedication](https://creativecommons.org/publicdomain/zero/1.0/).

You are free to:

- Use this template for any purpose (academic, commercial, personal)
- Modify and adapt it to your needs
- Distribute it to others
- Use it without attribution (though attribution is appreciated!)

**No restrictions. No warranty. Use freely.**
