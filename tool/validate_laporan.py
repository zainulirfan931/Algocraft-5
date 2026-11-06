"""Quick structural validation of the generated report."""
import os
import zipfile
import re

DOCX = r"C:\Users\USER\Downloads\Laporan_Proyek_Akhir_AlgoCraft_Zainul_Irfan.docx"

print(f"Size: {os.path.getsize(DOCX):,} bytes")

with zipfile.ZipFile(DOCX) as z:
    media = [n for n in z.namelist() if n.startswith("word/media/")]
    print(f"Images: {len(media)}")
    for m in media:
        info = z.getinfo(m)
        print(f"  {m}  {info.file_size:,} bytes")
    xml = z.read("word/document.xml").decode("utf-8")
    print(f"document.xml: {len(xml):,} chars")
    # count drawings
    print(f"Drawings: {xml.count('<w:drawing>')}")
    # headings
    styles = z.read("word/styles.xml").decode("utf-8")
    # fldChar fields
    print(f"field chars: {xml.count('fldChar')}")
    instr = re.findall(r"<w:instrText[^>]*>(.*?)</w:instrText>", xml)
    print(f"fields: {len(instr)}")
    for i in instr[:40]:
        print(f"  [{i.strip()}]")
