"""Render selected PDF pages to PNG and extract text for review."""
import os
import sys

import pymupdf

PDF = r"D:\game irfan\docs\laporan\preview_laporan.pdf"
OUT = r"D:\game irfan\docs\laporan\preview_pages"
os.makedirs(OUT, exist_ok=True)

doc = pymupdf.open(PDF)
print(f"Pages: {doc.page_count}")

# Print a compact text outline: first line(s) of each page
for i, page in enumerate(doc):
    text = page.get_text("text").strip().replace("\n", " | ")
    print(f"p{i+1:02d}: {text[:180]}")

# Render pages
targets = [int(x) for x in sys.argv[1:]] if len(sys.argv) > 1 else [1, 2, 3, 4, 5, 6, 7, 8]
for p in targets:
    if 1 <= p <= doc.page_count:
        page = doc[p - 1]
        pix = page.get_pixmap(dpi=110)
        path = os.path.join(OUT, f"page_{p:02d}.png")
        pix.save(path)
        print(f"rendered {path}")
