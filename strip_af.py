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

    • the PDF passes veraPDF PDF/A validation
    • accessibility tagging (used by tools like Blackboard Ally)
      remains intact
    • no manual editing of the LaTeX tagging internals is required

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

5. Embedded file streams
       /Type /EmbeddedFile objects

After removal, the PDF is rewritten cleanly so that cross-reference
tables remain valid.


Dependencies
------------
This script requires the Python package:

    pikepdf

Install it with:

    pip install pikepdf

`pikepdf` is a lightweight wrapper around the QPDF library and is
commonly used for safe structural edits to PDFs.


Usage
-----
Basic usage (in-place overwrite):

    python strip_af.py input.pdf

Alternatively specify an explicit output filename:

    python strip_af.py input.pdf output.pdf


Typical LaTeX workflow
----------------------

Compile the document:

    lualatex accessible_slides.tex
    lualatex accessible_slides.tex

Then clean the PDF:

    python strip_af.py accessible_slides.pdf

Validate:

    veraPDF accessible_slides.pdf


Verification
------------
You can verify that no embedded files remain using:

    strings file.pdf | egrep 'EmbeddedFile|Filespec|AFRelationship|\\.html'

Expected output: nothing.


Notes
-----
This script exists as a **temporary workaround** for a mismatch between:

    • LaTeX accessibility tooling (which embeds helper files)
    • strict PDF/A archival requirements

If future LaTeX releases provide a configuration option to disable
these helper attachments directly, this script may become unnecessary.

For now it provides a safe and reproducible way to ensure PDF/A
compliance while keeping accessible tagging enabled.
"""

import os
import sys
import tempfile
import pikepdf


def strip_associated_files(input_pdf, output_pdf):
    with pikepdf.open(input_pdf) as pdf:
        root = pdf.Root

        # Remove document-level Associated Files
        if "/AF" in root:
            del root["/AF"]

        # Remove page-level Associated Files
        for page in pdf.pages:
            if "/AF" in page.obj:
                del page.obj["/AF"]

        # Remove EmbeddedFiles name tree (classic attachments)
        if "/Names" in root and "/EmbeddedFiles" in root.Names:
            del root.Names["/EmbeddedFiles"]
            if len(root.Names.keys()) == 0:
                del root["/Names"]

        # Clean remaining FileSpec objects
        for obj in pdf.objects:
            if isinstance(obj, pikepdf.Dictionary) and obj.get("/Type") == "/Filespec":
                if "/EF" in obj:
                    del obj["/EF"]
                if "/AFRelationship" in obj:
                    del obj["/AFRelationship"]

        if os.path.abspath(input_pdf) == os.path.abspath(output_pdf):
            temp_file = None
            try:
                with tempfile.NamedTemporaryFile(
                    suffix=".pdf", delete=False, dir=os.path.dirname(input_pdf) or "."
                ) as tmp:
                    temp_file = tmp.name
                pdf.save(temp_file, linearize=True)
                os.replace(temp_file, input_pdf)
            finally:
                if temp_file and os.path.exists(temp_file):
                    os.remove(temp_file)
        else:
            pdf.save(output_pdf, linearize=True)


def main():
    if len(sys.argv) < 2:
        print("Usage: strip_af.py input.pdf [output.pdf]")
        sys.exit(1)

    input_pdf = sys.argv[1]
    output_pdf = sys.argv[2] if len(sys.argv) > 2 else input_pdf

    strip_associated_files(input_pdf, output_pdf)

    print(f"Clean PDF written to: {output_pdf}")


if __name__ == "__main__":
    main()
