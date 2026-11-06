"""Update TOC, caption lists, and fields in the generated report using Word COM."""
import os
import sys
import time

import win32com.client as win32

DOCX = r"C:\Users\USER\Downloads\Laporan_Proyek_Akhir_AlgoCraft_Zainul_Irfan.docx"

if not os.path.exists(DOCX):
    print(f"Not found: {DOCX}")
    sys.exit(1)

word = win32.Dispatch("Word.Application")
word.Visible = False
word.DisplayAlerts = 0

doc = None
try:
    doc = word.Documents.Open(DOCX, ReadOnly=False, AddToRecentFiles=False)

    # Update all fields (including TOC entries created as fields)
    for i in range(1, 4):
        try:
            doc.Fields.Update()
        except Exception as exc:
            print(f"Fields.Update attempt {i}: {exc}")
        for toc in doc.TablesOfContents:
            try:
                toc.Update()
            except Exception as exc:
                print(f"TOC update: {exc}")
        for tof in doc.TablesOfFigures:
            try:
                tof.Update()
            except Exception as exc:
                print(f"TableOfFigures update: {exc}")
        doc.Repaginate()
        time.sleep(0.4)

    # Update page number fields in headers/footers
    for section in doc.Sections:
        for hf in (
            section.Headers,
            section.Footers,
        ):
            for item in hf:
                try:
                    item.Range.Fields.Update()
                except Exception:
                    pass

    doc.Repaginate()
    pages = doc.ComputeStatistics(2)  # wdStatisticPages
    words = doc.ComputeStatistics(0)  # wdStatisticWords
    print(f"Pages: {pages}")
    print(f"Words: {words}")

    doc.Save()
    print("Saved.")
finally:
    if doc is not None:
        try:
            doc.Close(SaveChanges=0)
        except Exception:
            pass
    try:
        word.Quit()
    except Exception as exc:
        print(f"Quit: {exc}")
