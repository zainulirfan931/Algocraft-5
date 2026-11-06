# -*- coding: utf-8 -*-
"""Generator LAPORAN PROYEK AKHIR AlgoCraft (satu dokumen Word).

Menggabungkan dua template dari folder "templet":
1. Format Laporan Mingguan-Mobile Programming  -> Lampiran 1
2. format Laporan MK mobile Programing         -> kerangka laporan utama

Jalankan: python tool/gen_laporan_akhir.py
Hasil  : C:/Users/USER/Downloads/Laporan_Proyek_Akhir_AlgoCraft_Zainul_Irfan.docx
"""
import os
import json
from docx import Document
from docx.shared import Pt, Cm, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_BREAK
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.enum.style import WD_STYLE_TYPE
from docx.enum.section import WD_SECTION
from docx.oxml.ns import qn
from docx.oxml import OxmlElement
from docx.enum.text import WD_LINE_SPACING

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
IMG = os.path.join(ROOT, "docs", "laporan", "img")
OUT = r"C:\Users\USER\Downloads\Laporan_Proyek_Akhir_AlgoCraft_Zainul_Irfan.docx"

NAVY = RGBColor(0x1F, 0x38, 0x64)
BLACK = RGBColor(0, 0, 0)
GREY = RGBColor(0x59, 0x59, 0x59)
HEADER_FILL = "D9E2F3"
CODE_FILL = "F2F2F2"

NAMA = "Zainul Irfan"
NIM = "2413025049"
PRODI = "Pendidikan Teknologi Informasi"
KELAS = "2024A"
FAKULTAS = "Fakultas Keguruan dan Ilmu Pendidikan"
UNIV = "Universitas Lampung"
TAHUN = "2026/2027"
KOTA_TANGGAL = "Bandar Lampung, 23 Oktober 2026"
DOSEN1 = "Dr. Afif Rahman Riyanda, S.Pd., M.Pd.T."
DOSEN2 = "Ghea Chandra Surawan, M.Pd."


# ============================================================
# PENGATURAN DASAR
# ============================================================
def set_run_font(run, name="Times New Roman", size=12, bold=None, italic=None, color=None):
    run.font.name = name
    run.font.size = Pt(size)
    if bold is not None:
        run.bold = bold
    if italic is not None:
        run.italic = italic
    if color is not None:
        run.font.color.rgb = color
    rpr = run._element.get_or_add_rPr()
    rfonts = rpr.get_or_add_rFonts()
    rfonts.set(qn("w:eastAsia"), name)
    rfonts.set(qn("w:cs"), name)


def set_style_font(style, name="Times New Roman", size=12, bold=False, italic=False, color=BLACK):
    style.font.name = name
    style.font.size = Pt(size)
    style.font.bold = bold
    style.font.italic = italic
    style.font.color.rgb = color
    rpr = style.element.get_or_add_rPr()
    rfonts = rpr.get_or_add_rFonts()
    rfonts.set(qn("w:ascii"), name)
    rfonts.set(qn("w:hAnsi"), name)
    rfonts.set(qn("w:eastAsia"), name)
    rfonts.set(qn("w:cs"), name)


def setup_styles(doc):
    # Normal
    normal = doc.styles["Normal"]
    set_style_font(normal, size=12)
    pf = normal.paragraph_format
    pf.line_spacing = 1.5
    pf.space_before = Pt(0)
    pf.space_after = Pt(0)
    pf.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY

    # Isi paragraf
    isi = doc.styles.add_style("Isi", WD_STYLE_TYPE.PARAGRAPH)
    isi.base_style = doc.styles["Normal"]
    set_style_font(isi, size=12)
    isi.paragraph_format.first_line_indent = Cm(1.27)
    isi.paragraph_format.line_spacing = 1.5
    isi.paragraph_format.space_after = Pt(6)
    isi.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY

    # Butir
    butir = doc.styles.add_style("Butir", WD_STYLE_TYPE.PARAGRAPH)
    butir.base_style = doc.styles["Normal"]
    set_style_font(butir, size=12)
    butir.paragraph_format.left_indent = Cm(1.27)
    butir.paragraph_format.first_line_indent = Cm(-0.63)
    butir.paragraph_format.line_spacing = 1.5
    butir.paragraph_format.space_after = Pt(3)
    butir.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY

    # Judul halaman depan
    depan = doc.styles.add_style("Judul Depan", WD_STYLE_TYPE.PARAGRAPH)
    depan.base_style = doc.styles["Normal"]
    set_style_font(depan, size=14, bold=True)
    depan.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
    depan.paragraph_format.space_before = Pt(0)
    depan.paragraph_format.space_after = Pt(18)
    depan.paragraph_format.line_spacing = 1.5
    depan.paragraph_format.keep_with_next = True

    # Caption gambar / tabel
    for nm in ("Caption Gambar", "Caption Tabel"):
        cap = doc.styles.add_style(nm, WD_STYLE_TYPE.PARAGRAPH)
        cap.base_style = doc.styles["Normal"]
        set_style_font(cap, size=10)
        cap.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
        cap.paragraph_format.first_line_indent = Cm(0)
        cap.paragraph_format.line_spacing = 1.0
        cap.paragraph_format.space_before = Pt(3)
        cap.paragraph_format.space_after = Pt(6)

    # Kode program
    kode = doc.styles.add_style("Kode", WD_STYLE_TYPE.PARAGRAPH)
    kode.base_style = doc.styles["Normal"]
    set_style_font(kode, name="Consolas", size=9)
    kode.paragraph_format.first_line_indent = Cm(0)
    kode.paragraph_format.left_indent = Cm(0.6)
    kode.paragraph_format.right_indent = Cm(0.3)
    kode.paragraph_format.line_spacing = 1.0
    kode.paragraph_format.space_before = Pt(0)
    kode.paragraph_format.space_after = Pt(0)
    kode.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.LEFT

    # Judul lampiran
    lamp = doc.styles.add_style("Lampiran Heading", WD_STYLE_TYPE.PARAGRAPH)
    lamp.base_style = doc.styles["Normal"]
    set_style_font(lamp, size=14, bold=True)
    lamp.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
    lamp.paragraph_format.space_before = Pt(0)
    lamp.paragraph_format.space_after = Pt(18)
    lamp.paragraph_format.line_spacing = 1.5
    lamp.paragraph_format.keep_with_next = True

    sub = doc.styles.add_style("Sub Lampiran", WD_STYLE_TYPE.PARAGRAPH)
    sub.base_style = doc.styles["Normal"]
    set_style_font(sub, size=12, bold=True)
    sub.paragraph_format.space_before = Pt(12)
    sub.paragraph_format.space_after = Pt(6)
    sub.paragraph_format.line_spacing = 1.5
    sub.paragraph_format.keep_with_next = True


def setup_page(section):
    section.page_width = Cm(21.0)
    section.page_height = Cm(29.7)
    section.top_margin = Cm(2.54)
    section.bottom_margin = Cm(2.54)
    section.left_margin = Cm(2.54)
    section.right_margin = Cm(2.54)
    section.header_distance = Cm(1.25)
    section.footer_distance = Cm(1.25)


def add_page_number(paragraph):
    paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run = paragraph.add_run()
    set_run_font(run, size=10)
    fld1 = OxmlElement("w:fldChar")
    fld1.set(qn("w:fldCharType"), "begin")
    instr = OxmlElement("w:instrText")
    instr.set(qn("xml:space"), "preserve")
    instr.text = " PAGE "
    fld2 = OxmlElement("w:fldChar")
    fld2.set(qn("w:fldCharType"), "separate")
    txt = OxmlElement("w:t")
    txt.text = "1"
    fld3 = OxmlElement("w:fldChar")
    fld3.set(qn("w:fldCharType"), "end")
    run._r.append(fld1)
    run._r.append(instr)
    run._r.append(fld2)
    run._r.append(txt)
    run._r.append(fld3)


def set_page_number_format(section, fmt="decimal", start=1):
    sectPr = section._sectPr
    pgNumType = sectPr.find(qn("w:pgNumType"))
    if pgNumType is None:
        pgNumType = OxmlElement("w:pgNumType")
        sectPr.append(pgNumType)
    pgNumType.set(qn("w:fmt"), fmt)
    pgNumType.set(qn("w:start"), str(start))


def add_field(paragraph, instr, placeholder="", size=10, bold=False):
    paragraph.alignment = WD_ALIGN_PARAGRAPH.LEFT
    runs = []
    for _ in range(5):
        runs.append(paragraph.add_run())
    for r in runs:
        set_run_font(r, size=size, bold=bold)
    fld1 = OxmlElement("w:fldChar")
    fld1.set(qn("w:fldCharType"), "begin")
    runs[0]._r.append(fld1)
    it = OxmlElement("w:instrText")
    it.set(qn("xml:space"), "preserve")
    it.text = instr
    runs[1]._r.append(it)
    fld2 = OxmlElement("w:fldChar")
    fld2.set(qn("w:fldCharType"), "separate")
    runs[2]._r.append(fld2)
    t = OxmlElement("w:t")
    t.text = placeholder
    runs[3]._r.append(t)
    fld3 = OxmlElement("w:fldChar")
    fld3.set(qn("w:fldCharType"), "end")
    runs[4]._r.append(fld3)


# ============================================================
# PARAGRAF, TABEL, GAMBAR, KODE
# ============================================================
def p(doc, text, style="Isi", align=None, space_after=None, italic=False, bold=False, size=None, keep_next=False):
    par = doc.add_paragraph(style=style)
    run = par.add_run(text)
    set_run_font(run, size=size if size else 12, bold=bold, italic=italic)
    if align is not None:
        par.alignment = align
    if space_after is not None:
        par.paragraph_format.space_after = Pt(space_after)
    if keep_next:
        par.paragraph_format.keep_with_next = True
    return par


def center_text(doc, text, size=12, bold=True, space_after=6, italic=False):
    par = doc.add_paragraph()
    par.alignment = WD_ALIGN_PARAGRAPH.CENTER
    par.paragraph_format.space_after = Pt(space_after)
    par.paragraph_format.line_spacing = 1.5
    run = par.add_run(text)
    set_run_font(run, size=size, bold=bold, italic=italic)
    return par


def h1(doc, text, new_page=True):
    par = doc.add_paragraph(style="Heading 1")
    par.paragraph_format.page_break_before = new_page
    par.paragraph_format.space_before = Pt(0)
    par.paragraph_format.space_after = Pt(18)
    par.paragraph_format.line_spacing = 1.5
    par.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
    par.paragraph_format.keep_with_next = True
    lines = text.split("\n")
    for i, line in enumerate(lines):
        run = par.add_run(line)
        set_run_font(run, size=14, bold=True, color=BLACK)
        if i < len(lines) - 1:
            run.add_break()
    return par


def h2(doc, text):
    par = doc.add_paragraph(style="Heading 2")
    par.paragraph_format.space_before = Pt(12)
    par.paragraph_format.space_after = Pt(6)
    par.paragraph_format.line_spacing = 1.5
    par.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.LEFT
    par.paragraph_format.keep_with_next = True
    run = par.add_run(text)
    set_run_font(run, size=12, bold=True, color=BLACK)
    return par


def h3(doc, text):
    par = doc.add_paragraph(style="Heading 3")
    par.paragraph_format.space_before = Pt(10)
    par.paragraph_format.space_after = Pt(4)
    par.paragraph_format.line_spacing = 1.5
    par.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.LEFT
    par.paragraph_format.keep_with_next = True
    run = par.add_run(text)
    set_run_font(run, size=12, bold=True, italic=True, color=BLACK)
    return par


def front_heading(doc, text):
    par = doc.add_paragraph(style="Judul Depan")
    run = par.add_run(text)
    set_run_font(run, size=14, bold=True)
    return par


def bullet(doc, text, size=12):
    par = doc.add_paragraph(style="Butir")
    if text.startswith("- "):
        text = "• " + text[2:]
    run = par.add_run(text)
    set_run_font(run, size=size)
    return par


def numbered(doc, text, num, size=12):
    par = doc.add_paragraph(style="Butir")
    run = par.add_run(f"{num}. {text}")
    set_run_font(run, size=size)
    return par


def shade_cell(cell, fill):
    tcPr = cell._tc.get_or_add_tcPr()
    shd = OxmlElement("w:shd")
    shd.set(qn("w:val"), "clear")
    shd.set(qn("w:color"), "auto")
    shd.set(qn("w:fill"), fill)
    tcPr.append(shd)


def set_cell_margins(table, top=60, bottom=60, left=90, right=90):
    tblPr = table._tbl.tblPr
    mar = OxmlElement("w:tblCellMar")
    for tag, val in (("top", top), ("left", left), ("bottom", bottom), ("right", right)):
        el = OxmlElement(f"w:{tag}")
        el.set(qn("w:w"), str(val))
        el.set(qn("w:type"), "dxa")
        mar.append(el)
    tblPr.append(mar)


def repeat_header(row):
    trPr = row._tr.get_or_add_trPr()
    el = OxmlElement("w:tblHeader")
    el.set(qn("w:val"), "true")
    trPr.append(el)


def no_split(row):
    trPr = row._tr.get_or_add_trPr()
    el = OxmlElement("w:cantSplit")
    el.set(qn("w:val"), "true")
    trPr.append(el)


def table(doc, headers, rows, widths, caption=None, font_size=10, header_font=None, align_center_cols=None):
    if caption:
        cp = doc.add_paragraph(style="Caption Tabel")
        cp.paragraph_format.keep_with_next = True
        run = cp.add_run(caption)
        set_run_font(run, size=10, bold=True)
    t = doc.add_table(rows=1, cols=len(headers))
    t.style = "Table Grid"
    t.alignment = WD_TABLE_ALIGNMENT.CENTER
    t.autofit = False
    set_cell_margins(t)
    hdr = t.rows[0]
    repeat_header(hdr)
    for i, text in enumerate(headers):
        cell = hdr.cells[i]
        cell.width = Cm(widths[i])
        cell.vertical_alignment = WD_ALIGN_VERTICAL.CENTER
        shade_cell(cell, HEADER_FILL)
        par = cell.paragraphs[0]
        par.alignment = WD_ALIGN_PARAGRAPH.CENTER
        par.paragraph_format.space_after = Pt(0)
        par.paragraph_format.line_spacing = 1.0
        run = par.add_run(str(text))
        set_run_font(run, size=header_font or font_size, bold=True)
    for row_data in rows:
        row = t.add_row()
        no_split(row)
        for i, val in enumerate(row_data):
            cell = row.cells[i]
            cell.width = Cm(widths[i])
            cell.vertical_alignment = WD_ALIGN_VERTICAL.CENTER
            par = cell.paragraphs[0]
            par.paragraph_format.space_after = Pt(0)
            par.paragraph_format.line_spacing = 1.0
            if align_center_cols and i in align_center_cols:
                par.alignment = WD_ALIGN_PARAGRAPH.CENTER
            run = par.add_run(str(val))
            set_run_font(run, size=font_size)
    # pastikan lebar kolom konsisten
    for i, w in enumerate(widths):
        t.columns[i].width = Cm(w)
    doc.add_paragraph().paragraph_format.space_after = Pt(0)
    return t


def figure(doc, filename, caption, width_cm=6.8):
    path = os.path.join(IMG, filename)
    par = doc.add_paragraph()
    par.alignment = WD_ALIGN_PARAGRAPH.CENTER
    par.paragraph_format.space_before = Pt(6)
    par.paragraph_format.space_after = Pt(0)
    par.paragraph_format.line_spacing = 1.0
    par.paragraph_format.keep_with_next = True
    run = par.add_run()
    run.add_picture(path, width=Cm(width_cm))
    cap = doc.add_paragraph(style="Caption Gambar")
    cap.paragraph_format.space_after = Pt(10)
    r = cap.add_run(caption)
    set_run_font(r, size=10, italic=True)
    return par


def diagram(doc, filename, caption, width_cm=14.5):
    figure(doc, filename, caption, width_cm=width_cm)


def code_block(doc, lines, size=9):
    for i, line in enumerate(lines):
        par = doc.add_paragraph(style="Kode")
        par.paragraph_format.space_after = Pt(0)
        pPr = par._p.get_or_add_pPr()
        shd = OxmlElement("w:shd")
        shd.set(qn("w:val"), "clear")
        shd.set(qn("w:color"), "auto")
        shd.set(qn("w:fill"), CODE_FILL)
        pPr.append(shd)
        run = par.add_run(line if line else " ")
        set_run_font(run, name="Consolas", size=size)
    doc.add_paragraph().paragraph_format.space_after = Pt(0)


# ============================================================
# BAGIAN AWAL
# ============================================================
def cover(doc):
    for _ in range(3):
        doc.add_paragraph()
    center_text(doc, "LAPORAN PROYEK AKHIR", size=16, space_after=6)
    center_text(doc, "MATA KULIAH MOBILE PROGRAMMING", size=16, space_after=18)
    center_text(doc, "ALGOCRAFT: GAME EDUKASI ALGORITMA", size=16, space_after=0)
    center_text(doc, "BERBASIS BLOK KODE", size=16, space_after=6)
    doc.add_paragraph()
    doc.add_paragraph()
    center_text(doc, "Disusun oleh:", size=14, space_after=6)
    center_text(doc, f"{NAMA} - {NIM}", size=12, bold=True, space_after=6)
    for _ in range(5):
        doc.add_paragraph()
    center_text(doc, "PENDIDIKAN TEKNOLOGI INFORMASI", size=14, space_after=6)
    center_text(doc, "FAKULTAS KEGURUAN DAN ILMU PENDIDIKAN", size=14, space_after=6)
    center_text(doc, "UNIVERSITAS LAMPUNG", size=14, space_after=6)
    center_text(doc, TAHUN, size=14, space_after=0)


def pengesahan(doc):
    front_heading(doc, "LEMBAR PENGESAHAN")
    p(doc, "Laporan Proyek Akhir Mata Kuliah Mobile Programming dengan judul:",
      align=WD_ALIGN_PARAGRAPH.CENTER, space_after=6)
    p(doc, "ALGOCRAFT: GAME EDUKASI ALGORITMA BERBASIS BLOK KODE",
      align=WD_ALIGN_PARAGRAPH.CENTER, bold=True, space_after=12)
    p(doc, "Disusun oleh:", align=WD_ALIGN_PARAGRAPH.LEFT, space_after=4)
    p(doc, f"Nama\t\t: {NAMA}", align=WD_ALIGN_PARAGRAPH.LEFT, space_after=2)
    p(doc, f"NIM\t\t: {NIM}", align=WD_ALIGN_PARAGRAPH.LEFT, space_after=2)
    p(doc, f"Program Studi\t: {PRODI}", align=WD_ALIGN_PARAGRAPH.LEFT, space_after=2)
    p(doc, f"Kelas\t\t: {KELAS}", align=WD_ALIGN_PARAGRAPH.LEFT, space_after=12)
    p(doc, "Telah diperiksa dan disetujui sebagai laporan proyek akhir Mata Kuliah "
            "Mobile Programming pada Program Studi Pendidikan Teknologi Informasi, "
            "Fakultas Keguruan dan Ilmu Pendidikan, Universitas Lampung.",
      align=WD_ALIGN_PARAGRAPH.CENTER, space_after=18)
    p(doc, KOTA_TANGGAL, align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=12)

    t = doc.add_table(rows=2, cols=2)
    t.style = "Table Grid"
    t.alignment = WD_TABLE_ALIGNMENT.CENTER
    t.autofit = False
    labels = [
        ("Dosen Pengampu 1", DOSEN1),
        ("Dosen Pengampu 2", DOSEN2),
    ]
    for i, (jab, nama) in enumerate(labels):
        cell = t.rows[0].cells[i]
        cell.width = Cm(7.9)
        par = cell.paragraphs[0]
        par.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = par.add_run(jab + "\n\n\n\n\n")
        set_run_font(r, size=12, bold=True)
        r2 = par.add_run(nama)
        set_run_font(r2, size=12, bold=True)
    for i in range(2):
        cell = t.rows[1].cells[i]
        cell.width = Cm(7.9)
        par = cell.paragraphs[0]
        par.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = par.add_run(("Penyusun" if i == 0 else "Mengetahui,\nKetua Program Studi") + "\n\n\n\n\n")
        set_run_font(r, size=12)
        r2 = par.add_run(f"{NAMA}\nNIM {NIM}" if i == 0 else "(...................................)")
        set_run_font(r2, size=12, bold=(i == 0))


def kata_pengantar(doc):
    front_heading(doc, "KATA PENGANTAR")
    p(doc, "Puji dan syukur penulis panjatkan ke hadirat Allah Swt. karena atas rahmat "
            "dan karunia-Nya laporan proyek akhir yang berjudul “AlgoCraft: Game Edukasi "
            "Algoritma Berbasis Blok Kode” ini dapat diselesaikan dengan baik. Laporan "
            "ini disusun sebagai salah satu bentuk pertanggungjawaban atas pelaksanaan "
            "proyek akhir Mata Kuliah Mobile Programming pada Program Studi Pendidikan "
            "Teknologi Informasi, Fakultas Keguruan dan Ilmu Pendidikan, Universitas Lampung.")
    p(doc, "AlgoCraft dikembangkan sebagai media pembelajaran algoritma yang mengajak "
            "pemain menyusun blok perintah untuk menggerakkan robot Kodi. Melalui tujuh "
            "level yang tersedia, pemain belajar memahami urutan instruksi, perulangan, "
            "serta operasi khusus seperti menebang pohon, mencukur domba, dan membangun "
            "dinding. Laporan ini memaparkan proses analisis, perancangan, implementasi, "
            "hingga pengujian aplikasi tersebut.")
    p(doc, "Pada kesempatan ini penulis menyampaikan terima kasih kepada Bapak/Ibu "
            "dosen pengampu Mata Kuliah Mobile Programming, yaitu Dr. Afif Rahman Riyanda, "
            "S.Pd., M.Pd.T. dan Ghea Chandra Surawan, M.Pd., yang telah memberikan arahan, "
            "bimbingan, serta masukan selama proses pengembangan. Ucapan terima kasih juga "
            "penulis sampaikan kepada keluarga, rekan mahasiswa, dan semua pihak yang telah "
            "membantu penyelesaian laporan ini.")
    p(doc, "Penulis menyadari bahwa laporan ini masih memiliki kekurangan, baik dari segi "
            "isi maupun penyajian. Oleh karena itu, kritik dan saran yang membangun sangat "
            "diharapkan. Semoga laporan ini bermanfaat bagi pembaca, khususnya bagi "
            "pengembangan media pembelajaran algoritma berbasis permainan.")
    p(doc, KOTA_TANGGAL, align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=6)
    p(doc, "Penyusun,", align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=48)
    p(doc, NAMA, align=WD_ALIGN_PARAGRAPH.RIGHT, bold=True, space_after=0)
    p(doc, f"NIM {NIM}", align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=0)


def abstrak(doc):
    front_heading(doc, "ABSTRAK")
    p(doc, "Pembelajaran algoritma sering dianggap sulit karena konsepnya abstrak dan "
            "kurang didukung media visual yang interaktif. Penelitian pengembangan ini "
            "bertujuan menghasilkan AlgoCraft, sebuah game edukasi berbasis blok kode "
            "untuk membantu pemain memahami urutan instruksi, perulangan, dan operasi "
            "dasar algoritma. Aplikasi dikembangkan menggunakan Flutter dan bahasa Dart "
            "dengan pendekatan pengembangan iteratif yang meliputi analisis kebutuhan, "
            "perancangan, implementasi, serta pengujian. AlgoCraft menghadirkan robot "
            "Kodi pada papan permainan bergaya voxel dan menyediakan tujuh level dengan "
            "tingkat kesulitan yang meningkat. Pemain menyusun blok perintah seperti "
            "gerak maju, belok, lompat, ulangi, tebang, cukur, dan bangun, kemudian "
            "menjalankannya untuk menyelesaikan misi. Sistem memberikan penilaian tiga "
            "bintang berdasarkan efisiensi jumlah blok, pengalaman (XP), koin, kunci "
            "level progresif, toko kostum, serta musik latar dan efek suara. Progres "
            "pemain disimpan secara lokal menggunakan SharedPreferences berbentuk JSON. "
            "Hasil pengujian menunjukkan bahwa seluruh level dapat diselesaikan, aturan "
            "menang dan penilaian bintang berjalan sesuai rancangan, progres serta "
            "kostum tersimpan setelah aplikasi ditutup, dan pengujian widget berhasil "
            "dilewati tanpa kegagalan. Dengan demikian, AlgoCraft layak digunakan sebagai "
            "media pendukung pembelajaran algoritma yang menyenangkan dan mudah diakses.")
    par = doc.add_paragraph(style="Isi")
    r1 = par.add_run("Kata kunci: ")
    set_run_font(r1, size=12, bold=True)
    r2 = par.add_run("AlgoCraft; game edukasi; algoritma; Flutter; blok kode")
    set_run_font(r2, size=12)


def daftar_isi(doc):
    front_heading(doc, "DAFTAR ISI")
    par = doc.add_paragraph()
    add_field(par, ' TOC \\o "1-3" \\h \\z \\u ',
              "Daftar isi akan diperbarui otomatis oleh Microsoft Word.", size=11)


def daftar_gambar(doc):
    front_heading(doc, "DAFTAR GAMBAR")
    par = doc.add_paragraph()
    add_field(par, ' TOC \\h \\z \\t "Caption Gambar,1" ',
              "Daftar gambar akan diperbarui otomatis oleh Microsoft Word.", size=11)


def daftar_tabel(doc):
    front_heading(doc, "DAFTAR TABEL")
    par = doc.add_paragraph()
    add_field(par, ' TOC \\h \\z \\t "Caption Tabel,1" ',
              "Daftar tabel akan diperbarui otomatis oleh Microsoft Word.", size=11)


def daftar_lampiran(doc):
    front_heading(doc, "DAFTAR LAMPIRAN")
    par = doc.add_paragraph()
    add_field(par, ' TOC \\h \\z \\t "Lampiran Heading,1" ',
              "Daftar lampiran akan diperbarui otomatis oleh Microsoft Word.", size=11)


# ============================================================
# BAB I
# ============================================================
def bab1(doc):
    h1(doc, "BAB I\nPENDAHULUAN")
    h2(doc, "1.1 Latar Belakang")
    p(doc, "Perkembangan teknologi informasi telah mengubah cara manusia belajar dan "
            "mengakses pengetahuan. Perangkat mobile seperti ponsel pintar dan tablet "
            "menjadi sarana yang akrab bagi pelajar, sehingga pembelajaran tidak lagi "
            "terbatas pada ruang kelas dan buku teks. Pemanfaatan aplikasi mobile untuk "
            "pembelajaran memungkinkan materi disajikan secara interaktif, ringkas, dan "
            "dapat diulang sesuai kebutuhan pengguna. Kondisi tersebut membuka peluang "
            "besar untuk menghadirkan media pembelajaran yang lebih menarik, terutama "
            "untuk materi yang selama ini dianggap sulit.")
    p(doc, "Salah satu materi yang sering dianggap sulit adalah algoritma. Algoritma "
            "melibatkan konsep abstrak seperti urutan langkah, percabangan, perulangan, "
            "dan penyelesaian masalah secara sistematis. Pembelajaran yang hanya "
            "mengandalkan penjelasan teks atau papan tulis sering kali membuat peserta "
            "didik kesulitan membayangkan bagaimana sebuah instruksi dijalankan. Padahal, "
            "kemampuan berpikir komputasional (computational thinking) yang meliputi "
            "dekomposisi, pengenalan pola, abstraksi, dan perancangan algoritma merupakan "
            "kompetensi penting pada abad ke-21 (Wing, 2006).")
    p(doc, "Pendekatan pembelajaran berbasis permainan dan pemrograman berbasis blok "
            "telah banyak digunakan untuk menjembatani konsep abstrak tersebut. Scratch, "
            "Code.org, dan Minecraft Education Edition menunjukkan bahwa pemrograman "
            "visual dapat membantu pemula memahami logika tanpa harus menghadapi "
            "kompleksitas sintaks bahasa pemrograman (Resnick et al., 2009). Namun, "
            "sebagian besar media tersebut menggunakan bahasa Inggris, memerlukan koneksi "
            "internet, atau belum sepenuhnya selaras dengan konteks pembelajaran di "
            "sekolah. Oleh karena itu, diperlukan alternatif media pembelajaran yang "
            "berbahasa Indonesia, ringan, dan dapat digunakan secara luring.")
    p(doc, "AlgoCraft dikembangkan sebagai jawaban atas kebutuhan tersebut. Aplikasi ini "
            "menghadirkan robot bernama Kodi pada papan permainan bergaya voxel yang "
            "terinspirasi dari permainan blok. Pemain menyusun balok perintah untuk "
            "menggerakkan Kodi menyelesaikan misi, mulai dari berjalan menuju kambing, "
            "menebang pohon, mencukur domba, hingga membangun dinding rumah. Melalui "
            "mekanisme tersebut, pemain tidak hanya menghafal konsep, tetapi juga melihat "
            "langsung akibat dari urutan instruksi yang disusunnya. Laporan ini "
            "mendokumentasikan proses analisis, perancangan, implementasi, dan pengujian "
            "aplikasi AlgoCraft sebagai proyek akhir Mata Kuliah Mobile Programming.")

    h2(doc, "1.2 Identifikasi Masalah")
    numbered(doc, "Materi algoritma bersifat abstrak sehingga sulit dipahami apabila hanya "
                  "disampaikan melalui teks dan penjelasan lisan.", 1)
    numbered(doc, "Media pembelajaran algoritma yang interaktif, berbahasa Indonesia, dan "
                  "dapat digunakan secara luring masih terbatas.", 2)
    numbered(doc, "Peserta didik membutuhkan umpan balik langsung agar dapat memahami "
                  "kesalahan urutan instruksi dan memperbaiki strategi penyelesaian masalah.", 3)
    numbered(doc, "Pengembangan aplikasi mobile memerlukan pemilihan teknologi yang tepat "
                  "agar dapat berjalan di berbagai platform dengan biaya pengembangan yang efisien.", 4)
    numbered(doc, "Diperlukan mekanisme penyimpanan progres yang sederhana agar pemain "
                  "dapat melanjutkan pembelajaran tanpa bergantung pada server.", 5)

    h2(doc, "1.3 Rumusan Masalah")
    numbered(doc, "Bagaimana merancang game edukasi AlgoCraft yang mampu menyajikan konsep "
                  "algoritma secara visual dan interaktif?", 1)
    numbered(doc, "Bagaimana mengimplementasikan mesin permainan berbasis blok perintah, "
                  "penilaian bintang, progres, toko kostum, dan audio menggunakan Flutter?", 2)
    numbered(doc, "Bagaimana hasil pengujian fungsional aplikasi AlgoCraft dalam "
                  "menyelesaikan seluruh level dan menyimpan progres pemain?", 3)

    h2(doc, "1.4 Tujuan Pengembangan Aplikasi")
    p(doc, "Pengembangan aplikasi ini memiliki tujuan sebagai berikut.")
    numbered(doc, "Menghasilkan game edukasi AlgoCraft yang membantu pemain memahami "
                  "urutan instruksi, perulangan, dan operasi dasar algoritma melalui "
                  "penyusunan blok perintah.", 1)
    numbered(doc, "Merancang tujuh level permainan yang progresif, mulai dari gerak maju "
                  "sederhana hingga membangun dinding dengan perulangan.", 2)
    numbered(doc, "Menerapkan sistem penilaian bintang, XP, koin, kunci level, toko "
                  "kostum, dan penyimpanan progres lokal dalam satu aplikasi.", 3)
    numbered(doc, "Menguji aplikasi secara fungsional dan otomatis untuk memastikan "
                  "seluruh fitur berjalan sesuai kebutuhan.", 4)

    h2(doc, "1.5 Manfaat Aplikasi")
    p(doc, "Manfaat pengembangan aplikasi AlgoCraft dapat ditinjau dari beberapa pihak "
            "sebagai berikut.")
    bullet(doc, "Bagi peserta didik, AlgoCraft menyediakan pengalaman belajar algoritma "
                "yang menyenangkan melalui permainan, tantangan bertingkat, dan umpan balik "
                "langsung sehingga konsep abstrak menjadi lebih mudah dibayangkan.")
    bullet(doc, "Bagi guru, aplikasi ini dapat digunakan sebagai media pendukung atau "
                "variasi kegiatan pembelajaran, khususnya pada materi dasar algoritma dan "
                "berpikir komputasional.")
    bullet(doc, "Bagi pengembang, proyek ini menjadi contoh penerapan Flutter untuk "
                "aplikasi permainan edukasi yang menggabungkan antarmuka, logika permainan, "
                "penyimpanan lokal, dan audio.")
    bullet(doc, "Bagi peneliti lain, laporan ini dapat menjadi rujukan awal untuk "
                "mengembangkan media pembelajaran serupa dengan fitur yang lebih lengkap.")

    h2(doc, "1.6 Batasan Masalah")
    p(doc, "Agar pembahasan terarah, pengembangan aplikasi dibatasi pada hal-hal berikut.")
    bullet(doc, "Aplikasi memuat tujuh level dengan tema Padang Rumput, Jalan Setapak, "
                "Hutan Cemara, Kandang Domba, dan Lahan Bangun.")
    bullet(doc, "Permainan dimainkan secara individu (single player) dan tidak menyediakan "
                "mode multipemain, leaderboard daring, atau akun pengguna.")
    bullet(doc, "Penyimpanan data menggunakan SharedPreferences pada perangkat, bukan "
                "basis data server, sehingga progres tidak tersinkronisasi antarperangkat.")
    bullet(doc, "Aplikasi berfokus pada algoritma dasar berbasis blok perintah dan belum "
                "mencakup konsep percabangan bersyarat (if), fungsi, atau struktur data.")
    bullet(doc, "Target platform utama adalah Flutter Web yang dijalankan di peramban "
                "Chrome, dengan dukungan kode untuk Android dan Windows.")
    bullet(doc, "Aset visual dan audio dibuat sederhana agar aplikasi tetap ringan dan "
                "dapat berjalan tanpa koneksi internet.")


# ============================================================
# BAB II
# ============================================================
def bab2(doc):
    h1(doc, "BAB II\nLANDASAN TEORI")
    h2(doc, "2.1 Konsep Mobile Programming")
    p(doc, "Mobile programming merupakan proses pengembangan perangkat lunak yang "
            "dirancang khusus untuk dijalankan pada perangkat bergerak seperti ponsel "
            "pintar dan tablet. Aplikasi mobile umumnya memanfaatkan antarmuka sentuh, "
            "sumber daya perangkat yang terbatas, serta pola navigasi yang ringkas. "
            "Dalam konteks pendidikan, aplikasi mobile dapat menjadi media pembelajaran "
            "yang mudah diakses kapan saja dan di mana saja, sehingga mendukung "
            "pembelajaran mandiri maupun penggunaan di dalam kelas.")
    p(doc, "Perkembangan mobile programming ditandai oleh hadirnya kerangka kerja "
            "lintas platform (cross-platform) yang memungkinkan satu basis kode "
            "digunakan pada beberapa sistem operasi. Flutter merupakan salah satu "
            "kerangka kerja tersebut. Flutter menggunakan bahasa Dart dan menyediakan "
            "kumpulan widget untuk membangun antarmuka, serta mesin rendering sendiri "
            "sehingga tampilan aplikasi relatif konsisten di berbagai platform "
            "(Flutter, 2026). Pendekatan ini sesuai untuk proyek AlgoCraft yang "
            "menargetkan web, Android, dan Windows dengan sumber daya pengembangan "
            "yang terbatas.")

    h2(doc, "2.2 Teknologi dan Bahasa Pemrograman")
    p(doc, "AlgoCraft dikembangkan menggunakan bahasa pemrograman Dart dan kerangka "
            "kerja Flutter. Dart adalah bahasa berorientasi objek yang mendukung "
            "pemrograman asinkron, tipe data statis, serta kompilasi ke JavaScript untuk "
            "platform web (Dart, 2026). Kemampuan tersebut dimanfaatkan untuk menangani "
            "animasi permainan, pembacaan aset, dan penyimpanan preferensi secara "
            "asinkron tanpa menghambat antarmuka.")
    p(doc, "Flutter dipilih karena beberapa alasan. Pertama, satu basis kode dapat "
            "dijalankan pada web, Android, dan Windows sehingga menghemat waktu "
            "pengembangan. Kedua, Flutter menyediakan sistem widget yang kaya dan "
            "mendukung penggambaran kustom melalui CustomPaint, yang digunakan untuk "
            "menggambar papan permainan bergaya voxel. Ketiga, ekosistem paket Flutter "
            "menyediakan solusi siap pakai untuk audio, penyimpanan lokal, dan aset "
            "vektor. Keempat, fitur hot reload mempercepat proses iterasi desain dan "
            "perbaikan logika permainan.")
    table(doc,
          ["Aspek", "Keterangan"],
          [
              ["Bahasa pemrograman", "Dart 3.13.4"],
              ["Kerangka kerja", "Flutter 3.47.5 (stable)"],
              ["Paradigma", "Berorientasi objek, widget-based, asinkron"],
              ["Target platform", "Web (Chrome), Android, Windows"],
              ["Rendering papan", "CustomPaint dan CustomPainter"],
              ["Penyimpanan lokal", "SharedPreferences (JSON)"],
          ],
          [4.5, 11.3],
          caption="Tabel 2.1 Karakteristik teknologi yang digunakan",
          font_size=10)

    h2(doc, "2.3 Framework dan Tools yang Digunakan")
    p(doc, "Selain Flutter dan Dart, pengembangan aplikasi memanfaatkan beberapa paket "
            "pendukung. Paket-paket tersebut dipilih berdasarkan kebutuhan fungsional "
            "dan kestabilannya pada platform yang ditargetkan.")
    table(doc,
          ["Tools / Paket", "Fungsi dalam Aplikasi"],
          [
              ["Flutter SDK", "Menyediakan kerangka kerja, widget, dan alat build aplikasi."],
              ["Dart SDK", "Bahasa pemrograman dan runtime untuk menjalankan kode."],
              ["flutter_svg", "Menampilkan aset vektor SVG, termasuk logo aplikasi."],
              ["audioplayers", "Memutar musik latar berulang dan efek suara satu kali."],
              ["shared_preferences", "Menyimpan progres, kostum, dan preferensi audio secara lokal."],
              ["Chrome", "Peramban target untuk menjalankan versi web aplikasi."],
              ["Android Studio / IntelliJ IDEA", "Editor dan alat pendukung pengembangan Flutter."],
              ["Git", "Mengelola versi kode dan riwayat perubahan proyek."],
          ],
          [4.8, 11.0],
          caption="Tabel 2.2 Framework dan tools yang digunakan",
          font_size=10)
    p(doc, "Penggunaan paket-paket tersebut menjaga ukuran aplikasi tetap wajar dan "
            "mengurangi kebutuhan menulis kode dari nol. Meskipun demikian, logika inti "
            "permainan tetap diimplementasikan secara mandiri agar mudah disesuaikan "
            "dengan kebutuhan pembelajaran.")

    h2(doc, "2.4 Database atau Layanan Backend")
    p(doc, "AlgoCraft tidak menggunakan basis data server atau layanan backend. Seluruh "
            "data permainan disimpan pada perangkat pemain melalui paket "
            "shared_preferences. Data tersebut mencakup bintang terbaik setiap level, "
            "XP, koin, daftar kostum yang dimiliki, kostum yang sedang dipakai, serta "
            "preferensi suara. Penyimpanan lokal dipilih karena aplikasi dirancang dapat "
            "berjalan luring, tidak memerlukan autentikasi, dan tidak mengumpulkan data "
            "pribadi pengguna.")
    p(doc, "Data diserialisasi menjadi satu objek JSON dengan kunci progress_v1. "
            "Preferensi audio disimpan terpisah pada kunci sound_on dan volume. Apabila "
            "penyimpanan tidak tersedia atau terjadi kesalahan, aplikasi tetap dapat "
            "berjalan dengan data di memori selama sesi berlangsung. Rancangan kunci "
            "penyimpanan ditunjukkan pada Tabel 2.3.")
    table(doc,
          ["Kunci", "Jenis Data", "Isi"],
          [
              ["progress_v1", "String JSON", "xp, coins, stars, owned, equipped"],
              ["sound_on", "Boolean", "Status musik dan efek suara aktif/tidak"],
              ["volume", "Double", "Tingkat volume 0.0–1.0"],
          ],
          [4.0, 3.5, 8.3],
          caption="Tabel 2.3 Kunci penyimpanan lokal aplikasi",
          font_size=10)

    h2(doc, "2.5 Teori Pendukung Sesuai Fitur Aplikasi")
    p(doc, "Pengembangan AlgoCraft didasari oleh beberapa teori pembelajaran dan "
            "perancangan media. Teori-teori tersebut menjadi acuan dalam menentukan "
            "mekanisme permainan, urutan level, dan bentuk umpan balik.")
    h3(doc, "2.5.1 Berpikir Komputasional")
    p(doc, "Berpikir komputasional adalah proses merumuskan masalah dan solusinya agar "
            "dapat dijalankan oleh komputer atau manusia. Wing (2006) menekankan bahwa "
            "kemampuan ini mencakup abstraksi, dekomposisi masalah, pengenalan pola, "
            "dan perancangan algoritma. AlgoCraft menerjemahkan konsep tersebut ke dalam "
            "tugas menyusun urutan blok untuk mencapai tujuan, sehingga pemain berlatih "
            "memecah masalah menjadi langkah-langkah kecil yang terurut.")
    h3(doc, "2.5.2 Pemrograman Berbasis Blok")
    p(doc, "Pemrograman berbasis blok menggantikan penulisan sintaks dengan penyusunan "
            "potongan perintah visual. Pendekatan ini menurunkan beban kognitif pemula "
            "karena fokus diarahkan pada logika urutan dan hubungan antarperintah. "
            "Resnick et al. (2009) menunjukkan bahwa lingkungan pemrograman visual "
            "seperti Scratch dapat meningkatkan keterlibatan dan kreativitas peserta "
            "didik. AlgoCraft mengadopsi gagasan tersebut melalui palet blok yang "
            "terbatas pada konsep yang sedang dipelajari pada setiap level.")
    h3(doc, "2.5.3 Gamifikasi")
    p(doc, "Gamifikasi adalah penerapan elemen permainan pada konteks nonpermainan untuk "
            "meningkatkan motivasi dan keterlibatan. Elemen yang umum digunakan antara "
            "lain poin, lencana, level, tantangan, dan umpan balik langsung (Kapp, 2012). "
            "AlgoCraft menggunakan bintang sebagai penanda kualitas penyelesaian, XP dan "
            "koin sebagai penghargaan, kunci level sebagai tantangan bertahap, serta "
            "toko kostum sebagai bentuk personalisasi yang mendorong pemain mengulang "
            "misi dengan lebih efisien.")
    h3(doc, "2.5.4 Pembelajaran Bertahap")
    p(doc, "Prinsip pembelajaran bertahap menekankan penyajian materi dari yang sederhana "
            "ke yang kompleks. Setiap level AlgoCraft memperkenalkan satu konsep baru, "
            "misalnya gerak maju pada level pertama, belok arah pada level kedua, "
            "perulangan pada level ketiga, dan kombinasi beberapa konsep pada level "
            "berikutnya. Pembatasan palet blok dan kapasitas program membantu pemain "
            "berfokus pada konsep yang sedang dilatih sebelum menghadapi tantangan yang "
            "lebih besar.")

    h2(doc, "2.6 Penelitian atau Aplikasi Terkait")
    p(doc, "Beberapa aplikasi dan penelitian terdahulu menjadi pembanding dalam "
            "pengembangan AlgoCraft. Perbandingan tersebut tidak dimaksudkan untuk "
            "menilai secara mutlak, tetapi untuk melihat posisi dan pembeda aplikasi "
            "yang dikembangkan.")
    table(doc,
          ["Aplikasi / Kajian", "Karakteristik", "Perbedaan dengan AlgoCraft"],
          [
              ["Scratch", "Pemrograman visual berbasis blok, berbahasa Inggris, daring.",
               "AlgoCraft berfokus pada tantangan misi algoritma dengan bahasa Indonesia dan dapat berjalan luring."],
              ["Code.org", "Kursus pemrograman bertingkat dengan latihan dan video.",
               "AlgoCraft berbentuk permainan petualangan dengan robot dan papan voxel."],
              ["Minecraft Education", "Lingkungan 3D luas untuk eksplorasi dan pemrograman.",
               "AlgoCraft lebih ringan, berfokus pada urutan blok, dan tidak membutuhkan perangkat berperforma tinggi."],
              ["Lightbot", "Puzzle pemrograman untuk menggerakkan robot.",
               "AlgoCraft menambahkan perulangan, tebang, cukur, bangun, ekonomi XP/koin, dan toko kostum."],
          ],
          [4.0, 5.8, 6.0],
          caption="Tabel 2.4 Perbandingan aplikasi pembelajaran algoritma",
          font_size=9.5)
    p(doc, "Berdasarkan perbandingan tersebut, AlgoCraft menempatkan diri sebagai media "
            "pembelajaran algoritma yang ringan, berbahasa Indonesia, dan menggabungkan "
            "puzzle blok perintah dengan elemen permainan seperti bintang, XP, koin, "
            "serta kustomisasi robot. Kombinasi tersebut diharapkan dapat meningkatkan "
            "motivasi pemain untuk mencoba kembali misi dan memperbaiki efisiensi "
            "program yang disusun.")


# ============================================================
# BAB III
# ============================================================
def bab3(doc):
    h1(doc, "BAB III\nANALISIS DAN PERANCANGAN SISTEM")
    h2(doc, "3.1 Analisis Permasalahan")
    p(doc, "Berdasarkan observasi terhadap proses pembelajaran algoritma, ditemukan "
            "beberapa kondisi yang menjadi dasar pengembangan aplikasi. Materi algoritma "
            "sering disampaikan secara teoretis sehingga peserta didik kesulitan melihat "
            "hubungan antara urutan instruksi dan hasil yang muncul. Ketika terjadi "
            "kesalahan, umpan balik yang diberikan belum tentu langsung dan spesifik. "
            "Akibatnya, peserta didik membutuhkan waktu lebih lama untuk memahami "
            "hubungan sebab-akibat dalam sebuah program.")
    p(doc, "Media pembelajaran yang ada juga memiliki keterbatasan. Sebagian aplikasi "
            "pemrograman visual menggunakan bahasa Inggris dan memerlukan koneksi "
            "internet, sedangkan perangkat di laboratorium sekolah tidak selalu "
            "mendukung. Di sisi lain, permainan komersial umumnya tidak dirancang untuk "
            "tujuan pembelajaran sehingga keterkaitannya dengan kurikulum kurang jelas. "
            "Oleh karena itu, diperlukan media yang menggabungkan tantangan permainan, "
            "materi algoritma dasar, dan kemudahan akses.")
    p(doc, "AlgoCraft dirancang sebagai solusi dengan tiga pendekatan. Pertama, konsep "
            "algoritma divisualisasikan melalui pergerakan robot pada papan permainan. "
            "Kedua, setiap level membatasi blok perintah agar pemain berfokus pada satu "
            "atau dua konsep. Ketiga, aplikasi memberikan umpan balik langsung berupa "
            "animasi, pesan status, serta hasil bintang setelah misi selesai. Pendekatan "
            "ini diharapkan mengurangi beban kognitif sekaligus menjaga keterlibatan "
            "pemain.")
    table(doc,
          ["Masalah", "Penyebab", "Solusi dalam AlgoCraft"],
          [
              ["Konsep algoritma sulit dibayangkan", "Penjelasan abstrak dan minim visualisasi",
               "Papan permainan dan animasi eksekusi blok"],
              ["Umpan balik pembelajaran lambat", "Koreksi dilakukan setelah tugas selesai",
               "Pesan status dan hasil misi langsung setelah program dijalankan"],
              ["Motivasi belajar menurun", "Tantangan monoton dan tidak ada penghargaan",
               "Bintang, XP, koin, kunci level, dan toko kostum"],
              ["Akses media terbatas", "Aplikasi berbayar, daring, atau berbahasa asing",
               "Flutter Web/Android yang ringan, berbahasa Indonesia, dan luring"],
          ],
          [4.2, 5.3, 6.3],
          caption="Tabel 3.1 Permasalahan dan solusi yang dirancang",
          font_size=9.5)

    h2(doc, "3.2 Analisis Kebutuhan Fungsional")
    p(doc, "Kebutuhan fungsional mendefinisikan layanan yang harus disediakan aplikasi. "
            "Kebutuhan disusun berdasarkan alur pemain, mulai dari membuka aplikasi, "
            "memilih level, menyusun program, hingga memperoleh hasil dan menyimpan "
            "progres.")
    table(doc,
          ["ID", "Kebutuhan Fungsional", "Deskripsi"],
          [
              ["F-01", "Menampilkan beranda", "Menampilkan sapaan, misi aktif, ringkasan progres, XP, koin, dan kontrol suara."],
              ["F-02", "Menampilkan peta level", "Menampilkan tujuh level beserta status kunci dan bintang yang diperoleh."],
              ["F-03", "Memilih dan membuka level", "Level terbuka secara progresif setelah level sebelumnya diselesaikan."],
              ["F-04", "Menyusun blok perintah", "Pemain menambahkan, menghapus, dan melihat pratinjau blok sesuai palet level."],
              ["F-05", "Menjalankan program", "Mesin mengeksekusi blok berurutan dengan animasi dan jeda."],
              ["F-06", "Menjalankan per langkah", "Pemain dapat mengeksekusi satu blok untuk mengamati perubahan."],
              ["F-07", "Mengatur ulang misi", "Mengosongkan program dan mengembalikan robot ke posisi awal."],
              ["F-08", "Memeriksa kondisi menang", "Mendeteksi tujuan, pohon, domba, atau area bangunan sesuai tipe level."],
              ["F-09", "Menilai bintang", "Memberikan tiga bintang bila jumlah blok tidak melebihi nilai par, dua bintang bila melebihi."],
              ["F-10", "Menyimpan progres", "Menyimpan bintang, XP, koin, kostum, dan preferensi audio secara lokal."],
              ["F-11", "Membeli dan memakai kostum", "Toko menyediakan 18 item dalam lima kategori dengan harga koin tertentu."],
              ["F-12", "Memutar audio", "Memutar musik latar dan efek suara dengan kontrol aktif/tidak serta volume."],
          ],
          [1.3, 4.3, 10.2],
          caption="Tabel 3.2 Kebutuhan fungsional aplikasi",
          font_size=9.5)

    h2(doc, "3.3 Analisis Kebutuhan Nonfungsional")
    p(doc, "Kebutuhan nonfungsional menekankan kualitas yang harus dimiliki aplikasi. "
            "Kebutuhan ini menjadi acuan dalam pemilihan teknologi dan cara implementasi.")
    table(doc,
          ["ID", "Aspek", "Kebutuhan"],
          [
              ["NF-01", "Kinerja", "Aplikasi merespons interaksi dengan cepat dan animasi berjalan lancar pada perangkat kelas menengah."],
              ["NF-02", "Kegunaan", "Antarmuka sederhana, teks berbahasa Indonesia, dan navigasi hanya menggunakan tiga tab utama."],
              ["NF-03", "Kompatibilitas", "Dapat berjalan pada Chrome, Android, dan Windows dari satu basis kode Flutter."],
              ["NF-04", "Keandalan", "Kegagalan memuat aset atau audio tidak menghentikan permainan; progres tetap dapat disimpan."],
              ["NF-05", "Keamanan dan privasi", "Tidak meminta data pribadi dan tidak mengirim data ke server."],
              ["NF-06", "Pemeliharaan", "Level dan blok perintah disimpan sebagai data terpisah agar mudah ditambah atau diubah."],
          ],
          [1.4, 3.3, 11.1],
          caption="Tabel 3.3 Kebutuhan nonfungsional aplikasi",
          font_size=9.5)

    h2(doc, "3.4 Use Case Diagram")
    p(doc, "Use case diagram menggambarkan interaksi antara aktor dan fungsi utama "
            "aplikasi. AlgoCraft memiliki satu aktor utama, yaitu pemain. Pemain dapat "
            "melihat beranda, membuka peta level, menyusun blok, menjalankan misi, "
            "membeli kostum, dan mengatur audio. Hubungan include digunakan pada proses "
            "menyusun blok dan menjalankan misi karena keduanya melibatkan mekanisme "
            "inti permainan.")
    diagram(doc, "diagram-use-case.png", "Gambar 3.1 Use case diagram aplikasi AlgoCraft", width_cm=14.0)
    table(doc,
          ["Aktor", "Use Case", "Penjelasan"],
          [
              ["Pemain", "Melihat beranda dan progres", "Melihat sapaan, misi aktif, jumlah bintang, XP, dan koin."],
              ["Pemain", "Membuka peta level", "Memilih level yang sudah terbuka dan melihat bintang terbaik."],
              ["Pemain", "Menyusun blok perintah", "Menambahkan atau menghapus blok dari palet ke area kode."],
              ["Pemain", "Menjalankan misi", "Menjalankan program, mengamati animasi, dan menerima umpan balik."],
              ["Pemain", "Membeli dan memakai kostum", "Membelanjakan koin untuk item dan memasangnya pada robot."],
              ["Pemain", "Mengatur audio", "Mengaktifkan atau mematikan suara serta mengatur volume."],
          ],
          [2.4, 5.2, 8.2],
          caption="Tabel 3.4 Aktor dan use case aplikasi",
          font_size=9.5)

    h2(doc, "3.5 Activity Diagram atau Alur Proses")
    p(doc, "Alur utama permainan dimulai saat pemain membuka aplikasi dan memilih level. "
            "Pemain kemudian menyusun blok perintah pada area kode. Setelah tombol "
            "Jalankan ditekan, mesin mengeksekusi blok satu per satu sambil memperbarui "
            "posisi robot, jumlah objek yang dikumpulkan, dan pesan status. Jika kondisi "
            "menang terpenuhi, sistem menghitung bintang, menyimpan progres, dan "
            "menampilkan layar hasil. Jika belum, pemain dapat mengatur ulang dan "
            "memperbaiki program.")
    diagram(doc, "diagram-aktivitas.png", "Gambar 3.2 Activity diagram alur permainan AlgoCraft", width_cm=8.2)
    p(doc, "Langkah rinci alur permainan adalah sebagai berikut.")
    numbered(doc, "Aplikasi memuat progres dan preferensi audio dari penyimpanan lokal.", 1)
    numbered(doc, "Pemain memilih level pada peta level; level yang belum memenuhi syarat "
                  "tetap terkunci.", 2)
    numbered(doc, "Pemain menyusun program dari palet blok yang tersedia sesuai kapasitas level.", 3)
    numbered(doc, "Mesin mengeksekusi blok, memeriksa halangan, dan memperbarui status.", 4)
    numbered(doc, "Sistem memeriksa kondisi menang berdasarkan tipe sasaran level.", 5)
    numbered(doc, "Jika menang, bintang dihitung, progres disimpan, dan layar hasil "
                  "ditampilkan; jika belum, pemain mengatur ulang program.", 6)

    h2(doc, "3.6 Perancangan Antarmuka (UI/UX)")
    p(doc, "Perancangan antarmuka AlgoCraft mengutamakan kesederhanaan dan konsistensi. "
            "Aplikasi menggunakan tema gelap kebiruan agar nyaman dilihat dan memberi "
            "kesan petualangan, dengan aksen cyan, oranye, dan hijau untuk menandai "
            "elemen penting. Navigasi utama ditempatkan pada bilah bawah dengan tiga "
            "tab, yaitu Beranda, Peta, dan Toko. Arena misi dibuka melalui navigasi "
            "terpisah agar pemain fokus pada penyusunan program.")
    p(doc, "Tata letak dibatasi pada lebar maksimum 430 piksel dan dibungkus SafeArea. "
            "Pembatasan ini membuat tampilan tetap rapi pada layar desktop yang lebar "
            "sekaligus nyaman pada ponsel. Setiap layar memiliki hierarki visual yang "
            "jelas: judul dan status di bagian atas, konten utama di tengah, serta "
            "tombol aksi di area yang mudah dijangkau. Teks penting menggunakan ukuran "
            "dan warna kontras, sedangkan ikon digunakan untuk mempercepat pengenalan "
            "fungsi.")
    table(doc,
          ["Layar", "Komponen Utama", "Fungsi"],
          [
              ["Beranda", "Header XP/koin, banner Kodi, kartu misi, progres belajar, kartu suara",
               "Memberi gambaran progres dan akses cepat ke misi."],
              ["Peta Level", "Daftar tujuh level, bintang, gembok, kartu misi aktif",
               "Memilih level dan melihat status penyelesaian."],
              ["Arena Misi", "Info level, papan voxel, kontrol, area kode, palet blok, tips",
               "Menyusun dan menjalankan program untuk menyelesaikan misi."],
              ["Hasil Misi", "Bintang, XP, koin, lokasi, tombol lanjut/ulang",
               "Menampilkan hasil dan memberi pilihan tindakan berikutnya."],
              ["Toko Kostum", "Kategori, pratinjau item, harga, tombol beli/pakai",
               "Membelanjakan koin dan menyesuaikan tampilan robot."],
          ],
          [3.2, 7.0, 5.6],
          caption="Tabel 3.5 Rancangan layar aplikasi",
          font_size=9.5)

    h2(doc, "3.7 Perancangan Database dan API")
    p(doc, "Aplikasi tidak menggunakan basis data relasional maupun API jaringan. Data "
            "permainan disimpan sebagai objek JSON pada SharedPreferences. Struktur ini "
            "dipilih karena sederhana, tidak memerlukan skema tabel, dan sesuai untuk "
            "data progres yang berukuran kecil. Meskipun demikian, data tetap "
            "diorganisasi agar mudah dibaca dan dikembangkan.")
    table(doc,
          ["Properti JSON", "Tipe", "Keterangan"],
          [
              ["xp", "Integer", "Total pengalaman pemain dari misi yang diselesaikan."],
              ["coins", "Integer", "Saldo koin untuk membeli kostum."],
              ["stars", "Object", "Pasangan nomor level dan bintang terbaik (1–3)."],
              ["owned", "Array", "Daftar id kostum yang sudah dibeli."],
              ["equipped", "Object", "Kostum aktif per kategori (baju, topi, sepatu, syal, sayap)."],
          ],
          [4.0, 3.0, 8.8],
          caption="Tabel 3.6 Struktur data progres pemain",
          font_size=9.5)
    code_block(doc, [
        '{',
        '  "xp": 420,',
        '  "coins": 48,',
        '  "stars": { "1": 3, "2": 3, "3": 2 },',
        '  "owned": ["baju_kaos", "topi_petualang"],',
        '  "equipped": { "baju": "baju_kaos", "topi": "topi_petualang" }',
        '}',
    ])
    p(doc, "API yang digunakan bersifat internal, yaitu antarmuka kelas GameProgress "
            "dan GameAudio. GameProgress menyediakan operasi init, starsOf, isUnlocked, "
            "recordWin, buyItem, equipItem, dan unequipItem. GameAudio menyediakan "
            "operasi init, playSfx, setSoundOn, dan setVolume. Pemisahan ini membuat "
            "logika penyimpanan tidak bercampur dengan kode antarmuka.")

    h2(doc, "3.8 Arsitektur Aplikasi")
    p(doc, "Arsitektur AlgoCraft dibagi menjadi empat lapisan: presentasi, logika "
            "permainan, layanan, serta platform dan penyimpanan. Pembagian ini bertujuan "
            "memisahkan tanggung jawab sehingga perubahan pada satu bagian tidak "
            "mengganggu bagian lain. Lapisan presentasi menangani tampilan dan interaksi, "
            "lapisan logika mengatur aturan permainan, lapisan layanan mengelola progres "
            "dan audio, sedangkan lapisan platform menyediakan penyimpanan serta aset.")
    diagram(doc, "diagram-arsitektur.png", "Gambar 3.3 Arsitektur aplikasi AlgoCraft", width_cm=15.0)
    table(doc,
          ["Modul / Berkas", "Tanggung Jawab"],
          [
              ["lib/main.dart", "Widget antarmuka, model level, daftar blok, mesin eksekusi, dan penggambaran papan."],
              ["lib/game_progress.dart", "Singleton progres: bintang, XP, koin, kostum, dan serialisasi JSON."],
              ["lib/game_audio.dart", "Singleton audio: musik latar, efek suara, status suara, dan volume."],
              ["assets/images", "Banner, logo, dan aset gambar pendukung."],
              ["assets/audio", "Berkas bgm.wav, click.wav, place.wav, win.wav, dan fail.wav."],
              ["test/widget_test.dart", "Pengujian widget untuk shell, level 6–7, dan penyimpanan progres."],
          ],
          [4.5, 11.3],
          caption="Tabel 3.7 Tanggung jawab modul aplikasi",
          font_size=9.5)


# ============================================================
# BAB IV
# ============================================================
def bab4(doc):
    h1(doc, "BAB IV\nIMPLEMENTASI DAN PENGUJIAN")
    h2(doc, "4.1 Lingkungan Pengembangan")
    p(doc, "Pengembangan dan pengujian aplikasi dilakukan pada lingkungan yang "
            "mendukung Flutter Web. Lingkungan tersebut terdiri atas perangkat keras, "
            "sistem operasi, alat pengembangan, dan paket pendukung. Spesifikasi utama "
            "yang digunakan ditunjukkan pada Tabel 4.1.")
    table(doc,
          ["Komponen", "Spesifikasi / Versi"],
          [
              ["Perangkat", "Laptop/PC dengan prosesor setara Intel Core i5, RAM 8 GB, dan penyimpanan SSD."],
              ["Sistem operasi", "Windows 11 (64-bit)."],
              ["Flutter SDK", "3.47.5 stable."],
              ["Dart SDK", "3.13.4."],
              ["Target pengujian", "Google Chrome (Flutter Web)."],
              ["Editor / IDE", "Android Studio / IntelliJ IDEA dengan plugin Flutter."],
              ["Manajemen versi", "Git."],
              ["Paket utama", "flutter_svg 2.0.10, audioplayers 6.8.1, shared_preferences 2.5.6."],
              ["Pengolah laporan", "Microsoft Word (format .docx)."],
          ],
          [5.0, 10.8],
          caption="Tabel 4.1 Lingkungan pengembangan aplikasi",
          font_size=9.5)

    h2(doc, "4.2 Implementasi Fitur Aplikasi")
    p(doc, "Implementasi aplikasi berpusat pada tiga berkas utama, yaitu main.dart, "
            "game_progress.dart, dan game_audio.dart. main.dart memuat antarmuka, data "
            "tujuh level, model blok perintah, serta mesin eksekusi. game_progress.dart "
            "menangani penyimpanan bintang, XP, koin, dan kostum. game_audio.dart "
            "menangani musik latar, efek suara, dan preferensi audio. Ringkasan "
            "implementasi fitur disajikan pada Tabel 4.2.")
    table(doc,
          ["Fitur", "Implementasi", "Berkas"],
          [
              ["Beranda dan navigasi", "MainShell dengan tiga halaman dan bilah navigasi bawah.", "main.dart"],
              ["Peta level", "LevelMapScreen membaca progres dan menampilkan gembok/bintang.", "main.dart"],
              ["Model level", "Kelas MissionLevel menyimpan sasaran, palet, kapasitas, dan hadiah.", "main.dart"],
              ["Blok perintah", "Kelas Cmd dan peta kCmds berisi 13 perintah.", "main.dart"],
              ["Mesin eksekusi", "Fungsi _move, _turn, _destroy, _shear, _place, dan _execRepeat.", "main.dart"],
              ["Penilaian bintang", "Getter _starsUsed membandingkan jumlah blok dengan parBlocks.", "main.dart"],
              ["Kondisi menang", "Fungsi _finish memeriksa goal, pohon, domba, atau dinding.", "main.dart"],
              ["Progres dan ekonomi", "Singleton GameProgress dengan JSON di SharedPreferences.", "game_progress.dart"],
              ["Toko kostum", "CustomizeScreen, CostumeItem, dan 18 item lima kategori.", "main.dart"],
              ["Audio", "Singleton GameAudio dengan BGM loop, SFX, dan preferensi.", "game_audio.dart"],
          ],
          [3.4, 9.4, 3.0],
          caption="Tabel 4.2 Implementasi fitur aplikasi",
          font_size=9.5)

    h3(doc, "4.2.1 Model Blok Perintah")
    p(doc, "Setiap perintah direpresentasikan oleh objek Cmd yang menyimpan id, label, "
            "subjudul, kode yang ditampilkan, ikon, dan warna. Daftar perintah disimpan "
            "dalam peta kCmds sehingga dapat diakses berdasarkan id. Pemetaan ini "
            "memudahkan penambahan perintah baru dan menjaga konsistensi tampilan antara "
            "palet, area kode, dan pratinjau teks.")
    code_block(doc, [
        'class Cmd {',
        '  final String id;',
        '  final String label;',
        '  final String sub;',
        '  final String code;',
        '  final IconData icon;',
        '  final Color color;',
        '  const Cmd(this.id, this.label, this.sub, this.code, this.icon, this.color);',
        '}',
        '',
        "const kCmds = <String, Cmd>{",
        "  'maju': Cmd('maju', 'Gerak Maju', 'langkah: 1', 'gerak_maju()', ...),",
        "  'kanan': Cmd('kanan', 'Belok Kanan', 'putaran: 90°', 'belok_kanan()', ...),",
        "  'ulang': Cmd('ulang', 'Ulangi', '2x lagi blok sebelumnya', 'ulangi_blok()', ...),",
        "  'destroy': Cmd('destroy', 'Tebang Pohon', 'damping pohon', 'destroy()', ...),",
        "  'place': Cmd('place', 'Letakkan Kayu', 'papan kayu', 'place(\"kayu\")', ...),",
        '};',
    ])
    p(doc, "Terdapat tiga belas perintah yang tersedia, yaitu gerak maju satu dan dua "
            "langkah, lompat, belok kanan, belok kiri, ulangi dua kali, ulangi tiga kali, "
            "ulangi empat kali, tebang pohon, cukur domba, letakkan kayu, letakkan batu, "
            "dan tunggu. Tidak semua perintah muncul pada setiap level. Palet dibatasi "
            "sesuai konsep yang dilatih agar pemain tidak memilih perintah yang belum "
            "relevan.")
    table(doc,
          ["Id Blok", "Label", "Kode", "Fungsi"],
          [
              ["maju / maju2", "Gerak Maju", "gerak_maju()", "Maju satu atau dua petak."],
              ["lompat", "Lompat", "lompat()", "Melewati batu tanpa mendarat di atasnya."],
              ["kanan / kiri", "Belok", "belok_kanan() / belok_kiri()", "Memutar arah 90 derajat."],
              ["ulang", "Ulangi", "ulangi_blok()", "Menjalankan blok sebelumnya dua kali."],
              ["ulang3 / ulang4", "Ulangi 3x / 4x", "ulangi_blok(3) / (4)", "Mengulang kelompok blok di atasnya."],
              ["destroy", "Tebang Pohon", "destroy()", "Menebang pohon di petak samping."],
              ["shear", "Cukur Domba", "shear()", "Mengambil wool domba di petak samping."],
              ["place / placeBatu", "Letakkan Papan", "place(\"kayu\") / place(\"batu\")", "Memasang papan pada area dinding."],
              ["tunggu", "Tunggu", "tunggu(1)", "Memberi jeda satu detik."],
          ],
          [3.4, 3.2, 4.4, 4.8],
          caption="Tabel 4.3 Daftar blok perintah",
          font_size=9.5)

    h3(doc, "4.2.2 Model Level dan Mesin Eksekusi")
    p(doc, "Level didefinisikan sebagai objek MissionLevel. Setiap level menyimpan nomor, "
            "judul, lokasi, tingkat kesulitan, teks misi, petunjuk, palet blok, kapasitas "
            "program, nilai par, ukuran papan, posisi awal robot, sasaran, serta objek "
            "seperti batu, semak, pohon, domba, dan area dinding. Dengan struktur ini, "
            "penambahan level baru cukup dilakukan dengan menambah data pada daftar "
            "kLevels tanpa mengubah mesin permainan.")
    code_block(doc, [
        'class MissionLevel {',
        '  final int number;',
        '  final String title, tabTitle, location, difficulty;',
        '  final String mission, hint, quickTip;',
        '  final List<String> palette;',
        '  final int capacity;   // maksimum blok dalam program',
        '  final int par;        // blok minimum untuk 3 bintang',
        '  final int boardSize;  // 4 atau 5 petak',
        '  final int startRow, startCol, startDir;',
        '  final int goalRow, goalCol;',
        '  final List<List<int>> rocks, bushes, trees, sheep, walls;',
        '  final List<String> tips;',
        '  final int reward;',
        '}',
    ])
    p(doc, "Mesin eksekusi membaca program dari atas ke bawah. Perintah gerak memeriksa "
            "batas papan dan halangan sebelum mengubah posisi. Batu, pohon yang belum "
            "ditebang, dan domba yang belum dicukur dianggap sebagai penghalang. Perintah "
            "lompat dapat melewati batu di tengah langkah, tetapi tidak boleh mendarat di "
            "atas batu. Perintah tebang dan cukur hanya berhasil apabila robot berada di "
            "petak samping objek sasaran.")
    p(doc, "Perulangan diimplementasikan melalui dua mekanisme. Blok ulang mengulang "
            "satu blok tepat sebelumnya sebanyak dua kali. Blok ulang3 dan ulang4 "
            "mengulang seluruh kelompok blok di atasnya, dimulai setelah blok pengulang "
            "sebelumnya. Mekanisme ini mencegah blok isi loop ikut dijalankan di alur "
            "utama. Contoh implementasinya ditunjukkan pada kutipan berikut.")
    code_block(doc, [
        'int _groupStart(int at) {',
        '  for (var i = at - 1; i >= 0; i--) {',
        '    if (_isRepeat(_program[i])) return i + 1;',
        '  }',
        '  return 0;',
        '}',
        '',
        'Future<bool> _execRepeat(int at) async {',
        '  final id = _program[at];',
        '  if (id == "ulang") {',
        '    final prev = _program[at - 1];',
        '    var ok = await _execCmd(prev);',
        '    if (ok) ok = await _execCmd(prev);',
        '    return ok;',
        '  }',
        '  final start = _groupStart(at);',
        '  final times = _repeatTimes(id);',
        '  for (var k = 0; k < times; k++) {',
        '    for (var i = start; i < at; i++) {',
        '      if (!await _execCmd(_program[i])) return false;',
        '    }',
        '  }',
        '  return true;',
        '}',
    ])
    p(doc, "Mode Langkah memungkinkan pemain menjalankan satu instruksi setiap kali "
            "tombol ditekan. Mode ini membantu pemain mengamati perubahan arah dan posisi "
            "robot, terutama pada level yang membutuhkan belokan dan perulangan. Selain "
            "itu, area pratinjau teks menampilkan program dalam bentuk kode sehingga "
            "pemain dapat melihat hubungan antara blok visual dan representasi tekstualnya.")

    h3(doc, "4.2.3 Kondisi Menang dan Penilaian Bintang")
    p(doc, "Kondisi menang disesuaikan dengan tipe sasaran level. Level biasa menang "
            "apabila robot berada pada petak tujuan. Level bertema pohon menang apabila "
            "seluruh pohon telah ditebang, level bertema domba menang apabila seluruh "
            "domba telah dicukur, dan level bertema bangunan menang apabila seluruh petak "
            "area dinding telah terpasang papan. Pemeriksaan dilakukan setelah program "
            "selesai dijalankan.")
    code_block(doc, [
        'final win = ok &&',
        '    (lv.hasBuild',
        '        ? _buildDone',
        '        : lv.hasSheep',
        '            ? _woolCount >= _woolTotal',
        '            : lv.hasTree',
        '                ? _woodCount >= _woodTotal',
        '                : (_row == lv.goalRow && _col == lv.goalCol));',
    ])
    p(doc, "Penilaian bintang menggunakan perbandingan antara jumlah blok yang dipakai "
            "dan nilai par level. Apabila jumlah blok tidak melebihi nilai par, pemain "
            "memperoleh tiga bintang. Apabila melebihi nilai par, pemain memperoleh dua "
            "bintang. Bintang terbaik dari seluruh percobaan disimpan sehingga percobaan "
            "ulang tidak menurunkan capaian sebelumnya. Aturan ini mendorong pemain "
            "mencari solusi yang lebih efisien, bukan sekadar menyelesaikan level.")
    code_block(doc, [
        'int get _starsUsed {',
        '  final used = _program.length;',
        '  if (used == 0) return 0;',
        '  return used <= lv.parBlocks ? 3 : 2;',
        '}',
    ])

    h3(doc, "4.2.4 Progres, Ekonomi, Toko, dan Audio")
    p(doc, "GameProgress adalah singleton yang menyimpan bintang per level, XP, koin, "
            "kostum yang dimiliki, dan kostum yang dipakai. Data disimpan sebagai JSON "
            "pada kunci progress_v1. Setiap perubahan data menaikkan nilai ValueNotifier "
            "changes sehingga widget seperti pil XP/koin, kartu progres, peta level, dan "
            "toko ikut diperbarui tanpa perlu memuat ulang halaman.")
    p(doc, "Kunci level bersifat progresif. Level pertama selalu terbuka, sedangkan level "
            "berikutnya terbuka apabila level sebelumnya telah diselesaikan dengan minimal "
            "satu bintang. Kemenangan dicatat melalui recordWin yang menyimpan bintang "
            "terbaik, menambah XP sesuai hadiah level, dan menambah koin sebesar sepersepuluh "
            "hadiah. Hadiah level berkisar antara 50 hingga 140 XP, sehingga koin yang "
            "diperoleh berkisar antara 5 hingga 14 koin per kemenangan.")
    p(doc, "Toko Kostum menyediakan 18 item dalam lima kategori, yaitu baju, topi, sepatu, "
            "syal, dan sayap. Harga item berkisar antara 60 hingga 460 koin. Pemain dapat "
            "membeli item apabila saldo mencukupi dan item belum dimiliki, kemudian "
            "memakainya atau melepasnya. Kepemilikan dan kostum aktif disimpan bersama "
            "progres sehingga tetap tersedia setelah aplikasi dibuka kembali.")
    p(doc, "GameAudio mengelola musik latar dan efek suara. Musik latar diputar secara "
            "berulang dengan volume yang lebih rendah daripada efek suara. Efek suara "
            "click, place, win, dan fail diputar pada momen yang sesuai. Status aktif dan "
            "volume disimpan pada SharedPreferences. Pada platform web, pemutaran musik "
            "dapat ditahan oleh kebijakan autoplay peramban; karena itu aplikasi mencoba "
            "melanjutkan musik pada interaksi pengguna berikutnya. Kegagalan memutar audio "
            "ditangkap agar tidak menghentikan permainan.")

    h2(doc, "4.3 Implementasi Antarmuka")
    p(doc, "Bagian ini menampilkan tangkapan layar antarmuka aplikasi yang dijalankan "
            "pada Chrome. Setiap gambar disertai penjelasan singkat mengenai fungsi dan "
            "elemen yang terlihat.")
    figure(doc, "01-beranda.png", "Gambar 4.1 Tampilan beranda AlgoCraft", width_cm=6.8)
    p(doc, "Beranda menampilkan banner Kodi, sapaan, misi aktif, kartu progres belajar, "
            "kartu komunitas, dan kontrol suara. Di bagian atas terdapat pil XP, energi, "
            "koin, tombol speaker, dan avatar yang mengarah ke toko kostum. Bilah navigasi "
            "bawah menghubungkan Beranda, Peta, dan Toko.")
    figure(doc, "02-peta-level.png", "Gambar 4.2 Peta level dan status kunci", width_cm=6.8)
    p(doc, "Peta level menampilkan tujuh level secara berurutan. Level yang belum "
            "terbuka ditandai dengan ikon gembok, sedangkan level yang sudah dimainkan "
            "menampilkan bintang terbaik. Jumlah bintang total ditampilkan di kanan atas.")
    figure(doc, "03-arena-misi.png", "Gambar 4.3 Arena misi dengan papan voxel dan area kode", width_cm=6.8)
    p(doc, "Arena misi memuat informasi level, papan permainan bergaya voxel, tombol "
            "kontrol, area kode, palet blok, dan tips. Papan menampilkan robot, batu, "
            "pohon, domba, atau area dinding sesuai level. Palet blok di bawah area kode "
            "menjadi tempat pemain menambahkan perintah.")
    figure(doc, "03b-arena-palet.png", "Gambar 4.4 Palet blok perintah pada arena misi", width_cm=6.8)
    p(doc, "Palet blok menampilkan perintah yang tersedia beserta kode dan keterangan "
            "singkat. Blok yang sudah ditambahkan muncul di area kode dan dapat dihapus. "
            "Kapasitas program membatasi jumlah blok agar pemain menyusun solusi yang "
            "efisien.")
    figure(doc, "04-selesai-level.png", "Gambar 4.5 Layar hasil penyelesaian level", width_cm=6.8)
    p(doc, "Layar hasil menampilkan bintang yang diperoleh, XP, koin, dan lokasi level. "
            "Pemain dapat melanjutkan ke level berikutnya, mengulang level untuk "
            "memperbaiki bintang, atau kembali ke beranda.")
    figure(doc, "05-beranda-progres.png", "Gambar 4.6 Beranda setelah progres tersimpan", width_cm=6.8)
    p(doc, "Setelah beberapa level diselesaikan, beranda menampilkan XP dan koin yang "
            "bertambah serta kartu progres belajar yang diperbarui. Perubahan ini "
            "menunjukkan bahwa ValueNotifier dan penyimpanan lokal bekerja.")
    figure(doc, "06-peta-level.png", "Gambar 4.7 Peta level setelah beberapa level terbuka", width_cm=6.8)
    p(doc, "Peta level memperlihatkan level yang telah terbuka dan bintang yang "
            "diperoleh. Level berikutnya tetap terkunci sampai level sebelumnya "
            "diselesaikan.")
    figure(doc, "07-level-6.png", "Gambar 4.8 Arena level 6 (Dinding Pertama)", width_cm=6.8)
    p(doc, "Level 6 menggunakan papan berukuran 5x5 dan area dinding di sisi kiri. Pemain "
            "memasang papan dengan place(\"kayu\") lalu melangkah maju. Perulangan "
            "ulangi_blok(4) memungkinkan empat papan terpasang dengan tiga blok.")
    figure(doc, "07b-level-6-palet.png", "Gambar 4.9 Palet blok level 6", width_cm=6.8)
    p(doc, "Palet level 6 hanya menyediakan place, maju, dan ulang4. Pembatasan ini "
            "mengarahkan pemain menggunakan perulangan untuk menyelesaikan misi secara "
            "efisien.")
    figure(doc, "08-toko-kostum.png", "Gambar 4.10 Toko kostum dan pratinjau item", width_cm=6.8)
    p(doc, "Toko kostum menampilkan saldo koin, kategori item, pratinjau, warna robot, "
            "harga, serta tombol beli dan pakai. Item yang sudah dimiliki dapat langsung "
            "dipakai tanpa membayar kembali.")

    h2(doc, "4.4 Implementasi Database atau API")
    p(doc, "Penyimpanan lokal diimplementasikan pada kelas GameProgress. Saat aplikasi "
            "dijalankan, metode init membaca string JSON dari SharedPreferences, "
            "mengubahnya menjadi objek, lalu memberi nilai awal pada bintang, XP, koin, "
            "dan kostum. Setiap perubahan memanggil _save yang menulis kembali seluruh "
            "data. Apabila terjadi kesalahan, proses ditangkap agar permainan tetap "
            "berjalan.")
    code_block(doc, [
        'Future<void> init() async {',
        '  try {',
        '    final p = await SharedPreferences.getInstance();',
        '    final raw = p.getString(_key);',
        '    if (raw == null) return;',
        '    final data = jsonDecode(raw) as Map<String, dynamic>;',
        '    xp = (data["xp"] as num?)?.toInt() ?? 0;',
        '    coins = (data["coins"] as num?)?.toInt() ?? 0;',
        '    // baca stars, owned, equipped ...',
        '    changes.value++;',
        '  } catch (_) {',
        '    // penyimpanan tidak tersedia: mulai dari awal',
        '  }',
        '}',
    ])
    p(doc, "Tidak ada API jaringan yang dipanggil aplikasi. Interaksi hanya terjadi antara "
            "antarmuka, GameProgress, GameAudio, dan penyimpanan lokal. Dengan demikian, "
            "aplikasi dapat dijalankan tanpa server dan tidak bergantung pada koneksi "
            "internet. Struktur ini juga mempermudah pengujian karena data dapat diisolasi "
            "menggunakan SharedPreferences.setMockInitialValues pada pengujian widget.")

    h2(doc, "4.5 Hasil Pengujian Aplikasi")
    p(doc, "Pengujian dilakukan melalui tiga pendekatan: pengujian manual pada Chrome, "
            "pengujian fungsional setiap level, dan pengujian widget menggunakan "
            "flutter test. Pengujian manual berfokus pada pengalaman pengguna, sedangkan "
            "pengujian otomatis memastikan logika inti tetap berjalan setelah perubahan "
            "kode. Tabel 4.4 merangkum pengujian penyelesaian level.")
    table(doc,
          ["No", "Skenario", "Program yang Diuji", "Hasil yang Diharapkan", "Status"],
          [
              ["1", "Level 1: menuju kambing", "maju, maju", "Robot mencapai tujuan dan memperoleh 3 bintang.", "Berhasil"],
              ["2", "Level 2: mengelilingi batu", "kiri, maju, kanan, maju 3x, kanan, maju", "Robot melewati batu dan mencapai tujuan.", "Berhasil"],
              ["3", "Level 3: menebang pohon", "maju, maju, destroy", "Pohon ditebang dan misi selesai.", "Berhasil"],
              ["4", "Level 4: mencukur domba", "kiri, maju, ulang, shear, kanan, maju, maju, shear", "Kedua domba dicukur dan wool lengkap.", "Berhasil"],
              ["5", "Level 5: menebang tiga pohon", "destroy, maju, maju, destroy, maju, kiri, maju, destroy", "Seluruh pohon ditebang.", "Berhasil"],
              ["6", "Level 6: membangun dinding", "place, maju, ulangi_blok(4)", "Empat papan terpasang dengan tiga blok.", "Berhasil"],
              ["7", "Level 7: menyelesaikan rumah", "place, maju, ulangi_blok(3), kiri, place, maju, place, maju", "Seluruh area dinding tertutup.", "Berhasil"],
          ],
          [1.0, 3.4, 5.2, 4.3, 1.5],
          caption="Tabel 4.4 Hasil pengujian penyelesaian level",
          font_size=9.0)
    p(doc, "Selain penyelesaian level, pengujian dilakukan terhadap fitur pendukung. "
            "Pengujian ini memastikan progres, kunci level, toko, dan audio berjalan "
            "sesuai kebutuhan.")
    table(doc,
          ["No", "Skenario", "Hasil yang Diharapkan", "Status"],
          [
              ["1", "Menyelesaikan level lalu menutup dan membuka aplikasi", "Bintang, XP, dan koin tetap tersimpan.", "Berhasil"],
              ["2", "Membuka level yang belum memenuhi syarat", "Level tetap terkunci sampai level sebelumnya selesai.", "Berhasil"],
              ["3", "Membeli kostum dengan koin cukup", "Koin berkurang dan item dapat dipakai.", "Berhasil"],
              ["4", "Membeli kostum dengan koin kurang", "Pembelian ditolak dan saldo tidak berubah.", "Berhasil"],
              ["5", "Mematikan suara lalu membuka aplikasi kembali", "Status suara tetap mati.", "Berhasil"],
              ["6", "Menggeser volume", "Volume berubah dan tersimpan.", "Berhasil"],
              ["7", "Menekan Atur Ulang", "Program kosong dan robot kembali ke posisi awal.", "Berhasil"],
          ],
          [1.0, 6.0, 6.7, 2.0],
          caption="Tabel 4.5 Hasil pengujian fitur pendukung",
          font_size=9.0)
    p(doc, "Pengujian otomatis dijalankan dengan perintah flutter test. Berkas "
            "test/widget_test.dart memuat lima pengujian, yaitu tampilan shell utama, "
            "ketersediaan level 6 dan 7, penyelesaian level 6, penyelesaian level 7, serta "
            "penyimpanan dan pemuatan progres. Hasil pengujian ditunjukkan pada Tabel 4.6.")
    table(doc,
          ["No", "Nama Pengujian", "Hasil"],
          [
              ["1", "AlgoCraftApp menampilkan shell utama", "Lulus"],
              ["2", "Level 6 dan 7 tersedia di daftar level", "Lulus"],
              ["3", "Level 6 selesai dengan place + ulangi_blok(4)", "Lulus"],
              ["4", "Level 7 selesai dengan place + ulangi_blok(3)", "Lulus"],
              ["5", "Progres disimpan: rekam menang, muat ulang, kunci peta", "Lulus"],
          ],
          [1.0, 12.0, 2.7],
          caption="Tabel 4.6 Hasil pengujian otomatis",
          font_size=9.5)
    p(doc, "Berdasarkan ketiga pendekatan pengujian, seluruh skenario utama berhasil "
            "dijalankan. Tidak ditemukan kegagalan yang menghalangi penyelesaian level "
            "atau penyimpanan progres. Pengujian juga menunjukkan bahwa percobaan ulang "
            "tidak menurunkan bintang terbaik dan level berikutnya terbuka setelah level "
            "sebelumnya diselesaikan.")

    h2(doc, "4.6 Kendala dan Solusi Pengembangan")
    p(doc, "Selama pengembangan ditemukan beberapa kendala teknis dan desain. Kendala "
            "tersebut diselesaikan secara bertahap melalui perbaikan kode dan pengujian.")
    table(doc,
          ["Kendala", "Penyebab", "Solusi"],
          [
              ["Banner kosong saat aset belum tersedia", "Berkas gambar tidak ditemukan atau gagal dimuat",
               "Menambahkan errorBuilder yang menampilkan gradien cadangan."],
              ["Musik tidak berbunyi pada interaksi pertama di web", "Kebijakan autoplay peramban",
               "Menambahkan upaya melanjutkan musik pada interaksi pengguna berikutnya."],
              ["Pengujian widget gagal karena plugin audio", "Plugin audio tidak tersedia di lingkungan test",
               "Melewati pemanggilan audio saat FLUTTER_TEST aktif."],
              ["Blok isi perulangan ikut dijalankan di luar loop", "Logika penentuan kelompok blok belum tepat",
               "Menambahkan _repeatOwner dan _groupStart untuk membatasi cakupan loop."],
              ["Robot dapat menabrak pohon atau domba", "Pemeriksaan halangan belum lengkap",
               "Menambahkan pemeriksaan batu, pohon, dan domba sebelum langkah."],
              ["Label tombol terpotong pada layar sempit", "Teks melebihi lebar tombol",
               "Menggunakan Flexible dan TextOverflow.ellipsis."],
          ],
          [4.3, 5.2, 6.3],
          caption="Tabel 4.7 Kendala dan solusi pengembangan",
          font_size=9.0)

    h2(doc, "4.7 Dokumentasi Hasil Aplikasi")
    p(doc, "Aplikasi dapat dijalankan pada lingkungan pengembangan dengan perintah "
            "flutter pub get untuk mengunduh dependensi, kemudian flutter run -d chrome "
            "untuk menjalankan versi web. Untuk membuat berkas build web, digunakan "
            "perintah flutter build web. Hasil build dapat diunggah ke layanan hosting "
            "statis atau dijalankan melalui server lokal.")
    code_block(doc, [
        '# menyiapkan dependensi',
        'flutter pub get',
        '',
        '# menjalankan di Chrome',
        'flutter run -d chrome',
        '',
        '# menjalankan pengujian',
        'flutter test',
        '',
        '# membangun versi web',
        'flutter build web',
    ])
    p(doc, "Struktur proyek terdiri atas folder lib untuk kode Dart, assets untuk gambar "
            "dan audio, test untuk pengujian, serta folder platform web, android, dan "
            "windows. Berkas pubspec.yaml mendeklarasikan dependensi dan aset. Pemisahan "
            "ini memudahkan pemeliharaan dan pengembangan lanjutan.")
    p(doc, "Hasil akhir aplikasi menunjukkan bahwa AlgoCraft dapat dijalankan secara "
            "mandiri, menyelesaikan seluruh level, menyimpan progres, menampilkan "
            "penghargaan, dan memainkan audio. Dokumentasi antarmuka pada subbab 4.3 "
            "menjadi bukti visual bahwa fitur-fitur utama telah terimplementasi.")


# ============================================================
# BAB V
# ============================================================
def bab5(doc):
    h1(doc, "BAB V\nPENUTUP")
    h2(doc, "5.1 Kesimpulan")
    p(doc, "Berdasarkan analisis, perancangan, implementasi, dan pengujian yang telah "
            "dilakukan, dapat disimpulkan bahwa AlgoCraft berhasil dikembangkan sebagai "
            "game edukasi algoritma berbasis blok kode. Aplikasi menyajikan konsep "
            "algoritma secara visual melalui robot Kodi dan papan permainan bergaya "
            "voxel, sehingga urutan instruksi dapat diamati secara langsung.")
    numbered(doc, "AlgoCraft menyediakan tujuh level progresif yang mencakup gerak maju, "
                  "belok arah, perulangan, menebang pohon, mencukur domba, dan membangun "
                  "dinding. Setiap level membatasi palet blok agar pemain berfokus pada "
                  "konsep yang sedang dipelajari.", 1)
    numbered(doc, "Mesin permainan berhasil mengeksekusi blok secara berurutan, memeriksa "
                  "halangan, menangani perulangan, serta menentukan kondisi menang sesuai "
                  "tipe sasaran level.", 2)
    numbered(doc, "Sistem penilaian bintang, XP, koin, kunci level progresif, toko kostum, "
                  "dan audio berfungsi serta saling terintegrasi.", 3)
    numbered(doc, "Progres pemain tersimpan secara lokal dalam bentuk JSON dan tetap "
                  "tersedia setelah aplikasi ditutup, tanpa memerlukan server.", 4)
    numbered(doc, "Hasil pengujian manual dan otomatis menunjukkan seluruh level dapat "
                  "diselesaikan dan fitur pendukung berjalan sesuai rancangan.", 5)
    p(doc, "Dengan demikian, tujuan pengembangan aplikasi telah tercapai. AlgoCraft dapat "
            "digunakan sebagai media pendukung pembelajaran algoritma yang interaktif, "
            "ringan, dan dapat diakses secara luring.")

    h2(doc, "5.2 Saran Pengembangan")
    p(doc, "Pengembangan selanjutnya dapat diarahkan pada perluasan materi dan "
            "peningkatan pengalaman pengguna. Beberapa saran yang dapat dipertimbangkan "
            "adalah sebagai berikut.")
    bullet(doc, "Menambahkan konsep percabangan (if), fungsi, dan variabel agar materi "
                "algoritma lebih lengkap.")
    bullet(doc, "Menambahkan mode sandbox atau tantangan buatan pengguna untuk mendorong "
                "kreativitas dan eksplorasi.")
    bullet(doc, "Menyediakan papan peringkat, pencapaian, dan tantangan harian untuk "
                "meningkatkan motivasi jangka panjang.")
    bullet(doc, "Mengintegrasikan backend ringan untuk sinkronisasi progres dan pemantauan "
                "hasil belajar oleh guru.")
    bullet(doc, "Menambahkan pilihan bahasa, mode aksesibilitas, dan penyesuaian ukuran "
                "teks bagi pengguna dengan kebutuhan khusus.")
    bullet(doc, "Menguji aplikasi pada lebih banyak perangkat dan menyiapkan publikasi ke "
                "Play Store atau platform distribusi lain.")


# ============================================================
# DAFTAR PUSTAKA
# ============================================================
def daftar_pustaka(doc):
    h1(doc, "DAFTAR PUSTAKA")
    refs = [
        "Audioplayers. (2026). audioplayers: A Flutter plugin to play audio. https://pub.dev/packages/audioplayers",
        "Dart. (2026). Dart documentation. https://dart.dev/guides",
        "Flutter. (2026). Flutter documentation. https://docs.flutter.dev/",
        "Google. (2026). shared_preferences: Flutter plugin for reading and writing simple key-value pairs. https://pub.dev/packages/shared_preferences",
        "Grover, S., & Pea, R. (2013). Computational thinking in K–12: A review of the state of the field. Educational Researcher, 42(1), 38–43. https://doi.org/10.3102/0013189X12463051",
        "Kapp, K. M. (2012). The gamification of learning and instruction: Game-based methods and strategies for training and education. Pfeiffer.",
        "Lye, S. Y., & Koh, J. H. L. (2014). Review on teaching and learning of computational thinking through programming: What is next for K–12? Computers in Human Behavior, 41, 51–61. https://doi.org/10.1016/j.chb.2014.09.012",
        "Papert, S. (1980). Mindstorms: Children, computers, and powerful ideas. Basic Books.",
        "Resnick, M., Maloney, J., Monroy-Hernández, A., Rusk, N., Eastmond, E., Brennan, K., Millner, A., Rosenbaum, E., Silver, J., Silverman, B., & Kafai, Y. (2009). Scratch: Programming for all. Communications of the ACM, 52(11), 60–67. https://doi.org/10.1145/1592761.1592779",
        "Wing, J. M. (2006). Computational thinking. Communications of the ACM, 49(3), 33–35. https://doi.org/10.1145/1118178.1118215",
        "Hsu, T.-C., Chang, S.-C., & Hung, Y.-T. (2018). How to learn and how to teach computational thinking: Suggestions based on a review of the literature. Computers & Education, 126, 296–310. https://doi.org/10.1016/j.compedu.2018.07.004",
        "Papadakis, S. (2020). Apps to promote computational thinking concepts and coding skills in children of preschool and pre-primary school age. In Mobile learning applications in early childhood education (pp. 1–22). IGI Global.",
    ]
    for ref in refs:
        par = doc.add_paragraph()
        par.paragraph_format.left_indent = Cm(1.27)
        par.paragraph_format.first_line_indent = Cm(-1.27)
        par.paragraph_format.line_spacing = 1.5
        par.paragraph_format.space_after = Pt(6)
        par.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
        run = par.add_run(ref)
        set_run_font(run, size=12)


# ============================================================
# LAMPIRAN 1 — LAPORAN MINGGUAN (template 1)
# ============================================================
def lampiran1(doc):
    h1(doc, "LAMPIRAN")
    lamp = doc.add_paragraph(style="Lampiran Heading")
    run = lamp.add_run("LAMPIRAN 1\nFORMAT LAPORAN MINGGUAN PERKEMBANGAN PROYEK")
    set_run_font(run, size=14, bold=True)
    run.add_break()
    p(doc, "Lampiran ini mengadaptasi Format Laporan Mingguan–Mobile Programming ke "
            "dalam laporan proyek akhir. Bagian A sampai H merangkum identitas proyek, "
            "target, realisasi, fitur, bukti, kendala, evaluasi, dan rencana kerja.")

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("A. IDENTITAS PROYEK")
    set_run_font(r, size=12, bold=True)
    table(doc,
          ["Komponen", "Keterangan"],
          [
              ["Nama Proyek", "Pengembangan Game Edukasi AlgoCraft Berbasis Flutter"],
              ["Nama Aplikasi", "AlgoCraft"],
              ["Nama Ketua Tim", NAMA],
              ["Anggota Tim", "Proyek dikerjakan secara mandiri (individu)."],
              ["Program Studi / Kelas", f"{PRODI} / {KELAS}"],
              ["Dosen Pengampu", f"1. {DOSEN1}\n2. {DOSEN2}"],
              ["Periode / Minggu Ke-", "Oktober 2026 / Minggu ke-4"],
              ["Tanggal Pelaporan", "23 Oktober 2026"],
              ["Platform Pengembangan", "Flutter Web (Chrome), Android, dan Windows"],
              ["Teknologi yang Digunakan", "Dart, Flutter, flutter_svg, audioplayers, shared_preferences"],
          ],
          [5.0, 10.8],
          caption="Tabel A.1 Identitas proyek",
          font_size=9.5)

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("B. TUJUAN DAN TARGET MINGGUAN")
    set_run_font(r, size=12, bold=True)
    p(doc, "Target utama:", bold=True, space_after=2)
    p(doc, "Menyelesaikan pengembangan game edukasi AlgoCraft yang dapat dimainkan dari "
            "level pertama hingga level ketujuh, serta menyusun laporan proyek akhir.")
    p(doc, "Target teknis:", bold=True, space_after=2)
    p(doc, "Menerapkan mesin eksekusi blok perintah, kondisi menang, penilaian bintang, "
            "penyimpanan progres, toko kostum, dan audio pada aplikasi Flutter yang "
            "berjalan di Chrome.")
    p(doc, "Luaran yang diharapkan:", bold=True, space_after=2)
    p(doc, "Aplikasi AlgoCraft versi 1.0.0 yang berfungsi, kode program yang tersimpan "
            "dalam repositori, tangkapan layar antarmuka, serta laporan proyek akhir "
            "dalam format Word.")

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("C. REALISASI PERKEMBANGAN PROYEK")
    set_run_font(r, size=12, bold=True)
    p(doc, "Realisasi pengembangan proyek selama periode pelaporan dirangkum pada "
            "Tabel A.2. Seluruh aktivitas utama telah diselesaikan dan diuji.")
    table(doc,
          ["No.", "Aktivitas Pengembangan", "Target Mingguan", "Hasil yang Dicapai", "Status"],
          [
              ["1", "Penyiapan proyek Flutter", "Struktur proyek dan dependensi siap",
               "Proyek game_irfan dibuat, dependensi terpasang, aplikasi berjalan di Chrome.", "Selesai"],
              ["2", "Pembuatan mesin blok dan level", "Tujuh level dapat dimainkan",
               "Model MissionLevel, 13 blok perintah, dan mesin eksekusi berfungsi.", "Selesai"],
              ["3", "Pembuatan progres, ekonomi, dan toko", "Progres tersimpan dan toko berfungsi",
               "Bintang, XP, koin, kunci level, dan 18 item kostum terintegrasi.", "Selesai"],
              ["4", "Penambahan audio dan penyempurnaan UI", "Musik dan efek suara aktif",
               "BGM loop, SFX, kontrol suara, dan volume tersimpan.", "Selesai"],
              ["5", "Pengujian dan dokumentasi", "Seluruh level lulus uji",
               "Pengujian manual dan lima pengujian widget lulus; laporan disusun.", "Selesai"],
          ],
          [1.0, 4.1, 3.7, 5.8, 1.6],
          caption="Tabel A.2 Realisasi perkembangan proyek",
          font_size=9.0)

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("D. DETAIL FITUR YANG DIKEMBANGKAN")
    set_run_font(r, size=12, bold=True)
    table(doc,
          ["No.", "Nama Fitur", "Deskripsi dan Fungsi", "Teknologi / Komponen", "Status"],
          [
              ["1", "Peta level progresif", "Menampilkan tujuh level, gembok, dan bintang terbaik.", "LevelMapScreen, GameProgress", "Selesai"],
              ["2", "Penyusunan blok", "Menambah dan menghapus blok pada area kode sesuai kapasitas.", "Cmd, palet blok, setState", "Selesai"],
              ["3", "Eksekusi program", "Menjalankan blok berurutan dengan animasi dan pemeriksaan halangan.", "Future async, CustomPaint", "Selesai"],
              ["4", "Perulangan", "Mengulang satu blok atau kelompok blok di atasnya.", "ulang, ulang3, ulang4", "Selesai"],
              ["5", "Penilaian bintang", "Memberi tiga atau dua bintang berdasarkan efisiensi blok.", "parBlocks, _starsUsed", "Selesai"],
              ["6", "Progres dan ekonomi", "Menyimpan bintang, XP, koin, dan kunci level.", "GameProgress, SharedPreferences", "Selesai"],
              ["7", "Toko kostum", "Membeli dan memakai 18 item dalam lima kategori.", "CustomizeScreen, buyItem", "Selesai"],
              ["8", "Audio", "Musik latar, efek suara, kontrol aktif, dan volume.", "GameAudio, audioplayers", "Selesai"],
          ],
          [1.0, 3.4, 6.0, 4.4, 1.4],
          caption="Tabel A.3 Detail fitur yang dikembangkan",
          font_size=9.0)

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("E. BUKTI PERKEMBANGAN PROYEK")
    set_run_font(r, size=12, bold=True)
    p(doc, "Bukti aktual berupa tangkapan layar aplikasi disajikan berikut. Bukti lain "
            "berupa kode program dan hasil pengujian dijelaskan pada Lampiran 2 dan 3.")
    figure(doc, "01-beranda.png", "Gambar A.1 Bukti 1 — Tampilan beranda AlgoCraft", width_cm=6.5)
    p(doc, "Keterangan: Beranda menampilkan misi aktif, XP, koin, progres belajar, dan "
            "kontrol suara.", italic=True, size=10, space_after=10)
    figure(doc, "03-arena-misi.png", "Gambar A.2 Bukti 2 — Arena misi dan palet blok", width_cm=6.5)
    p(doc, "Keterangan: Arena misi menampilkan papan voxel, area kode, palet blok, dan "
            "tombol kontrol.", italic=True, size=10, space_after=10)
    figure(doc, "04-selesai-level.png", "Gambar A.3 Bukti 3 — Hasil penyelesaian level", width_cm=6.5)
    p(doc, "Keterangan: Layar hasil menampilkan bintang, XP, koin, dan tombol untuk "
            "melanjutkan atau mengulang level.", italic=True, size=10, space_after=10)

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("F. KENDALA DAN SOLUSI")
    set_run_font(r, size=12, bold=True)
    table(doc,
          ["No.", "Kendala yang Dihadapi", "Penyebab", "Solusi / Tindakan Perbaikan", "Status"],
          [
              ["1", "Musik tidak langsung berbunyi di web", "Kebijakan autoplay peramban",
               "Mencoba memutar ulang musik saat pengguna berinteraksi.", "Selesai"],
              ["2", "Blok loop menjalankan blok berlebih", "Cakupan kelompok loop belum tepat",
               "Membatasi kelompok dengan _repeatOwner dan _groupStart.", "Selesai"],
              ["3", "Robot menembus pohon/domba", "Pemeriksaan halangan belum lengkap",
               "Menambahkan pemeriksaan objek sebelum langkah.", "Selesai"],
              ["4", "Pengujian widget gagal karena audio", "Plugin tidak tersedia di lingkungan test",
               "Melewati audio saat FLUTTER_TEST aktif.", "Selesai"],
          ],
          [1.0, 4.0, 3.8, 5.8, 1.5],
          caption="Tabel A.4 Kendala dan solusi",
          font_size=9.0)

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("G. EVALUASI PERKEMBANGAN")
    set_run_font(r, size=12, bold=True)
    p(doc, "Persentase progres proyek saat ini:", bold=True, space_after=2)
    p(doc, "100% untuk ruang lingkup proyek akhir yang telah ditetapkan, meliputi tujuh "
            "level, progres, ekonomi, toko, audio, pengujian, dan dokumentasi.")
    p(doc, "Target yang telah tercapai:", bold=True, space_after=2)
    p(doc, "Seluruh level dapat diselesaikan, kondisi menang dan penilaian bintang "
            "berfungsi, progres tersimpan, toko kostum berjalan, audio aktif, dan "
            "pengujian otomatis lulus.")
    p(doc, "Target yang belum tercapai:", bold=True, space_after=2)
    p(doc, "Fitur di luar batasan proyek, seperti mode multipemain, leaderboard daring, "
            "backend sinkronisasi, dan materi percabangan/fungsi, belum diimplementasikan.")
    p(doc, "Kualitas dan fungsi aplikasi saat ini:", bold=True, space_after=2)
    p(doc, "Aplikasi berjalan stabil pada Chrome, antarmuka konsisten, dan seluruh fitur "
            "inti dapat digunakan. Beberapa penyempurnaan visual dan penambahan konten "
            "masih dapat dilakukan pada pengembangan berikutnya.")
    p(doc, "Evaluasi kerja sama dan kontribusi anggota tim:", bold=True, space_after=2)
    p(doc, "Proyek dikerjakan secara mandiri. Seluruh tahapan, mulai dari analisis, "
            "perancangan, implementasi, pengujian, hingga penyusunan laporan, "
            "dilaksanakan oleh penyusun dengan bimbingan dosen pengampu.")

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("H. RENCANA KERJA MINGGU BERIKUTNYA")
    set_run_font(r, size=12, bold=True)
    table(doc,
          ["No.", "Aktivitas yang Direncanakan", "Target Luaran", "Penanggung Jawab", "Target Waktu"],
          [
              ["1", "Menambahkan materi percabangan dan fungsi", "Dua level baru dengan konsep if dan fungsi", NAMA, "Minggu berikutnya"],
              ["2", "Menyempurnakan aset visual dan animasi", "Tampilan robot dan papan lebih variatif", NAMA, "Minggu berikutnya"],
              ["3", "Menyiapkan publikasi aplikasi", "Berkas build web/Android siap dibagikan", NAMA, "Akhir semester"],
          ],
          [1.0, 5.0, 5.2, 3.0, 2.0],
          caption="Tabel A.5 Rencana kerja pengembangan berikutnya",
          font_size=9.0)


# ============================================================
# LAMPIRAN 2 — KODE PROGRAM
# ============================================================
def lampiran2(doc):
    lamp = doc.add_paragraph(style="Lampiran Heading")
    lamp.paragraph_format.page_break_before = True
    run = lamp.add_run("LAMPIRAN 2\nCUPLIKAN KODE PROGRAM")
    set_run_font(run, size=14, bold=True)
    run.add_break()
    p(doc, "Lampiran ini memuat cuplikan kode inti yang menunjukkan implementasi model "
            "level, penilaian bintang, perulangan, kondisi menang, dan penyimpanan progres. "
            "Kode lengkap tersedia pada berkas lib/main.dart, lib/game_progress.dart, dan "
            "lib/game_audio.dart.")

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("1. Model Level")
    set_run_font(r, size=12, bold=True)
    code_block(doc, [
        'const kLevels = <MissionLevel>[',
        '  MissionLevel(',
        "    number: 1,",
        "    title: 'Menuju Kambing',",
        "    location: 'Padang Rumput',",
        "    mission: 'Pasang 2 balok gerak_maju() agar bot sampai ke kambing!',",
        "    palette: ['maju'],",
        '    capacity: 2,',
        '    startRow: 3, startCol: 1, startDir: 1,',
        '    goalRow: 3, goalCol: 3,',
        '    rocks: [],',
        "    bushes: [[0, 0], [1, 3], [2, 1]],",
        '    tips: [...],',
        '    reward: 50,',
        '  ),',
        '  // level 2 sampai 7 ...',
        '];',
    ])

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("2. Penilaian Bintang dan Kondisi Menang")
    set_run_font(r, size=12, bold=True)
    code_block(doc, [
        'int get _starsUsed {',
        '  final used = _program.length;',
        '  if (used == 0) return 0;',
        '  return used <= lv.parBlocks ? 3 : 2;',
        '}',
        '',
        'final win = ok &&',
        '    (lv.hasBuild',
        '        ? _buildDone',
        '        : lv.hasSheep',
        '            ? _woolCount >= _woolTotal',
        '            : lv.hasTree',
        '                ? _woodCount >= _woodTotal',
        '                : (_row == lv.goalRow && _col == lv.goalCol));',
    ])

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("3. Perulangan Kelompok Blok")
    set_run_font(r, size=12, bold=True)
    code_block(doc, [
        'Future<bool> _execRepeat(int at) async {',
        '  final id = _program[at];',
        '  if (id == "ulang") {',
        '    final prev = _program[at - 1];',
        '    var ok = await _execCmd(prev);',
        '    if (ok) ok = await _execCmd(prev);',
        '    return ok;',
        '  }',
        '  final start = _groupStart(at);',
        '  final times = _repeatTimes(id);',
        '  for (var k = 0; k < times; k++) {',
        '    for (var i = start; i < at; i++) {',
        '      if (!await _execCmd(_program[i])) return false;',
        '    }',
        '  }',
        '  return true;',
        '}',
    ])

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("4. Penyimpanan Progres")
    set_run_font(r, size=12, bold=True)
    code_block(doc, [
        'class GameProgress {',
        '  static final GameProgress instance = GameProgress._();',
        '  static const _key = "progress_v1";',
        '  final ValueNotifier<int> changes = ValueNotifier<int>(0);',
        '  int xp = 0;',
        '  int coins = 0;',
        '',
        '  bool isUnlocked(int number) =>',
        '      number <= 1 || starsOf(number - 1) > 0;',
        '',
        '  Future<void> recordWin({',
        '    required int number,',
        '    required int stars,',
        '    required int xpGain,',
        '    required int coinGain,',
        '  }) async {',
        '    if (stars > starsOf(number)) _stars[number] = stars;',
        '    xp += xpGain;',
        '    coins += coinGain;',
        '    changes.value++;',
        '    await _save();',
        '  }',
        '}',
    ])

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("5. Pengelolaan Audio")
    set_run_font(r, size=12, bold=True)
    code_block(doc, [
        'class GameAudio {',
        '  static final GameAudio instance = GameAudio._();',
        '  bool soundOn = true;',
        '  double volume = .7;',
        '',
        '  Future<void> playSfx(String name) async {',
        '    if (_skip || !soundOn || volume <= 0) return;',
        '    _resumeBgm();',
        '    final player = _sfx[name] ??= AudioPlayer();',
        '    await player.stop();',
        '    await player.setVolume(volume.clamp(0, 1));',
        '    await player.play(AssetSource("audio/$name.wav"));',
        '  }',
        '}',
    ])


# ============================================================
# LAMPIRAN 3 & 4
# ============================================================
def lampiran3(doc):
    lamp = doc.add_paragraph(style="Lampiran Heading")
    lamp.paragraph_format.page_break_before = True
    run = lamp.add_run("LAMPIRAN 3\nDAFTAR LEVEL DAN BLOK PERINTAH")
    set_run_font(run, size=14, bold=True)
    run.add_break()
    p(doc, "Lampiran ini merangkum tujuh level dan tiga belas blok perintah yang "
            "tersedia pada aplikasi. Data ini bersumber dari kLevels dan kCmds pada "
            "lib/main.dart.")
    table(doc,
          ["Lv", "Judul", "Lokasi", "Konsep Utama", "Blok Kunci", "Par", "Reward"],
          [
              ["1", "Menuju Kambing", "Padang Rumput", "Gerak maju", "maju", "2", "50"],
              ["2", "Pertanyaan Berurutan", "Jalan Setapak", "Urutan dan belok arah", "maju, kanan, kiri", "8", "60"],
              ["3", "Tebang Pohon", "Hutan Cemara", "Menebang pohon", "maju, ulang, destroy", "3", "70"],
              ["4", "Mencukur Domba", "Kandang Domba", "Mengumpulkan wool", "maju, lompat, shear", "8", "80"],
              ["5", "Bangun Rumah", "Lahan Kosong", "Multi-sasaran tebang", "destroy, ulang, lompat", "8", "100"],
              ["6", "Dinding Pertama", "Lahan Bangun", "Perulangan membangun", "place, maju, ulang4", "3", "120"],
              ["7", "Sisa Rumah", "Lahan Bangun", "Perulangan dan material bebas", "place, kanan/kiri, ulang3", "8", "140"],
          ],
          [1.1, 3.4, 3.0, 4.1, 4.2, 1.2, 1.5],
          caption="Tabel B.1 Daftar level AlgoCraft",
          font_size=9.0)
    p(doc, "Nilai par adalah jumlah blok minimum untuk memperoleh tiga bintang. Reward "
            "berupa XP; koin yang diperoleh sebesar sepersepuluh reward. Level 6 dan 7 "
            "menggunakan papan berukuran 5x5, sedangkan level lainnya 4x4.")
    table(doc,
          ["Id", "Label", "Kode", "Fungsi"],
          [
              ["maju", "Gerak Maju", "gerak_maju()", "Maju satu petak."],
              ["maju2", "Gerak Maju 2", "gerak_maju(2)", "Maju dua petak."],
              ["lompat", "Lompat", "lompat()", "Melewati batu tanpa mendarat di atasnya."],
              ["kanan", "Belok Kanan", "belok_kanan()", "Memutar arah 90 derajat ke kanan."],
              ["kiri", "Belok Kiri", "belok_kiri()", "Memutar arah 90 derajat ke kiri."],
              ["ulang", "Ulangi", "ulangi_blok()", "Mengulang blok sebelumnya dua kali."],
              ["ulang3", "Ulangi 3x", "ulangi_blok(3)", "Mengulang kelompok blok di atasnya tiga kali."],
              ["ulang4", "Ulangi 4x", "ulangi_blok(4)", "Mengulang kelompok blok di atasnya empat kali."],
              ["destroy", "Tebang Pohon", "destroy()", "Menebang pohon di petak samping."],
              ["shear", "Cukur Domba", "shear()", "Mengambil wool domba di petak samping."],
              ["place", "Letakkan Kayu", 'place("kayu")', "Memasang papan kayu pada area dinding."],
              ["placeBatu", "Letakkan Batu", 'place("batu")', "Memasang papan batu pada area dinding."],
              ["tunggu", "Tunggu", "tunggu(1)", "Memberi jeda satu detik."],
          ],
          [2.5, 3.4, 4.4, 5.5],
          caption="Tabel B.2 Daftar blok perintah AlgoCraft",
          font_size=9.0)


def lampiran4(doc):
    lamp = doc.add_paragraph(style="Lampiran Heading")
    lamp.paragraph_format.page_break_before = True
    run = lamp.add_run("LAMPIRAN 4\nDAFTAR BERKAS PROYEK")
    set_run_font(run, size=14, bold=True)
    run.add_break()
    p(doc, "Lampiran ini memuat daftar berkas utama yang menyusun proyek AlgoCraft. "
            "Berkas tersebut tersimpan dalam repositori proyek game_irfan.")
    table(doc,
          ["No", "Berkas / Folder", "Keterangan"],
          [
              ["1", "lib/main.dart", "Antarmuka, model level, blok perintah, mesin eksekusi, dan animasi."],
              ["2", "lib/game_progress.dart", "Progres bintang, XP, koin, kostum, dan penyimpanan JSON."],
              ["3", "lib/game_audio.dart", "Musik latar, efek suara, status suara, dan volume."],
              ["4", "assets/images/bg.png", "Banner beranda."],
              ["5", "assets/images/logo.png", "Logo aplikasi."],
              ["6", "assets/images/algocraft_logo.svg", "Logo vektor aplikasi."],
              ["7", "assets/audio/bgm.wav", "Musik latar yang diputar berulang."],
              ["8", "assets/audio/click.wav", "Efek suara interaksi."],
              ["9", "assets/audio/place.wav", "Efek suara pemasangan papan."],
              ["10", "assets/audio/win.wav", "Efek suara kemenangan."],
              ["11", "assets/audio/fail.wav", "Efek suara kegagalan."],
              ["12", "test/widget_test.dart", "Pengujian widget dan penyimpanan progres."],
              ["13", "pubspec.yaml", "Deklarasi dependensi dan aset."],
              ["14", "web/, android/, windows/", "Konfigurasi platform target."],
          ],
          [1.0, 5.3, 9.5],
          caption="Tabel B.3 Daftar berkas utama proyek",
          font_size=9.0)


# ============================================================
# DEKLARASI
# ============================================================
def deklarasi(doc):
    h1(doc, "DEKLARASI")
    p(doc, "Dengan ini saya menyatakan bahwa laporan proyek akhir dengan judul "
            "“AlgoCraft: Game Edukasi Algoritma Berbasis Blok Kode” beserta seluruh "
            "isi aplikasi yang dikembangkan merupakan hasil karya saya sendiri. Sepanjang "
            "pengetahuan saya, tidak terdapat karya atau pendapat yang ditulis atau "
            "diterbitkan oleh orang lain, kecuali yang secara tertulis diacu dalam "
            "laporan ini dan disebutkan dalam daftar pustaka.")
    p(doc, "Saya juga menyatakan bahwa data, tangkapan layar, dan hasil pengujian yang "
            "disajikan dalam laporan ini benar adanya dan diperoleh dari proses "
            "pengembangan yang telah dilakukan. Apabila di kemudian hari ditemukan "
            "ketidaksesuaian atau pelanggaran terhadap ketentuan akademik, saya bersedia "
            "menerima konsekuensi sesuai peraturan yang berlaku.")
    p(doc, KOTA_TANGGAL, align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=6)
    p(doc, "Yang menyatakan,", align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=54)
    p(doc, NAMA, align=WD_ALIGN_PARAGRAPH.RIGHT, bold=True, space_after=0)
    p(doc, f"NIM {NIM}", align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=18)

    sub = doc.add_paragraph(style="Sub Lampiran")
    r = sub.add_run("PEMBAGIAN TUGAS DAN KONTRIBUSI")
    set_run_font(r, size=12, bold=True)
    p(doc, "Proyek akhir ini dikerjakan secara mandiri. Pembagian peran berikut "
            "menggambarkan kontribusi penyusun pada setiap tahapan pengembangan.")
    table(doc,
          ["No.", "Peran / Tahapan", "Kontribusi dan Tanggung Jawab", "Persentase"],
          [
              ["1", "Analisis kebutuhan", "Mengidentifikasi masalah, kebutuhan fungsional, dan nonfungsional.", "15%"],
              ["2", "Perancangan", "Merancang alur permainan, use case, antarmuka, dan struktur data.", "20%"],
              ["3", "Implementasi", "Menulis kode Flutter untuk antarmuka, mesin permainan, progres, toko, dan audio.", "35%"],
              ["4", "Pengujian", "Melakukan pengujian manual dan otomatis serta memperbaiki temuan.", "15%"],
              ["5", "Dokumentasi", "Menyusun laporan, tangkapan layar, dan lampiran pendukung.", "15%"],
          ],
          [1.0, 4.0, 8.7, 2.2],
          caption="Tabel C.1 Pembagian tugas dan kontribusi",
          font_size=9.5)


# ============================================================
# SUSUN DOKUMEN
# ============================================================
def build():
    doc = Document()
    setup_page(doc.sections[0])
    setup_styles(doc)

    # Section 1: halaman depan (angka romawi)
    sec1 = doc.sections[0]
    sec1.different_first_page_header_footer = True
    set_page_number_format(sec1, "lowerRoman", 1)
    add_page_number(sec1.footer.paragraphs[0])
    sec1.first_page_footer.paragraphs[0].text = ""

    cover(doc)
    doc.add_page_break()
    pengesahan(doc)
    doc.add_page_break()
    kata_pengantar(doc)
    doc.add_page_break()
    abstrak(doc)
    doc.add_page_break()
    daftar_isi(doc)
    doc.add_page_break()
    daftar_gambar(doc)
    doc.add_page_break()
    daftar_tabel(doc)
    doc.add_page_break()
    daftar_lampiran(doc)

    # Section 2: isi utama (angka arab)
    sec2 = doc.add_section(WD_SECTION.NEW_PAGE)
    setup_page(sec2)
    sec2.different_first_page_header_footer = False
    set_page_number_format(sec2, "decimal", 1)
    sec2.footer.is_linked_to_previous = False
    add_page_number(sec2.footer.paragraphs[0])

    bab1(doc)
    bab2(doc)
    bab3(doc)
    bab4(doc)
    bab5(doc)
    daftar_pustaka(doc)
    lampiran1(doc)
    lampiran2(doc)
    lampiran3(doc)
    lampiran4(doc)
    deklarasi(doc)

    # Metadata
    props = doc.core_properties
    props.title = "Laporan Proyek Akhir AlgoCraft"
    props.subject = "Mata Kuliah Mobile Programming"
    props.author = NAMA
    props.keywords = "AlgoCraft, game edukasi, algoritma, Flutter, blok kode"
    props.comments = "Laporan proyek akhir yang menggabungkan template laporan mingguan dan laporan akhir."

    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    doc.save(OUT)
    print("Dibuat:", OUT)
    return OUT


if __name__ == "__main__":
    build()
