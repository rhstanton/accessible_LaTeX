#!/usr/bin/env python3
"""
strip_af.py
===========

Remove Associated Files (AF) and embedded file attachments from a PDF.

Purpose
-------
Some recent LaTeX accessibility workflows (especially those using the
`latex-lab` tagging infrastructure and classes such as `ltx-talk`)
embed small helper files inside the generated PDF. Examples include:

    latex-list-css.html
    latex-align-css.html

These are attached using the PDF *Associated Files* mechanism
(`/AF`, `/Filespec`, `/EmbeddedFile` objects).

While these files are harmless and sometimes useful for experimental
HTML extraction workflows, they cause validation failures under
the PDF/A standard. In particular, veraPDF reports errors like:

    ISO 19005-2:2011, Clause 6.8, Test 5
    "File specification dictionary may contain EF key..."

In other words, **embedded files are not allowed in PDF/A-2U unless
they themselves are PDF/A compliant**, which these helper HTML files
are not.

This script removes those embedded file structures from the PDF so that:

    * the PDF passes veraPDF PDF/A validation
    * accessibility tagging (used by tools like Blackboard Ally)
      remains intact
    * no manual editing of the LaTeX tagging internals is required

Importantly, this script **does NOT remove any actual document content**.
It only removes metadata structures used to attach supplemental files.


What the script removes
-----------------------
The script cleans several PDF structures:

1. Document-level Associated Files
       Root /AF

2. Page-level Associated Files
       Page dictionaries containing /AF

3. Classic embedded attachments
       /Names -> /EmbeddedFiles name tree

4. File specification dictionaries
       /Type /Filespec objects with:
           /EF
           /AFRelationship


Dependencies
------------
This script requires the Python package `pikepdf`:

    pip install pikepdf


Usage
-----
    strip_af.py INPUT [OUTPUT]
    strip_af.py --help

If OUTPUT is omitted, INPUT is rewritten in place. If nothing needs
removing, the script exits without rewriting the PDF.


Notes
-----
This is a **temporary workaround** for a mismatch between LaTeX
accessibility tooling (which embeds helper files) and strict PDF/A
archival requirements. If future LaTeX releases provide a way to
suppress these helper attachments directly, this script may become
unnecessary.
"""

from __future__ import annotations

import argparse
import os
import sys
import tempfile

import pikepdf


def _strip(pdf: pikepdf.Pdf) -> dict[str, int]:
    """Strip associated files in place. Returns a counts dict."""
    counts = {
        "root_af": 0,
        "page_af": 0,
        "embeddedfiles_tree": 0,
        "filespec_ef": 0,
        "filespec_afrel": 0,
    }
    root = pdf.Root

    if "/AF" in root:
        del root["/AF"]
        counts["root_af"] = 1

    for page in pdf.pages:
        if "/AF" in page.obj:
            del page.obj["/AF"]
            counts["page_af"] += 1

    if "/Names" in root and "/EmbeddedFiles" in root.Names:
        del root.Names["/EmbeddedFiles"]
        counts["embeddedfiles_tree"] = 1
        if len(root.Names.keys()) == 0:
            del root["/Names"]

    for obj in pdf.objects:
        if isinstance(obj, pikepdf.Dictionary) and obj.get("/Type") == "/Filespec":
            if "/EF" in obj:
                del obj["/EF"]
                counts["filespec_ef"] += 1
            if "/AFRelationship" in obj:
                del obj["/AFRelationship"]
                counts["filespec_afrel"] += 1

    return counts


def _summary(counts: dict[str, int]) -> str:
    parts = []
    if counts["root_af"]:
        parts.append("root /AF")
    if counts["page_af"]:
        parts.append(f"{counts['page_af']} page /AF")
    if counts["embeddedfiles_tree"]:
        parts.append("/EmbeddedFiles tree")
    if counts["filespec_ef"]:
        parts.append(f"{counts['filespec_ef']} /Filespec /EF")
    if counts["filespec_afrel"]:
        parts.append(f"{counts['filespec_afrel']} /Filespec /AFRelationship")
    return ", ".join(parts) if parts else "nothing"


def strip_associated_files(input_pdf: str, output_pdf: str) -> bool:
    """Strip AF structures from input_pdf, write to output_pdf.

    Returns True if the PDF was rewritten, False if nothing needed
    stripping and the input was left untouched (in-place mode only).
    """
    in_place = os.path.abspath(input_pdf) == os.path.abspath(output_pdf)

    with pikepdf.open(input_pdf) as pdf:
        counts = _strip(pdf)
        total = sum(counts.values())
        summary = _summary(counts)

        if total == 0 and in_place:
            print(f"strip_af: {input_pdf}: nothing to strip; left untouched")
            return False

        if in_place:
            tmp = None
            try:
                with tempfile.NamedTemporaryFile(
                    suffix=".pdf",
                    delete=False,
                    dir=os.path.dirname(input_pdf) or ".",
                ) as fh:
                    tmp = fh.name
                pdf.save(tmp, linearize=True)
                os.replace(tmp, input_pdf)
            finally:
                if tmp and os.path.exists(tmp):
                    os.remove(tmp)
        else:
            pdf.save(output_pdf, linearize=True)

    print(f"strip_af: {output_pdf}: removed {summary}")
    return True


def main() -> int:
    p = argparse.ArgumentParser(
        prog="strip_af.py",
        description=(
            "Remove PDF Associated Files (/AF, /EmbeddedFile, /Filespec) "
            "to satisfy strict PDF/A validators. Document content is not "
            "touched."
        ),
    )
    p.add_argument("input", help="input PDF (rewritten in place if no output)")
    p.add_argument(
        "output",
        nargs="?",
        help="output PDF (defaults to overwriting the input)",
    )
    args = p.parse_args()

    output = args.output if args.output is not None else args.input
    strip_associated_files(args.input, output)
    return 0


if __name__ == "__main__":
    sys.exit(main())
