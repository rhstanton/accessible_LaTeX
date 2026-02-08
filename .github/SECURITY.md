# Security Policy

## Scope

This project is a LaTeX template for creating accessible presentation slides. As a template project that generates PDF files locally on your machine, it has a limited security scope.

## Reporting a Vulnerability

If you discover a security vulnerability in this template, please report it by:

1. **Email**: richard.stanton@berkeley.edu
2. **Subject line**: "Security Issue - Accessible LaTeX Template"
3. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Any suggested fixes (if applicable)

**Please do not** open a public GitHub issue for security vulnerabilities.

## What Constitutes a Security Issue?

For this project, security issues might include:

- **LaTeX code injection**: Code that could execute unintended commands during compilation
- **PDF generation issues**: Problems that could create malformed or malicious PDFs
- **Dependency vulnerabilities**: Issues in required packages that could affect users
- **File handling issues**: Problems with how the template processes external files (e.g., images)

## Response Timeline

- **Acknowledgment**: Within 3 business days
- **Assessment**: Within 7 days
- **Fix (if applicable)**: Depends on severity and complexity

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0     | :white_check_mark: |

## Security Best Practices

When using this template:

1. **Use trusted LaTeX distributions**: Install TeX Live from official sources
2. **Keep packages updated**: Run `tlmgr update --all` regularly
3. **Review external content**: Inspect any external .tex files or packages before including them
4. **Compile in safe environments**: Be cautious when compiling untrusted .tex files
5. **Check image sources**: Only include images from trusted sources

## Notes

This template generates PDFs locally on your machine and does not:

- Collect or transmit data
- Connect to external services
- Execute arbitrary code beyond standard LaTeX compilation
- Store credentials or sensitive information

The primary risk is in the LaTeX compilation process itself, which is standard for all LaTeX projects.
