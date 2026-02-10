# Accessible LaTeX Templates (v1.1)

Templates for creating **accessible LaTeX documents** (both slides and articles) that comply with **WCAG 2.1 Level AA** accessibility standards and ADA digital accessibility requirements.

**Author**: Richard Stanton, UC Berkeley  
**Repository**: https://github.com/rhstanton/accessible_LaTeX

---

## Quick Summary (TL;DR)

**Making LaTeX accessible is straightforward.** Most requirements are the same for both slides and articles:

### Five Common Steps (Apply to Everything)

1. **Add `\DocumentMetadata`** before `\documentclass` (configures PDF tagging)
2. **Tag images**: `\includegraphics[alt={description}]{file}`
3. **Tag tables**: `\tagpdfsetup{table/header-rows={1}}` (or `{1,2}`, etc.)
4. **Use accessible colors**: Sufficient contrast (avoid light yellow/cyan)
5. **Compile with LuaLaTeX** (automatic MathML for equations)

### Plus One Class-Specific Step

- **For articles**: Nothing! Keep `\documentclass{article}` (or `report`, `book`, etc.)
- **For slides**: Change `\documentclass{beamer}` to `\documentclass[frame-title-arg]{ltx-talk}` **plus** recreate preamble styling (Beamer themes don't work—but this is one-time setup you reuse for all future talks)

### Requirements

- TeX Live 2023+ with LaTeX kernel 2025-11-01 (update via TeX Live Manager/Utility)
- Or use Overleaf Labs with Rolling TeXLive

**That's it!** See below for complete details, examples, and migration guides.

---

## What is this?

This project provides two complete templates demonstrating accessible LaTeX document creation using the LaTeX Tagging Project:

1. **`accessible_article.tex`** - Standard documents using the `article` class with accessibility features
2. **`accessible_slides.tex`** - Presentation slides using the `ltx-talk` class (Beamer replacement)

Both templates serve multiple purposes:

- **Working examples** - Complete documents with math, text, graphics, and tables you can copy and adapt
- **Documentation** - Heavily commented code explaining what you need to do and how each part works
- **Quick migration path** - Copy preambles and add accessibility tags to your existing LaTeX files
- **Guidance** - Best practices for creating accessible content

Both templates achieve a **100% accessibility score** from the bCourses (Canvas) Ally accessibility checker.

**📄 View example PDFs** in the repository to see the template outputs without compiling.

### The LaTeX Tagging Project: Common Foundation

Both templates use infrastructure from the [LaTeX Tagging Project](https://latex3.github.io/tagging-project/), which provides:

- **PDF/A-2u standard**: Archival-quality, accessible PDFs
- **Automatic tagging**: Document structure, headings, lists, etc.
- **MathML generation**: Makes math accessible to screen readers (via LuaLaTeX)
- **Consistent approach**: Same accessibility techniques work across document types
- **Requires LaTeX kernel 2025-11-01**: Update your TeX Live installation (see installation instructions below)

### For Articles: Your existing class + accessibility

For non-presentation documents, **continue using your existing document class** (`article`, `report`, `book`, etc.):

- **No class change needed**: Keep `\documentclass{article}` (or whatever you use)
- **Just add accessibility features**: DocumentMetadata, alt text, table tags
- **Works with standard classes**: The LaTeX Tagging Project integrates seamlessly

### For Slides: ltx-talk class

`ltx-talk` is a presentation document class created specifically for accessible slides:

- **Similar frame syntax**: Uses the familiar `\begin{frame}...\end{frame}` environment
- **Automatic slide tagging**: Handles presentation-specific structure
- **Requires manual styling**: Beamer themes don't work—recreate styling in preamble (one-time setup, then reuse)
- **Included in TeX Live 2023+**: No separate installation needed

## Getting This Repository

This section explains how to download and use these templates. Choose the method that works best for you.

### Method 1: Download ZIP (Easiest - No Git Required)

**Perfect for beginners or if you just want to try the templates:**

1. Click the green **"Code"** button at the top of this page
2. Select **"Download ZIP"**
3. Extract the ZIP file to a folder on your computer
4. Open the `.tex` files in your LaTeX editor (or Overleaf)

**Note**: This method gives you a one-time copy. To get updates later, you'll need to download the ZIP again.

### Method 2: Clone with Git (Recommended for Regular Use)

**Best if you want to easily get updates or contribute improvements:**

#### First-time setup:

1. **Install Git** (if you don't have it):
   - **Mac**: Git comes pre-installed. Open Terminal and type `git --version` to verify
   - **Windows**: Download from [git-scm.com](https://git-scm.com/download/win)
   - **Linux**: Use your package manager, e.g., `sudo apt install git`

2. **Clone the repository**:
   ```bash
   cd ~/Documents  # or wherever you want to store it
   git clone https://github.com/rhstanton/accessible_LaTeX.git
   cd accessible_LaTeX
   ```

#### Getting updates later:

When the templates are updated, just run:
```bash
cd ~/Documents/accessible_LaTeX  # navigate to your local copy
git pull
```

This downloads only the changes, keeping your local copy up to date.

### Method 3: Fork on GitHub (For Contributors)

**If you plan to customize extensively or contribute back:**

1. Click the **"Fork"** button at the top-right of this page
2. This creates your own copy of the repository under your GitHub account
3. Clone your fork: `git clone https://github.com/YOUR-USERNAME/accessible_LaTeX.git`
4. Make changes, commit them, and push back to your fork
5. Submit a Pull Request if you want to contribute improvements

### Need Help?

- **GitHub Guides**: [https://guides.github.com/](https://guides.github.com/)
- **Git Basics**: [https://git-scm.com/doc](https://git-scm.com/doc)
- **Contact**: richard.stanton@berkeley.edu

## Why does this exist?

As of April 2026, the updated requirements of the ADA mandate that digital course materials, including those in password-protected course sites, must comply with accessibility standards ([WCAG 2.1 Level AA](https://www.w3.org/WAI/standards-guidelines/wcag/)). 

**The problem**: Standard LaTeX (including Beamer) does not automatically generate accessible PDFs that meet these requirements.

**The solution**: The LaTeX Tagging Project provides infrastructure for creating accessible PDFs. The good news:

✅ **Most requirements are the SAME** whether you're creating slides or articles  
✅ **The changes are minimal** and follow consistent patterns  
✅ **Your existing LaTeX skills transfer** - you're just adding accessibility features

### What's Common to Both Slides and Articles

Regardless of document type, you need to:

1. Add `\DocumentMetadata` before `\documentclass` (configures PDF tagging)
2. Tag figures with alt text: `alt={description}`
3. Tag table header rows: `\tagpdfsetup{table/header-rows={...}}`
4. Use accessible colors (sufficient contrast)
5. Compile with LuaLaTeX for automatic MathML generation

### What's Different by Document Type

**For articles**: Keep using your existing class (`article`, `report`, `book`)  
- No class change needed!  
- Just add the common requirements above

**For slides**: Use the new `ltx-talk` class instead of `beamer`  
- Same `frame` syntax as Beamer (easy migration!)  
- Handles slide-specific tagging automatically

## Features

Both templates demonstrate:

- **Accessible images** with alt text
- **Accessible tables** with properly tagged header rows
- **Accessible math** with MathML output
- **Accessible colors** with sufficient contrast
- **Proper document structure** with tagged headings
- **Accessible links** with underlines for visibility
- Working examples of text, figures, tables, and equations

Additional features by template:

**`accessible_article.tex`**:
- Standard article structure with sections and subsections
- Shows how minimal changes are needed for existing documents
- Demonstrates accessibility with familiar LaTeX workflow

**`accessible_slides.tex`**:
- Frame-based presentation structure (Beamer-compatible)
- Custom slide formatting and page numbering
- Example of numbered and unnumbered slides

## Quick Start

### Requirements

- **LaTeX Distribution**: TeX Live 2023 or later
- **LaTeX Engine**: LuaLaTeX (strongly recommended - see below)
- **Fonts**: Lato and LeteSansMath.otf (optional - included in TeX Live)

**Note on fonts**: The font configuration in this template is **optional** and purely for visual consistency. The accessibility features work with any font. Lato and LeteSansMath.otf are included in modern TeX distributions.

**✅ Overleaf Support**: You **can** use this template on Overleaf, but it requires special setup through the **Overleaf Labs program**. See the "Using Overleaf" section below for detailed instructions.

### Why LuaLaTeX?

LuaLaTeX is **strongly recommended** for full accessibility features:

1. **Automatic MathML Generation**: LuaLaTeX can automatically generate MathML for equations through the built-in `luamml` package, making math accessible to screen readers without any extra work.

2. **PDF Tagging Support**: While the LaTeX tagging project now supports both pdfLaTeX and LuaLaTeX, LuaLaTeX provides the most complete and automatic accessibility support.

3. **Modern Font Support**: LuaLaTeX handles OpenType fonts (like Lato and LeteSansMath.otf) natively, essential for proper Unicode support and consistent rendering.

4. **Full UTF-8 Support**: Crucial for accessibility, especially for screen readers and international character sets.

**Note on pdfLaTeX**: While pdfLaTeX has partial support for PDF tagging, it requires manually providing MathML in separate files for equations, which is tedious and error-prone. For this reason, **this template requires LuaLaTeX**.

**XeLaTeX**: Does NOT support the tagging features and should not be used.

### TeX Version Requirements

- **Minimum**: TeX Live 2023 or later **with updates applied**
  - **Critical**: Update all packages to get **LaTeX kernel 2025-11-01** (required by `ltx-talk`)
    - **Windows**: Use TeX Live Manager GUI from Start menu
    - **Mac**: Use TeX Live Utility app from Applications folder
    - **Command line**: `tlmgr update --all`
  - Without this kernel update, `ltx-talk` will not work
- **Will NOT work**: 
  - TeX Live 2022 or earlier

**Why these versions?** The accessibility features require:

- LaTeX kernel 2025-11-01 or later (required by `ltx-talk` class)
- Modern `\DocumentMetadata` support and tagging infrastructure
- Updated `tagpdf` package integrated into the kernel

If you're using an older TeX distribution, you **must upgrade** before using this template.

### Using Overleaf

**✅ You CAN use this template on Overleaf!** The `ltx-talk` class requires a very recent version of TeX Live, which is available through Overleaf's **Labs program** (not in the standard Overleaf environment).

#### Setup Steps:

1. **Join Overleaf Labs**: 
   - Visit the [Overleaf Labs participation page](https://www.overleaf.com/labs/participate)
   - Opt in to the Overleaf Labs program
   - Enable **"Rolling TeX Live releases"**

2. **Configure your project**:
   - In your project settings, change **TeX Live version** to **"Rolling TeXLive (labs)"** (at the bottom of the list)
   - Change your project's **Compiler** to **LuaLaTeX**

#### Additional Resources:

- [Overleaf TeX Live 2025 announcement](https://www.overleaf.com/blog/tex-live-2025-is-now-available)
- [Creating accessible PDFs in LaTeX on Overleaf](https://docs.overleaf.com/writing-and-editing/creating-accessible-pdfs)

### Installing TeX Live Locally

If you prefer to compile locally or don't want to use Overleaf:

**This template requires LuaLaTeX** for automatic MathML generation and full accessibility support.

Command line:
```bash
lualatex accessible_slides.tex
# or
lualatex accessible_article.tex
```

Or configure your LaTeX editor:

- **TeXShop**: Select "LuaLaTeX" from the typeset menu
- **TeXworks**: Select "LuaLaTeX" from the dropdown
- **VS Code with LaTeX Workshop**: Add LuaLaTeX recipe (see extension docs)
- **Emacs/AUCTeX**: See local variables at end of .tex files

## Key Accessibility Features

### Common to ALL Documents (Slides and Articles)

These requirements apply whether you're creating slides or articles:

#### 1. Document Metadata (REQUIRED - Goes FIRST)

Every document **must** start with this, **before** `\documentclass`:
```latex
\DocumentMetadata{
  pdfstandard=A-2u,    % PDF/A-2u (archival + Unicode)
  lang=en-US,          % Language for screen readers
  tagging=on           % Enable PDF tagging
}
```

#### 2. Images with Alt Text

Every image needs descriptive text:
```latex
\includegraphics[alt={Descriptive text here}]{imagefile}
```

#### 3. Tables with Header Rows

Tell screen readers which rows are headers:
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

#### 4. Accessible Math

Enable automatic MathML in your preamble:
```latex
\tagpdfsetup{math/alt/use}
```

#### 5. Accessible Colors

Use colors with sufficient contrast (WCAG 2.1 Level AA requires 4.5:1 for normal text):
```latex
\colorlet{AccessibleRed}{red!80!black}      % Darker red
\colorlet{AccessibleGreen}{green!40!black}  % Darker green
% Standard blue is fine as-is
```

### Class-Specific Features

#### For Articles Only

No additional tagging needed! Standard sectioning commands (`\section`, `\subsection`) are automatically tagged.

#### For Slides Only (ltx-talk)

```latex
% Tag frame titles as H2 headings
\tagpdfsetup{role / new-tag = frametitle / H2}
```

## Migrating Your Existing LaTeX Files

### Common Steps for ALL Documents

Whether migrating slides or articles, you need to:

1. **Add `\DocumentMetadata` block** at the very beginning (before `\documentclass`):
   ```latex
   \DocumentMetadata{
     pdfstandard=A-2u,
     lang=en-US,
     tagging=on
   }
   ```

2. **Add `\tagpdfsetup{math/alt/use}`** to your preamble (enables automatic MathML)

3. **Tag all images** with alt text:
   ```latex
   \includegraphics[alt={Description}]{file}
   ```

4. **Tag all table headers**:
   ```latex
   \tagpdfsetup{table/header-rows={1}}  % or {1,2}, {1,2,3}, etc.
   ```

5. **Switch to LuaLaTeX** for compilation (automatic MathML generation)

6. **Update font packages** (for LuaLaTeX compatibility):
   - Replace `fontenc` with `fontspec`
   - Replace traditional font packages with `unicode-math`

### Additional Steps for Articles

After completing the common steps above:

**That's it!** Keep your existing `\documentclass{article}` (or `report`, `book`, etc.).

No class change needed. No special article-specific configuration required.

See [`accessible_article.tex`](accessible_article.tex) for a complete working example.

### Additional Steps for Slides (Beamer → ltx-talk)

After completing the common steps above:

1. **Change the document class**:
   ```latex
   % Old:
   \documentclass{beamer}
   
   % New:
   \documentclass[frame-title-arg]{ltx-talk}
   ```

2. **Remove Beamer-specific commands** that won't work:
   - `\usetheme{}`, `\usecolortheme{}`, `\usefonttheme{}` (themes are not supported)
   - `\setbeamertemplate{}` commands (template system is different)
   - `\setbeamercolor{}`, `\setbeamerfont{}` (use standard LaTeX/xcolor commands instead)
   - Navigation symbols and footline customizations (ltx-talk uses different approach)

3. **Copy slide-specific configuration** from `accessible_slides.tex` preamble:
   - Frame title tagging as H2
   - Page numbering customization
   - Footer/header setup (uses standard LaTeX, not Beamer templates)
   - Color definitions using `\colorlet` or `\definecolor` (not `\setbeamercolor`)

4. **Keep your frame syntax** - the basic environment works the same:
   ```latex
   \begin{frame}{Title}
     % Your content here
   \end{frame}
   ```

5. **Recreate your visual styling** (one-time preamble setup):
   - Use standard LaTeX packages and commands for colors, fonts, and layout
   - See `accessible_slides.tex` for examples of styling without Beamer themes
   - Test incrementally as you migrate each feature
   - **Once working**: Save your preamble and reuse it for all future talks!

**Reality check**: While the frame environment is similar, ltx-talk is a different class with its own approach. Plan time to recreate your visual styling using standard LaTeX techniques rather than Beamer's theme system. **However**, this is mostly **one-time preamble work**—once you have a working setup, copy that preamble to all future presentations. Your slide content (frames) mostly works as-is.

See [`accessible_slides.tex`](accessible_slides.tex) for a complete working example.

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
\colorlet{AccessibleRed}{red!80!black}
\colorlet{AccessibleGreen}{green!40!black}
```

This template includes pre-tested accessible colors that meet WCAG requirements.

## File Structure

- `accessible_slides.tex` - Presentation slides template with examples and extensive comments
- `accessible_article.tex` - Article document template with examples and extensive comments
- `capybara.jpg` - Sample image used in both templates
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
- Solution: Upgrade to TeX Live 2023 or later and update all packages (use TeX Live Manager on Windows or TeX Live Utility on Mac)

**"Font not found" errors**

- If using a modern TeX distribution, fonts should be included
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
A: The basic frame structure (`\begin{frame}...\end{frame}`) is similar, but Beamer themes, color schemes, templates, and most setup commands won't work. You'll need to recreate your styling using standard LaTeX commands and packages. See the "Migrating from Beamer" section above for details.

**Q: Do I need to install any packages?**
A: No separate package installation needed, but you must have an up-to-date TeX Live installation (2023 or later) with LaTeX kernel 2025-11-01 required by `ltx-talk`. Update using TeX Live Manager (Windows) or TeX Live Utility (Mac).

**Q: Can I use my own fonts?**
A: Yes! The font configuration is optional. Just remove or modify the `\setmainfont`, `\setsansfont`, and `\setmathfont` commands in the preamble.

**Q: Does this work on Overleaf?**
A: **Yes!** You need to use Overleaf's **Labs program** with **Rolling TeX Live releases**. See the "Using Overleaf" section above for detailed setup instructions. Alternatively, you can compile locally - see installation instructions for [Windows](https://tug.org/texlive/) and [Mac](https://tug.org/mactex/).

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
