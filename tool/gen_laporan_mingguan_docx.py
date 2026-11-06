# -*- coding: utf-8 -*-
"""Membuat DOCX laporan mingguan AlgoCraft 1.2.0 dari Markdown.

Jalankan:
    python tool/gen_laporan_mingguan_docx.py

Sumber : docs/laporan/laporan-mingguan-1.2.0.md
Hasil  : docs/laporan/Laporan_Mingguan_AlgoCraft_1.2.0.docx
"""
from __future__ import annotations

import os
import re
from pathlib import Path

from docx import Document
from docx.enum.section import WD_SECTION
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Cm, Pt, RGBColor

ROOT = Path(__file__).resolve().parent.parent
MD = ROOT / "docs" / "laporan" / "laporan-mingguan-1.2.0.md"
OUT = ROOT / "docs" / "laporan" / "Laporan_Mingguan_AlgoCraft_1.2.0.docx"
LOGO = ROOT / "assets" / "images" / "logo.png"

NAVY = RGBColor(0x1F, 0x38, 0x64)
GREY = RGBColor(0x55, 0x55, 0x55)
CODE_FILL = "F2F2F2"
HEADER_FILL = "D9E2F3"


def set_cell_shading(cell, fill: str) -> None:
    tc_pr = cell._tc.get_or_add_tcPr()
    shd = OxmlElement("w:shd")
    shd.set(qn("w:val"), "clear")
    shd.set(qn("w:color"), "auto")
    shd.set(qn("w:fill"), fill)
    tc_pr.append(shd)


def set_cell_margins(cell, top=60, bottom=60, left=90, right=90) -> None:
    tc = cell._tc
    tc_pr = tc.get_or_add_tcPr()
    tc_mar = tc_pr.first_child_found_in("w:tcMar")
    if tc_mar is None:
        tc_mar = OxmlElement("w:tcMar")
        tc_pr.append(tc_mar)
    for tag, value in (
        ("top", top), ("left", left), ("bottom", bottom), ("right", right)
    ):
        node = tc_mar.find(qn(f"w:{tag}"))
        if node is None:
            node = OxmlElement(f"w:{tag}")
            tc_mar.append(node)
        node.set(qn("w:w"), str(value))
        node.set(qn("w:type"), "dxa")


def add_page_number(paragraph) -> None:
    run = paragraph.add_run()
    fld = OxmlElement("w:fldChar")
    fld.set(qn("w:fldCharType"), "begin")
    instr = OxmlElement("w:instrText")
    instr.set(qn("xml:space"), "preserve")
    instr.text = " PAGE "
    fld2 = OxmlElement("w:fldChar")
    fld2.set(qn("w:fldCharType"), "end")
    run._r.append(fld)
    run._r.append(instr)
    run._r.append(fld2)
    run.font.name = "Times New Roman"
    run.font.size = Pt(9)
    run.font.color.rgb = GREY


def add_inline(paragraph, text: str, *, base_size=11.5, base_bold=False) -> None:
    """Menangani **bold**, `kode`, dan teks biasa."""
    text = text.replace("<br>", "\n")
    parts = re.split(r"(\*\*[^*]+\*\*|`[^`]+`)", text)
    for part in parts:
        if not part:
            continue
        if part.startswith("**") and part.endswith("**"):
            run = paragraph.add_run(part[2:-2])
            run.bold = True
        elif part.startswith("`") and part.endswith("`"):
            run = paragraph.add_run(part[1:-1])
            run.font.name = "Consolas"
            run.font.size = Pt(base_size - 1.2)
            run.font.color.rgb = RGBColor(0x1F, 0x3A, 0x5F)
        else:
            run = paragraph.add_run(part)
            if base_bold:
                run.bold = True
        if run.font.name is None:
            run.font.name = "Times New Roman"
        if run.font.size is None:
            run.font.size = Pt(base_size)
    # Line break di dalam sel/parent
    if "\n" in text:
        paragraph.paragraph_format.space_after = Pt(2)


def add_paragraph(doc, text: str, *, style=None, align=None, size=11.5,
                  bold=False, italic=False, color=None, space_after=6) -> None:
    par = doc.add_paragraph(style=style)
    add_inline(par, text, base_size=size, base_bold=bold)
    if align is not None:
        par.alignment = align
    if italic:
        for run in par.runs:
            run.italic = True
    if color is not None:
        for run in par.runs:
            run.font.color.rgb = color
    par.paragraph_format.space_after = Pt(space_after)
    par.paragraph_format.line_spacing = 1.15


def add_bullet(doc, text: str, numbered=False) -> None:
    style = "List Number" if numbered else "List Bullet"
    par = doc.add_paragraph(style=style)
    add_inline(par, text)
    par.paragraph_format.space_after = Pt(3)
    par.paragraph_format.line_spacing = 1.1


def add_code_block(doc, lines: list[str]) -> None:
    table = doc.add_table(rows=1, cols=1)
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    cell = table.cell(0, 0)
    set_cell_shading(cell, CODE_FILL)
    set_cell_margins(cell, 100, 100, 140, 140)
    cell.text = ""
    for idx, line in enumerate(lines):
        par = cell.paragraphs[0] if idx == 0 else cell.add_paragraph()
        run = par.add_run(line)
        run.font.name = "Consolas"
        run.font.size = Pt(8.2)
        run.font.color.rgb = RGBColor(0x22, 0x22, 0x22)
        par.paragraph_format.space_after = Pt(0)
        par.paragraph_format.space_before = Pt(0)
        par.paragraph_format.line_spacing = 1.0
    doc.add_paragraph().paragraph_format.space_after = Pt(2)


def _image_width(name: str) -> Cm:
    if "tema-papan" in name or "animasi" in name:
        return Cm(16.2)
    if "pose-robot" in name:
        return Cm(14.0)
    return Cm(7.2)


def add_image(doc, path: Path, alt: str, width: Cm | None = None,
              center=True) -> None:
    if not path.exists():
        add_paragraph(doc, f"[Gambar tidak ditemukan: {path.name}]", italic=True,
                      color=RGBColor(0xB0, 0x00, 0x00))
        return
    par = doc.add_paragraph()
    if center:
        par.alignment = WD_ALIGN_PARAGRAPH.CENTER
    par.add_run().add_picture(str(path), width=width or _image_width(path.name))
    par.paragraph_format.space_before = Pt(4)
    par.paragraph_format.space_after = Pt(2)


IMAGE_RE = re.compile(r"!\[([^\]]*)\]\(([^)]+)\)")


def add_table(doc, rows: list[list[str]]) -> None:
    if not rows:
        return
    cols = max(len(r) for r in rows)
    table = doc.add_table(rows=len(rows), cols=cols)
    table.style = "Table Grid"
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    table.autofit = True
    for r, row in enumerate(rows):
        for c in range(cols):
            cell = table.cell(r, c)
            set_cell_margins(cell)
            text = row[c] if c < len(row) else ""
            cell.text = ""
            par = cell.paragraphs[0]
            par.paragraph_format.space_after = Pt(0)
            par.paragraph_format.line_spacing = 1.0
            img = IMAGE_RE.fullmatch(text.strip())
            if img:
                alt, rel = img.group(1), img.group(2)
                # Tambahkan gambar langsung ke paragraf sel.
                run = par.add_run()
                run.add_picture(str(ROOT / "docs" / "laporan" / rel),
                                width=Cm(6.4))
                par.alignment = WD_ALIGN_PARAGRAPH.CENTER
            else:
                add_inline(par, text, base_size=9.0, base_bold=(r == 0))
                if r == 0:
                    for run in par.runs:
                        run.bold = True
                        run.font.color.rgb = NAVY
            if r == 0:
                set_cell_shading(cell, HEADER_FILL)
    # Beri ruang setelah tabel.
    doc.add_paragraph().paragraph_format.space_after = Pt(2)


def md_table(lines: list[str]) -> list[list[str]]:
    out = []
    for line in lines:
        stripped = line.strip().strip("|")
        cells = [c.strip() for c in stripped.split("|")]
        out.append(cells)
    # Buang baris pemisah (---|---)
    if len(out) >= 2 and all(re.fullmatch(r":?-{2,}:?", c) for c in out[1]):
        out = [out[0]] + out[2:]
    return out


def build() -> Path:
    text = MD.read_text(encoding="utf-8")
    body = text[text.index("## A. IDENTITAS"):]

    doc = Document()
    section = doc.sections[0]
    section.page_width = Cm(21.0)
    section.page_height = Cm(29.7)
    section.top_margin = Cm(2.2)
    section.bottom_margin = Cm(2.2)
    section.left_margin = Cm(2.4)
    section.right_margin = Cm(2.2)

    style = doc.styles["Normal"]
    style.font.name = "Times New Roman"
    style.font.size = Pt(11.5)
    style.element.rPr.rFonts.set(qn("w:eastAsia"), "Times New Roman")

    for name, size in (("Heading 1", 15), ("Heading 2", 12.5),
                       ("Heading 3", 11.5)):
        st = doc.styles[name]
        st.font.name = "Times New Roman"
        st.font.size = Pt(size)
        st.font.bold = True
        st.font.color.rgb = NAVY
        st.paragraph_format.space_before = Pt(10)
        st.paragraph_format.space_after = Pt(4)

    # ── Halaman judul ─────────────────────────────────────────
    sp = doc.add_paragraph()
    sp.alignment = WD_ALIGN_PARAGRAPH.CENTER
    sp.paragraph_format.space_before = Pt(24)
    r = sp.add_run("LAPORAN MINGGUAN\nPERKEMBANGAN PROYEK")
    r.bold = True
    r.font.name = "Times New Roman"
    r.font.size = Pt(20)
    r.font.color.rgb = NAVY

    sp = doc.add_paragraph()
    sp.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = sp.add_run("AlgoCraft Versi 1.2.0")
    r.bold = True
    r.font.name = "Times New Roman"
    r.font.size = Pt(16)
    sp = doc.add_paragraph()
    sp.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = sp.add_run("Aset Visual dan Animasi Robot Kodi serta Papan Permainan")
    r.italic = True
    r.font.name = "Times New Roman"
    r.font.size = Pt(12)

    if LOGO.exists():
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p.paragraph_format.space_before = Pt(18)
        p.add_run().add_picture(str(LOGO), width=Cm(5.2))

    for label, value in (
        ("Disusun oleh:", "Zainul Irfan"),
        ("NIM:", "2413025049"),
        ("Program Studi:", "Pendidikan Teknologi Informasi"),
        ("Kelas:", "2024A"),
        ("Fakultas:", "Fakultas Keguruan dan Ilmu Pendidikan"),
        ("Universitas:", "Universitas Lampung"),
        ("Tanggal:", "5 November 2026"),
    ):
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p.paragraph_format.space_after = Pt(0)
        r1 = p.add_run(label + " ")
        r1.font.name = "Times New Roman"
        r1.font.size = Pt(11)
        r2 = p.add_run(value)
        r2.font.name = "Times New Roman"
        r2.font.size = Pt(11)
        if label == "Disusun oleh:":
            r2.bold = True

    doc.add_page_break()

    # Header/footer
    section.different_first_page_header_footer = True
    hp = section.header.paragraphs[0]
    hp.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    hr = hp.add_run("AlgoCraft 1.2.0 \u00b7 Laporan Mingguan")
    hr.font.name = "Times New Roman"
    hr.font.size = Pt(8.5)
    hr.font.color.rgb = GREY
    fp = section.footer.paragraphs[0]
    fp.alignment = WD_ALIGN_PARAGRAPH.CENTER
    add_page_number(fp)

    # ── Isi laporan ───────────────────────────────────────────
    lines = body.splitlines()
    i = 0
    while i < len(lines):
        line = lines[i]
        s = line.strip()

        if not s or s == "---":
            i += 1
            continue

        # Tabel
        if s.startswith("|"):
            block = []
            while i < len(lines) and lines[i].strip().startswith("|"):
                block.append(lines[i])
                i += 1
            add_table(doc, md_table(block))
            continue

        # Blok kode
        if s.startswith("```"):
            code = []
            i += 1
            while i < len(lines) and not lines[i].strip().startswith("```"):
                code.append(lines[i])
                i += 1
            i += 1
            add_code_block(doc, code)
            continue

        # Gambar
        img = IMAGE_RE.fullmatch(s)
        if img:
            alt, rel = img.group(1), img.group(2)
            add_image(doc, ROOT / "docs" / "laporan" / rel, alt)
            i += 1
            continue

        # Judul
        if s.startswith("### "):
            doc.add_heading(s[4:], level=2)
            i += 1
            continue
        if s.startswith("## "):
            doc.add_heading(s[3:], level=1)
            i += 1
            continue
        if s.startswith("# "):
            doc.add_heading(s[2:], level=0)
            i += 1
            continue

        # Daftar
        m = re.match(r"^(\d+)\.\s+(.*)$", s)
        if m:
            add_bullet(doc, m.group(2), numbered=True)
            i += 1
            continue
        if s.startswith("- "):
            add_bullet(doc, s[2:])
            i += 1
            continue

        # Caption gambar
        if s.startswith("**Gambar "):
            add_paragraph(doc, s, align=WD_ALIGN_PARAGRAPH.CENTER, size=9.5,
                          italic=True, color=GREY, space_after=10)
            i += 1
            continue

        # Paragraf biasa
        add_paragraph(doc, s)
        i += 1

    props = doc.core_properties
    props.title = "Laporan Mingguan AlgoCraft 1.2.0"
    props.subject = "Aset Visual dan Animasi"
    props.author = "Zainul Irfan"
    props.keywords = "AlgoCraft, Flutter, animasi, robot Kodi, tema papan"

    OUT.parent.mkdir(parents=True, exist_ok=True)
    doc.save(OUT)
    print("Dibuat:", OUT)
    return OUT


if __name__ == "__main__":
    build()
