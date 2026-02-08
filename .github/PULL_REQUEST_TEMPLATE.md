## Description

<!-- Provide a clear description of what this PR does -->



## Type of Change

<!-- Check all that apply -->

- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Documentation update
- [ ] Accessibility improvement
- [ ] Breaking change (fix or feature that would cause existing functionality to change)
- [ ] Beamer migration example/guide

## Checklist

<!-- All items must be checked before merging -->

### Compilation & Testing
- [ ] Compiles successfully with LuaLaTeX
- [ ] No compilation errors or warnings
- [ ] Tested on TeX Live 2023 or 2024
- [ ] Generated PDF opens without errors

### Accessibility Requirements
- [ ] All images have meaningful alt text (not just "image" or "figure")
- [ ] All tables have `\tagpdfsetup{table/header-rows={...}}` specified
- [ ] Colors meet WCAG 2.1 contrast requirements (4.5:1 for text, 3:1 for large text)
- [ ] PDF maintains PDF/A-2u compliance
- [ ] Tested accessibility score (if possible): ____%

### Code Quality
- [ ] Code includes educational comments explaining *why* accessibility features are needed
- [ ] Examples show clear migration path from Beamer (if applicable)
- [ ] Code is clear and simple (teaching template - prioritize clarity)
- [ ] No unnecessary complexity or dependencies added

### Documentation
- [ ] README.md updated (if needed)
- [ ] Inline comments added to explain new features
- [ ] Examples demonstrate best practices

## Related Issues

<!-- Link any related issues here using #issue_number -->

Fixes #
Relates to #

## Screenshots or Examples

<!-- If applicable, add screenshots or example output -->



## Testing Checklist

<!-- Describe how you tested this -->

**Compilation Command:**
```bash
lualatex accessible.tex
```

**Environment:**

- OS: 
- TeX Live Version: 
- LaTeX Engine: LuaLaTeX

**Accessibility Testing:**

- [ ] Checked with Canvas/bCourses Ally (if available)
- [ ] Verified with PDF accessibility checker
- [ ] Tested with screen reader (specify which one): 
- [ ] Keyboard-only navigation works
- [ ] N/A - not applicable to this change

## Additional Notes

<!-- Any additional information reviewers should know -->


