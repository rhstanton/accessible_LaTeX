# Contributing to Accessible LaTeX Slides Template

Thank you for your interest in improving this accessible LaTeX teaching template! This project helps instructors create presentation slides that meet WCAG 2.1 Level AA accessibility standards.

## How to Contribute

### Reporting Issues

When reporting issues, please include:

- **TeX Distribution**: Version of TeX Live you're using (`tlmgr --version`)
- **LaTeX Engine**: Which engine you used (LuaLaTeX, pdfLaTeX, XeLaTeX)
- **Operating System**: macOS, Windows, Linux
- **Description**: Clear description of the problem
- **Expected vs. Actual**: What you expected to happen vs. what actually happened
- **Minimal Example**: If possible, provide a minimal .tex file that reproduces the issue

### Suggesting Features

We welcome suggestions for:

- New accessibility features or examples
- Better documentation or explanations
- Migration patterns from Beamer to ltx-talk
- Additional teaching examples

Please check existing issues first to avoid duplicates.

### Submitting Changes

1. **Fork the repository** and create a new branch for your changes
2. **Test your changes** thoroughly:
   - Compile with LuaLaTeX
   - Verify 100% Ally accessibility score (if possible)
   - Check PDF/A-2u compliance
3. **Document your changes** with clear comments explaining *why* accessibility features are needed
4. **Submit a pull request** with a clear description

## Development Guidelines

### Accessibility Requirements

**All changes MUST maintain**:

- ✅ WCAG 2.1 Level AA compliance
- ✅ 100% Ally accessibility score
- ✅ PDF/A-2u standard compliance
- ✅ LuaLaTeX compilation

### Code Style

This is a **teaching template**. Code should:

1. **Be self-documenting**: Include clear examples showing correct usage
2. **Explain the "why"**: Comments should teach accessibility concepts, not just describe syntax
3. **Show migration paths**: When adding features, show how to migrate from Beamer
4. **Keep it simple**: Prioritize clarity over cleverness—others need to learn from this

### Specific Guidelines

#### Images
```latex
% ✅ REQUIRED: Always include alt text
\includegraphics[alt={Clear description of image content}]{file}

% ❌ WRONG: No alt text
\includegraphics{file}
```

#### Tables
```latex
% ✅ REQUIRED: Specify header rows
\tagpdfsetup{table/header-rows={1}}
\begin{tabular}{cc}
  Header 1 & Header 2 \\
  Data 1 & Data 2
\end{tabular}
```

#### Colors
All colors must maintain sufficient contrast:

- **Text on background**: Minimum 4.5:1 ratio
- **Large text (18pt+)**: Minimum 3:1 ratio
- Test with [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)

#### Comments
```latex
% ✅ GOOD: Explains why and teaches
% The 'alt' parameter makes images accessible to screen readers
% by providing a text description of the image content
\includegraphics[alt={A capybara sitting in grass}]{capybara.jpg}

% ❌ BAD: Just describes syntax
% Use alt parameter
\includegraphics[alt={A capybara}]{capybara.jpg}
```

### Testing Checklist

Before submitting a PR:

- [ ] Compiles successfully with LuaLaTeX
- [ ] No compilation errors or warnings
- [ ] All images have meaningful alt text (not just "image" or "figure")
- [ ] All tables have `table/header-rows` specified
- [ ] Colors meet WCAG contrast requirements
- [ ] Code includes educational comments
- [ ] Documentation updated if needed
- [ ] Tested on TeX Live 2023+ or 2024

### What to Avoid

- ❌ Removing accessibility features
- ❌ Adding dependencies on external packages without discussion
- ❌ Using pdfLaTeX or XeLaTeX compilation
- ❌ Images without alt text
- ❌ Tables without header specifications
- ❌ Breaking compatibility with TeX Live 2023+
- ❌ Complex solutions when simple ones exist
- ❌ Changes that reduce the template's educational value

## Questions?

If you have questions about contributing:

- **Open an issue** with the "question" label
- **Email the maintainer**: richard.stanton@berkeley.edu
- **Check existing issues** and pull requests

## Recognition

All contributors will be acknowledged in the project. Thank you for helping make educational materials more accessible!

## License

By contributing to this project, you agree that your contributions will be licensed under the same CC0 1.0 Universal (Public Domain) license as the project.
