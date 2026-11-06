"""Export the report to PDF with Word, for visual inspection."""
import os
import win32com.client as win32

DOCX = r"C:\Users\USER\Downloads\Laporan_Proyek_Akhir_AlgoCraft_Zainul_Irfan.docx"
PDF = r"D:\game irfan\docs\laporan\preview_laporan.pdf"

word = win32.Dispatch("Word.Application")
word.Visible = False
word.DisplayAlerts = 0
doc = None
try:
    doc = word.Documents.Open(DOCX, ReadOnly=True, AddToRecentFiles=False)
    doc.ExportAsFixedFormat(
        OutputFileName=PDF,
        ExportFormat=17,          # wdExportFormatPDF
        OpenAfterExport=False,
        OptimizeFor=0,
        Range=0,
        Item=0,
        IncludeDocProps=True,
        KeepIRM=True,
        CreateBookmarks=1,        # wdExportCreateHeadingBookmarks
        DocStructureTags=True,
        BitmapMissingFonts=True,
        UseISO19005_1=False,
    )
    print(f"PDF: {PDF}  {os.path.getsize(PDF):,} bytes")
finally:
    if doc is not None:
        try:
            doc.Close(SaveChanges=0)
        except Exception:
            pass
    try:
        word.Quit()
    except Exception:
        pass
