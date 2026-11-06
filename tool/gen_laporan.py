# Generator 4 laporan progres projek "AlgoCraft" (dokumen Word .docx)
# Jalankan: python tool/gen_laporan.py
import os
from docx import Document
from docx.shared import Pt, RGBColor, Cm
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml.ns import qn
from docx.oxml import OxmlElement

OUT_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "Laporan Progres")
os.makedirs(OUT_DIR, exist_ok=True)

NAVY = RGBColor(0x1F, 0x3B, 0x63)
TEAL = RGBColor(0x0E, 0x74, 0x9B)
GREY = RGBColor(0x55, 0x55, 0x55)
CODE_BG = "F2F4F7"


def setup(doc):
    # Base font
    st = doc.styles["Normal"]
    st.font.name = "Calibri"
    st.font.size = Pt(11)
    st.paragraph_format.space_after = Pt(6)
    st.paragraph_format.line_spacing = 1.15
    # Default east-asian font name
    rpr = st.element.get_or_add_rPr()
    rfonts = rpr.get_or_add_rFonts()
    rfonts.set(qn("w:eastAsia"), "Calibri")
    # Page margins
    for s in doc.sections:
        s.top_margin = Cm(2.0)
        s.bottom_margin = Cm(2.0)
        s.left_margin = Cm(2.2)
        s.right_margin = Cm(2.0)


def _shade(cell, hexcolor):
    tcPr = cell._tc.get_or_add_tcPr()
    shd = OxmlElement("w:shd")
    shd.set(qn("w:val"), "clear")
    shd.set(qn("w:color"), "auto")
    shd.set(qn("w:fill"), hexcolor)
    tcPr.append(shd)


def title(doc, text, subtitle=None):
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run(text)
    r.bold = True
    r.font.size = Pt(20)
    r.font.color.rgb = NAVY
    if subtitle:
        p2 = doc.add_paragraph()
        p2.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r2 = p2.add_run(subtitle)
        r2.italic = True
        r2.font.size = Pt(12)
        r2.font.color.rgb = TEAL
    doc.add_paragraph()


def h1(doc, text):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(12)
    p.paragraph_format.space_after = Pt(4)
    r = p.add_run(text)
    r.bold = True
    r.font.size = Pt(15)
    r.font.color.rgb = NAVY
    # underline bar
    pPr = p._p.get_or_add_pPr()
    pbdr = OxmlElement("w:pBdr")
    bottom = OxmlElement("w:bottom")
    bottom.set(qn("w:val"), "single")
    bottom.set(qn("w:sz"), "6")
    bottom.set(qn("w:space"), "2")
    bottom.set(qn("w:color"), "1F3B63")
    pbdr.append(bottom)
    pPr.append(pbdr)


def h2(doc, text):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(8)
    p.paragraph_format.space_after = Pt(2)
    r = p.add_run(text)
    r.bold = True
    r.font.size = Pt(12.5)
    r.font.color.rgb = TEAL


def para(doc, text, italic=False, color=None):
    p = doc.add_paragraph()
    r = p.add_run(text)
    r.italic = italic
    if color:
        r.font.color.rgb = color
    return p


def bullet(doc, text, level=0):
    p = doc.add_paragraph(style="List Bullet")
    p.paragraph_format.left_indent = Cm(0.6 + 0.5 * level)
    p.add_run(text)
    return p


def numbered(doc, text):
    p = doc.add_paragraph(style="List Number")
    p.paragraph_format.left_indent = Cm(0.6)
    p.add_run(text)
    return p


def code_block(doc, lines):
    for i, ln in enumerate(lines):
        p = doc.add_paragraph()
        p.paragraph_format.space_after = Pt(0 if i < len(lines) - 1 else 6)
        p.paragraph_format.space_before = Pt(0)
        p.paragraph_format.left_indent = Cm(0.4)
        r = p.add_run(ln)
        r.font.name = "Consolas"
        r.font.size = Pt(9.5)
        r.font.color.rgb = RGBColor(0x20, 0x20, 0x20)
        # shade background
        pPr = p._p.get_or_add_pPr()
        shd = OxmlElement("w:shd")
        shd.set(qn("w:val"), "clear")
        shd.set(qn("w:color"), "auto")
        shd.set(qn("w:fill"), CODE_BG)
        pPr.append(shd)


def table(doc, headers, rows, widths=None):
    t = doc.add_table(rows=1, cols=len(headers))
    t.style = "Table Grid"
    t.alignment = WD_TABLE_ALIGNMENT.CENTER
    hdr = t.rows[0].cells
    for i, htxt in enumerate(headers):
        hdr[i].text = ""
        p = hdr[i].paragraphs[0]
        r = p.add_run(htxt)
        r.bold = True
        r.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)
        _shade(hdr[i], "1F3B63")
    for row in rows:
        cells = t.add_row().cells
        for i, val in enumerate(row):
            cells[i].text = str(val)
    if widths:
        for i, w in enumerate(widths):
            for row in t.rows:
                row.cells[i].width = Cm(w)
    doc.add_paragraph()
    return t


def screenshot_placeholder(doc, caption):
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    box = doc.add_table(rows=1, cols=1)
    box.style = "Table Grid"
    cell = box.rows[0].cells[0]
    cell.text = ""
    _shade(cell, "F7F9FC")
    cp = cell.paragraphs[0]
    cp.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = cp.add_run("\n[ Tempat Screenshot ]\n")
    r.italic = True
    r.font.color.rgb = GREY
    r.font.size = Pt(11)
    cell.height = Cm(5.0)
    cap = doc.add_paragraph()
    cap.alignment = WD_ALIGN_PARAGRAPH.CENTER
    rc = cap.add_run(caption)
    rc.font.size = Pt(9)
    rc.font.color.rgb = GREY
    rc.italic = True
    doc.add_paragraph()


def info_table(doc):
    rows = [
        ["Nama Mahasiswa", "[ isi nama kamu ]"],
        ["NIM / Kelas", "[ isi ]"],
        ["Mata Kuliah", "[ isi ]"],
        ["Dosen Pengampu", "[ isi ]"],
        ["Nama Projek", "AlgoCraft — Game Edukasi Algoritma"],
        ["Teknologi", "Flutter (Dart)"],
        ["Nama File / Repo", "game_irfan"],
    ]
    t = doc.add_table(rows=0, cols=2)
    t.style = "Table Grid"
    for k, v in rows:
        cells = t.add_row().cells
        cells[0].text = ""
        r = cells[0].paragraphs[0].add_run(k)
        r.bold = True
        _shade(cells[0], "EAEFF7")
        cells[1].text = v
        cells[0].width = Cm(5.0)
        cells[1].width = Cm(10.0)
    doc.add_paragraph()


def page_break(doc):
    doc.add_page_break()


# ============================================================
# LAPORAN 1
# ============================================================
def laporan1():
    doc = Document()
    setup(doc)
    title(doc, "LAPORAN PROGRES PROJEK 1", "Perencanaan, Analisis Kebutuhan & Fondasi Aplikasi")
    info_table(doc)

    h1(doc, "1. Tujuan Laporan")
    para(doc, "Laporan ini mendokumentasikan tahap perencanaan dan pendirian fondasi projek "
              "game edukasi bernama AlgoCraft. Pada tahap ini fokus utama adalah menganalisis "
              "kebutuhan, memilih teknologi, merancang antarmuka, serta menyiapkan struktur "
              "projek sehingga aplikasi dapat berjalan (run) di peramban Chrome.")
    bullet(doc, "Memahami masalah: banyak pelajar kesulitan memahami konsep algoritma secara abstrak.")
    bullet(doc, "Merancang solusi: game berbasis blok kode yang meniru cara kerja algoritma secara visual.")
    bullet(doc, "Menyiapkan kerangka teknis yang siap dikembangkan pada tahap berikutnya.")

    h1(doc, "2. Ringkasan Projek")
    para(doc, "AlgoCraft adalah game edukasi bertema pulau berpikir (voxel ala Minecraft) di mana "
              "pemain menyusun balok-balok perintah (blok kode) untuk menggerakkan robot bernama Kodi. "
              "Tujuannya menyelesaikan misi logika sambil memahami urutan perintah, perulangan, "
              "dan operasi seperti menebang, mencukur, serta membangun.")
    table(doc,
          ["Aspek", "Keterangan"],
          [
              ["Genre", "Edukasi / Puzzle berbasis logika algoritma"],
              ["Target pengguna", "Pelajar (SD/SMP) yang belajar algoritma dasar"],
              ["Platform", "Flutter Web (Chrome), bisa juga Android/Windows"],
              ["Jumlah level", "7 level dengan tingkat kesulitan naik"],
              ["Fitur utama", "Blok kode, rating bintang, XP & koin, toko kostum, audio"],
          ],
          widths=[4.5, 10.5])

    h1(doc, "3. Analisis Kebutuhan")
    h2(doc, "3.1 Kebutuhan Fungsional")
    bullet(doc, "Menyusun blok perintah (maju, belok, lompat, ulang, tebang, cukur, bangun) secara berurutan.")
    bullet(doc, "Mengeksekusi urutan blok dan menganimasikan gerak robot di papan.")
    bullet(doc, "Menentukan kondisi menang/gagal setiap level.")
    bullet(doc, "Menilai hasil dengan sistem bintang (1–3) berdasarkan jumlah blok.")
    bullet(doc, "Memberikan hadiah XP dan koin saat level selesai.")
    bullet(doc, "Menyimpan progres pemain agar bertahan setelah aplikasi ditutup.")
    bullet(doc, "Menjual dan memakai kostum menggunakan koin.")
    bullet(doc, "Memutar musik latar dan efek suara dengan kontrol on/off serta volume.")

    h2(doc, "3.2 Kebutuhan Non-Fungsional")
    bullet(doc, "Tampilan menarik dan ramah anak (warna cerah, kartu, ikon).")
    bullet(doc, "Responsif: nyaman di layar desktop maupun ponsel.")
    bullet(doc, "Cepat dan ringan, tanpa jaringan internet (offline).")
    bullet(doc, "Mudah ditambah level baru tanpa mengubah logika inti.")

    h1(doc, "4. Pemilihan Teknologi")
    table(doc,
          ["Teknologi / Package", "Alasan Pemakaian"],
          [
              ["Flutter (Dart)", "Cross-platform: satu basis kode untuk web, Android, dan desktop."],
              ["flutter_svg", "Menampilkan vektor SVG bila diperlukan aset grafis."],
              ["audioplayers", "Memutar musik latar (loop) dan efek suara sederhana."],
              ["shared_preferences", "Menyimpan progres (bintang, XP, koin, kostum) secara lokal."],
              ["CustomPaint", "Menggambar papan bergaya voxel tanpa aset gambar berat."],
          ],
          widths=[4.5, 10.5])

    h1(doc, "5. Perancangan Antarmuka (Wireframe Sederhana)")
    para(doc, "Aplikasi memakai kerangka utama (MainShell) berisi tiga tab pada bilah navigasi bawah, "
              "ditambah layar-layar tambahan yang dibuka lewat Navigator.")
    table(doc,
          ["Layar", "Fungsi"],
          [
              ["Beranda (HomeScreen)", "Sapaan, misi aktif, kartu progres belajar, kontrol suara."],
              ["Peta Level (LevelMapScreen)", "Daftar 7 level beserta status bintang dan kunci."],
              ["Toko (CustomizeScreen)", "Membeli dan memakai kostum dengan koin."],
              ["Arena Misi (ChallengeScreen)", "Papan permainan, palet blok, tombol jalankan/atur ulang."],
              ["Selesai (LevelCompleteScreen)", "Popup hasil: bintang, XP, koin, tombol lanjut."],
          ],
          widths=[5.5, 9.5])

    h1(doc, "6. Struktur Projek")
    code_block(doc, [
        "game_irfan/",
        "├── lib/",
        "│   ├── main.dart          # UI + logika game + data 7 level",
        "│   ├── game_progress.dart # progres bintang, XP, koin, kostum",
        "│   └── game_audio.dart    # musik latar + efek suara",
        "├── assets/",
        "│   ├── images/            # gambar (bg.png, dst.)",
        "│   └── audio/             # bgm.wav, click.wav, win.wav, dst.",
        "├── pubspec.yaml           # dependensi & deklarasi aset",
        "└── web/, android/, windows/  # platform target",
    ])
    para(doc, "Pemisahan tugas modul:", italic=True)
    bullet(doc, "main.dart — seluruh widget UI, model level (MissionLevel), daftar blok (Cmd), dan mesin eksekusi.")
    bullet(doc, "game_progress.dart — singleton GameProgress: bintang, XP, koin, kostum, dan penyimpanan JSON.")
    bullet(doc, "game_audio.dart — singleton GameAudio: BGM loop, SFX, preferensi on/off & volume.")

    h1(doc, "7. Hasil Tahap Ini")
    bullet(doc, "Lingkungan pengembangan Flutter terpasang dan aplikasi template berjalan.")
    bullet(doc, "Struktur folder dan modul dasar dibuat.")
    bullet(doc, "Aplikasi skeleton berhasil dijalankan di Chrome melalui perintah flutter run -d chrome.")
    screenshot_placeholder(doc, "Gambar 1.1 — Tampilan awal aplikasi AlgoCraft di Chrome")

    h1(doc, "8. Kendala dan Solusi")
    table(doc,
          ["Kendala", "Solusi"],
          [
              ["Belum ada aset gambar, layar kosong.", "Menambahkan errorBuilder agar tampilan gradient muncul bila gambar gagal dimuat."],
              ["Layout harus nyaman di layar lebar dan sempit.", "Membungkus aplikasi dalam container berbatas maksimal 430 px dan SafeArea."],
          ],
          widths=[7.5, 7.5])

    h1(doc, "9. Kesimpulan")
    para(doc, "Tahap perencanaan selesai: kebutuhan teridentifikasi, teknologi terpilih, rancangan antarmuka "
              "dan struktur projek siap. Fondasi aplikasi telah berjalan di Chrome sebagai dasar pengembangan "
              "gameplay pada laporan berikutnya.")

    path = os.path.join(OUT_DIR, "Laporan_Progres_1.docx")
    doc.save(path)
    return path


# ============================================================
# LAPORAN 2
# ============================================================
def laporan2():
    doc = Document()
    setup(doc)
    title(doc, "LAPORAN PROGRES PROJEK 2", "Mesin Game, Sistem Blok Kode & Perancangan Level")
    info_table(doc)

    h1(doc, "1. Tujuan Laporan")
    para(doc, "Laporan ini menjelaskan pembuatan inti permainan: sistem blok kode, model level, "
              "logika eksekusi perintah robot, serta perancangan tujuh level dari mudah ke sulit.")

    h1(doc, "2. Sistem Blok Kode (Perintah)")
    para(doc, "Setiap perintah direpresentasikan sebagai objek kelas Cmd yang memuat id, label, kode, "
              "ikon, dan warna. Palet blok tiap level dibatasi agar pemain fokus pada konsep yang sedang dipelajari.")
    table(doc,
          ["Id Blok", "Tampilan", "Kode", "Fungsi"],
          [
              ["maju / maju2", "Gerak Maju", "gerak_maju()", "Maju 1 atau 2 petak ke arah hadap."],
              ["lompat", "Lompat", "lompat()", "Melompati batu (kecuali mendarat di batu)."],
              ["kanan / kiri", "Belok Kanan/Kiri", "belok_kanan() / belok_kiri()", "Memutar arah hadap 90°."],
              ["ulang / ulang3 / ulang4", "Ulangi", "ulangi_blok(n)", "Mengulang balok sebelumnya / kelompok balok."],
              ["destroy", "Tebang Pohon", "destroy()", "Menebang pohon di petak sebelah bot."],
              ["shear", "Cukur Domba", "shear()", "Mengumpulkan wool dari domba di sebelah bot."],
              ["place / placeBatu", "Letakkan Kayu/Batu", "place(\"kayu\")", "Memasang papan di petak dinding."],
              ["tunggu", "Tunggu", "tunggu(1)", "Jeda satu detik."],
          ],
          widths=[3.5, 3.2, 4.0, 4.3])
    para(doc, "Arah disimpan sebagai index 0=atas, 1=kanan, 2=bawah, 3=kiri dengan bantuan array delta baris/kolom:", italic=True)
    code_block(doc, [
        "const kDr = [-1, 0, 1, 0];   // delta baris  (arah atas/kanan/bawah/kiri)",
        "const kDc = [ 0, 1, 0, -1];  // delta kolom",
    ])

    h1(doc, "3. Model Level (MissionLevel)")
    para(doc, "Setiap level didefinisikan lewat kelas MissionLevel sehingga menambah level baru cukup "
              "menambah data, tanpa mengubah kode mesin permainan.")
    table(doc,
          ["Field", "Keterangan"],
          [
              ["number, title, location", "Nomor, judul, dan lokasi level."],
              ["difficulty", "Tingkat kesulitan (MUDAH/SEDANG/SULIT)."],
              ["mission, hint, quickTip", "Teks misi, petunjuk, dan tips singkat."],
              ["palette", "Daftar id blok yang boleh dipakai."],
              ["capacity", "Jumlah maksimum blok yang boleh dipasang."],
              ["par", "Jumlah blok minimum untuk memperoleh 3 bintang."],
              ["boardSize", "Sisi papan (4 default, 5 untuk level membangun)."],
              ["startRow/Col/Dir", "Posisi dan arah awal robot."],
              ["rocks, bushes, trees, sheep, walls", "Penghalang, dekorasi, pohon, domba, dan area bangunan."],
              ["reward", "Hadiah koin saat level selesai."],
          ],
          widths=[5.5, 9.5])

    h1(doc, "4. Logika Eksekusi & Kondisi Menang")
    para(doc, "Mesin permainan membaca urutan blok dari atas ke bawah, menjalankan tiap perintah "
              "berurutan dengan jeda animasi. Sistem mendeteksi halangan (batu, pohon, domba) dan "
              "menentukan keberhasilan berdasarkan tipe sasaran level.")
    h2(doc, "4.1 Tiga tipe sasaran kemenangan")
    bullet(doc, "Sasaran jalan: robot mencapai petak tujuan (goal).")
    bullet(doc, "Sasaran tebang/cukur: menebang semua pohon (hasTree) atau mencukur semua domba (hasSheep).")
    bullet(doc, "Sasaran bangun: memasang papan pada seluruh petak dinding (hasBuild).")
    h2(doc, "4.2 Penilaian bintang")
    code_block(doc, [
        "int get _starsUsed {",
        "  final used = _program.length;",
        "  if (used == 0) return 0;",
        "  return used <= lv.parBlocks ? 3 : 2;  // blok efisien = 3 bintang",
        "}",
    ])
    para(doc, "Aturan dasar: bila jumlah blok yang dipakai tidak melebihi nilai par, pemain mendapat "
              "3 bintang; selain itu mendapat 2 bintang. Bintang terbaik dari semua percobaan yang disimpan.")

    h1(doc, "5. Perancangan Tujuh Level")
    table(doc,
          ["Lv", "Judul", "Konsep Utama", "Blok Kunci", "Par"],
          [
              ["1", "Menuju Kambing", "Gerak maju sederhana", "maju", "2"],
              ["2", "Tebang Kayu*", "Urutan & belok arah", "maju, kanan, kiri", "8"],
              ["3", "Tebang Pohon", "Menebang pohon", "maju, ulang, destroy", "3"],
              ["4", "Mencukur Domba", "Mengumpulkan wool", "maju, lompat, shear", "8"],
              ["5", "Bangun Rumah", "Multi-sasaran tebang", "destroy, ulang, lompat", "8"],
              ["6", "Dinding Pertama", "Perulangan membangun", "place, maju, ulang4", "3"],
              ["7", "Sisa Rumah", "Perulangan + material bebas", "place, kanan/kiri, ulang3", "8"],
          ],
          widths=[1.2, 3.5, 4.3, 4.5, 1.5])
    para(doc, "*judul misi level 2 berjudul “Pertanyaan Berurutan” dengan tab “Tebang Kayu”.", italic=True, color=GREY)
    para(doc, "Progresi dirancang bertahap: dari satu konsep (gerak), lalu urutan belong, perulangan, "
              "operasi khusus (tebang/cukur), hingga kombinasi membangun dengan loop.")

    h1(doc, "6. Tampilan Arena")
    para(doc, "Papan permainan digambar dengan CustomPaint bergaya voxel (hijau rumput, sisi gelap) "
              "beserta objek seperti batu, pohon, domba, dan papan dinding. Palet blok, area kode, "
              "pratinjau teks, tombol Jalankan/Atur Ulang, serta penunjuk kemajuan (kayu, wool, papan) "
              "ditampilkan mengelilingi papan.")
    screenshot_placeholder(doc, "Gambar 2.1 — Arena misi dengan palet blok dan papan voxel")
    screenshot_placeholder(doc, "Gambar 2.2 — Animasi eksekusi blok (robot bergerak)")

    h1(doc, "7. Hasil Tahap Ini")
    bullet(doc, "Seluruh 7 level dapat dimainkan dari awal hingga selesai.")
    bullet(doc, "Logika gerak, tabrakan, perulangan, tebang, cukur, dan bangun berfungsi.")
    bullet(doc, "Penilaian bintang berdasarkan efisiensi blok berjalan.")
    bullet(doc, "Umpan balik status (SnackBar dan teks status) muncul saat berhasil/gagal.")

    h1(doc, "8. Kendala dan Solusi")
    table(doc,
          ["Kendala", "Solusi"],
          [
              ["Perulangan menjalankan blok berlebih di luar loop.", "Membatasi blok loop hanya mengulang kelompok balok di atasnya (ulang = 1 blok, ulang3/4 = kelompok)."],
              ["Robot bisa menabrak pohon/domba yang belum ditangani.", "Menambahkan pemeriksaan halangan sebelum langkah dan pesan status yang jelas."],
              ["Level membutuhkan papan lebih besar.", "Menambah field boardSize sehingga level 6–7 memakai papan 5×5."],
          ],
          widths=[7.5, 7.5])

    h1(doc, "9. Kesimpulan")
    para(doc, "Inti permainan selesai dibangun: sistem blok kode, mesin eksekusi, model level, dan "
              "tujuh level bermain telah berfungsi. Tahap selanjutnya adalah menyempurnakan sistem "
              "pendukung seperti progres, ekonomi, dan audio.")

    path = os.path.join(OUT_DIR, "Laporan_Progres_2.docx")
    doc.save(path)
    return path


# ============================================================
# LAPORAN 3
# ============================================================
def laporan3():
    doc = Document()
    setup(doc)
    title(doc, "LAPORAN PROGRES PROJEK 3", "Sistem Progres, Ekonomi (XP/Koin), Toko & Audio")
    info_table(doc)

    h1(doc, "1. Tujuan Laporan")
    para(doc, "Laporan ini menjelaskan pembuatan sistem pendukung yang membuat game terasa lengkap: "
              "penyimpanan progres, sistem bintang/XP/koin, toko kostum, serta audio (musik dan efek suara).")

    h1(doc, "2. Sistem Progres & Penyimpanan Persisten")
    para(doc, "Modul game_progress.dart menyediakan singleton GameProgress yang menyimpan bintang per level, "
              "XP, koin, kostum yang dimiliki, dan kostum yang sedang dipakai. Seluruh data diserialisasi "
              "menjadi satu objek JSON dan disimpan di SharedPreferences dengan kunci progress_v1, "
              "sehingga progres tetap ada walau aplikasi ditutup.")
    code_block(doc, [
        "class GameProgress {",
        "  static final GameProgress instance = GameProgress._();",
        "  final ValueNotifier<int> changes = ValueNotifier<int>(0);",
        "  int xp = 0;",
        "  int coins = 0;",
        "",
        "  Future<void> init() async { ... }        // muat data tersimpan",
        "  int starsOf(int number) => ...;          // bintang terbaik level",
        "  bool isUnlocked(int n) => ...;           // kunci progresif",
        "  Future<void> recordWin({...}) async {...} // catat kemenangan",
        "  Future<bool> buyItem(String id, int price) {...}",
        "  Future<void> equipItem(String cat, String id) {...}",
        "}",
    ])
    h2(doc, "2.1 Kunci progresif")
    para(doc, "Level terbuka secara berurutan: level N baru bisa dimainkan bila level N−1 sudah "
              "pernah selesai (minimal 1 bintang). Level pertama selalu terbuka.")
    h2(doc, "2.2 Pembaruan UI otomatis")
    para(doc, "Setiap kali data berubah, nilai changes pada ValueNotifier dinaikkan. Widget seperti pil XP/koin "
              "membungkus diri dengan ValueListenableBuilder sehingga tampilan ikut diperbarui sendiri tanpa "
              "perlu refresh manual.")

    h1(doc, "3. Sistem Bintang, XP, dan Koin")
    table(doc,
          ["Komponen", "Cara Kerja"],
          [
              ["Bintang (1–3)", "Dihitung dari efisiensi jumlah blok terhadap nilai par."],
              ["XP", "Ditambahkan setiap kali level berhasil diselesaikan."],
              ["Koin", "Ditambahkan sesuai reward level; dipakai membeli kostum."],
              ["Bintang terbaik", "Disimpan nilai terbaik dari semua percobaan (tidak menurun)."],
              ["Kemenangan", "recordWin() menaikkan XP & koin lalu menyimpan ke disk."],
          ],
          widths=[4.5, 10.5])

    h1(doc, "4. Toko Kostum")
    para(doc, "Layar CustomizeScreen menampilkan daftar item kostum berdasarkan kategori. Pemain dapat "
              "membeli item dengan koin (buyItem) dan memakainya (equipItem). Status kepemilikan dan "
              "pemakaian juga ikut disimpan sehingga tidak hilang saat aplikasi dibuka ulang.")
    bullet(doc, "Beli: memeriksa kepemilikan dan cukupnya koin, lalu mengurangi koin.")
    bullet(doc, "Pakai / lepas: mengatur kostum aktif per kategori (equip/unequip).")
    bullet(doc, "Item yang sudah dimiliki tidak bisa dibeli dua kali.")

    h1(doc, "5. Sistem Audio")
    para(doc, "Modul game_audio.dart menyediakan singleton GameAudio untuk musik latar (loop) dan "
              "efek suara satu-kali. Status on/off dan volume disimpan di SharedPreferences "
              "(kunci sound_on dan volume) sehingga preferensi bertahan.")
    code_block(doc, [
        "class GameAudio {",
        "  static final GameAudio instance = GameAudio._();",
        "  bool soundOn = true;",
        "  double volume = .7;",
        "",
        "  Future<void> init() async { ... }              // muat preferensi + mulai BGM",
        "  Future<void> playSfx(String name) async {...}   // 'click','win','fail',dst.",
        "  Future<void> setSoundOn(bool on) async {...}",
        "  void setVolume(double v) {...}",
        "}",
    ])
    h2(doc, "5.1 Penanganan khusus web & pengujian")
    bullet(doc, "Autoplay browser: musik mungkin ditahan; audio dicoba lagi otomatis pada interaksi pengguna berikutnya.")
    bullet(doc, "Lingkungan pengujian: pemanggilan audio otomatis diabaikan (FLUTTER_TEST) agar test widget tidak gagal.")
    bullet(doc, "Kegagalan diputar ditangkap tanpa menghentikan game (try-catch).")

    h1(doc, "6. Hasil Tahap Ini")
    bullet(doc, "Progres bintang, XP, koin, dan kostum tersimpan dan termuat kembali dengan benar.")
    bullet(doc, "Kunci progresif antar level berfungsi.")
    bullet(doc, "Toko kostum dapat membeli dan memakai item.")
    bullet(doc, "Musik latar loop dan efek suara berfungsi; kontrol on/off & volume tersimpan.")
    screenshot_placeholder(doc, "Gambar 3.1 — Beranda dengan pil XP/koin dan kartu progres")
    screenshot_placeholder(doc, "Gambar 3.2 — Toko Kostum dan kartu pengaturan suara")

    h1(doc, "7. Kendala dan Solusi")
    table(doc,
          ["Kendala", "Solusi"],
          [
              ["Data hilang bila penyimpanan tidak tersedia.", "Membungkus akses SharedPreferences dengan try-catch; permainan tetap jalan dengan data di memori."],
              ["Browser menahan autoplay musik.", "Menambah fungsi resume yang mencoba memutar ulang saat interaksi pengguna."],
              ["UI tidak tahu saat data berubah.", "Memakai ValueNotifier + ValueListenableBuilder sebagai penyalur perubahan."],
          ],
          widths=[7.5, 7.5])

    h1(doc, "8. Kesimpulan")
    para(doc, "Sistem pendukung selesai: progres tersimpan persisten, ekonomi XP/koin dan toko kostum "
              "berfungsi, serta audio lengkap dengan kontrol on/off dan volume. Projek tinggal diuji "
              "dan disempurnakan pada tahap akhir.")

    path = os.path.join(OUT_DIR, "Laporan_Progres_3.docx")
    doc.save(path)
    return path


# ============================================================
# LAPORAN 4
# ============================================================
def laporan4():
    doc = Document()
    setup(doc)
    title(doc, "LAPORAN PROGRES PROJEK 4", "Pengujian, Debugging, Penyelesaian & Rencana Lanjutan")
    info_table(doc)

    h1(doc, "1. Tujuan Laporan")
    para(doc, "Laporan akhir ini mendokumentasikan pengujian menyeluruh, bug yang ditemukan beserta "
              "solusinya, optimasi yang dilakukan, serta kesimpulan dan rencana pengembangan berikutnya.")

    h1(doc, "2. Metode Pengujian")
    bullet(doc, "Pengujian manual: menjalankan aplikasi di Chrome (flutter run -d chrome) dan mencoba tiap level.")
    bullet(doc, "Pengujian fungsional: memasang urutan blok yang benar dan salah untuk memastikan respons mesin permainan.")
    bullet(doc, "Pengujian persisten: menutup dan membuka kembali aplikasi untuk memastikan progres tersimpan.")
    bullet(doc, "Pengujian otomatis: menjalankan test bawaan melalui flutter test.")

    h1(doc, "3. Tabel Pengujian Per Level")
    table(doc,
          ["No", "Skenario", "Input Blok", "Hasil Diharapkan", "Status"],
          [
              ["1", "Level 1: sampai kambing", "maju, maju", "Robot sampai petak tujuan, 3 bintang", "[✅/❌]"],
              ["2", "Level 2: memutar batu", "kiri, maju, kanan, maju×3, kanan, maju", "Robot mengelilingi batu sampai tujuan", "[✅/❌]"],
              ["3", "Level 3: tebang pohon", "maju, maju, destroy", "Pohon ditebang, misi selesai", "[✅/❌]"],
              ["4", "Level 4: cukur domba", "kiri, maju, ulang, shear, kanan, maju, maju, shear", "Kedua domba dicukur", "[✅/❌]"],
              ["5", "Level 5: tebang 3 pohon", "destroy, maju, maju, destroy, maju, kiri, maju, destroy", "Semua pohon ditebang", "[✅/❌]"],
              ["6", "Level 6: bangun dinding", "place, maju, ulangi_blok(4)", "4 papan terpasang dengan 3 blok", "[✅/❌]"],
              ["7", "Level 7: sisa rumah", "place, maju, ulangi_blok(3), kiri, place, maju, place, maju", "Seluruh petak dinding tertutup", "[✅/❌]"],
          ],
          widths=[1.0, 3.2, 5.0, 4.3, 1.5])
    para(doc, "Isi kolom Status dengan ✅ bila lulus dan ❌ bila belum, lalu tambkan tangkapan layar bukti.", italic=True, color=GREY)

    h1(doc, "4. Pengujian Sistem Pendukung")
    table(doc,
          ["No", "Skenario", "Hasil Diharapkan", "Status"],
          [
              ["1", "Selesai level → tutup app → buka lagi", "Bintang, XP, koin tetap tersimpan", "[✅/❌]"],
              ["2", "Buka level yang belum selesai sebelumnya", "Level terkunci sampai level sebelumnya selesai", "[✅/❌]"],
              ["3", "Beli kostum di toko", "Koin berkurang, item menjadi milik & bisa dipakai", "[✅/❌]"],
              ["4", "Matikan suara lalu restart", "Suara tetap mati (preferensi tersimpan)", "[✅/❌]"],
              ["5", "Geser volume", "Volume musik berubah dan tersimpan", "[✅/❌]"],
          ],
          widths=[1.0, 5.0, 6.5, 2.5])

    h1(doc, "5. Bug yang Ditemukan dan Solusi")
    table(doc,
          ["Bug", "Penyebab", "Solusi"],
          [
              ["Gambar banner kosong saat aset belum ada.", "File gambar tidak ditemukan.", "Menambahkan errorBuilder yang menampilkan gradient cadangan."],
              ["Musik tidak bunyi pertama kali di web.", "Kebijakan autoplay browser.", "Menambah fungsi resume yang memutar ulang pada interaksi pertama."],
              ["Test widget gagal karena plugin audio.", "Plugin tidak tersedia di lingkungan test.", "Memeriksa FLUTTER_TEST dan melewati pemanggilan audio."],
              ["Label panjang terpotong tombol.", "Teks melebihi lebar tombol.", "Membungkus teks dengan Flexible + TextOverflow.ellipsis."],
              ["Balok loop menjalankan blok berlebih.", "Logika pengulangan keliru.", "Membatasi cakupan ulang sesuai jumlah balok yang diulang."],
          ],
          widths=[4.5, 4.5, 6.0])

    h1(doc, "6. Optimasi yang Dilakukan")
    bullet(doc, "Performa: menghindari penggambaran ulang yang tidak perlu (shouldRepaint = false).")
    bullet(doc, "UX: SnackBar untuk umpan balik, tombol Atur Ulang, status jelas saat gagal.")
    bullet(doc, "Kode: pemisahan modul (progress & audio) dan penggunaan konstanta bersama.")
    bullet(doc, "Tampilan: container berbatas agar rapi di layar lebar, angka gaya Indonesia (1.450).")

    h1(doc, "7. Kendala Keseluruhan dan Cara Mengatasinya")
    table(doc,
          ["Kendala", "Cara Mengatasi"],
          [
              ["Banyak fitur harus saling terhubung (UI, progres, audio).", "Menggunakan pola singleton dan penyalur perubahan ValueNotifier agar longgar dan mudah diuji."],
              ["Level bertambah rumit (multi-sasaran).", "Mendesain model data level generik sehingga tinggal menambah data."],
              ["Perilaku berbeda antar platform (web/Android).", "Menambahkan pengaman try-catch dan penanganan khusus web."],
          ],
          widths=[7.5, 7.5])

    h1(doc, "8. Hasil Akhir")
    bullet(doc, "Seluruh 7 level dapat dimainkan dari awal sampai akhir.")
    bullet(doc, "Sistem bintang, XP, koin, toko, dan audio berfungsi dan persisten.")
    bullet(doc, "Aplikasi berjalan di Chrome dan siap dikembangkan ke platform lain.")
    screenshot_placeholder(doc, "Gambar 4.1 — Tampilan final AlgoCraft (Beranda)")
    screenshot_placeholder(doc, "Gambar 4.2 — Layar Selesai Level (bintang, XP, koin)")

    h1(doc, "9. Kesimpulan")
    para(doc, "Projek AlgoCraft berhasil diselesaikan sesuai tujuan: game edukasi algoritma berbasis blok "
              "kode yang menarik, dengan tujuh level progresif, penilaian bintang, ekonomi XP/koin, "
              "toko kostum, dan dukungan audio. Seluruh fitur inti telah diuji dan berfungsi.")

    h1(doc, "10. Rencana Pengembangan Berikutnya")
    bullet(doc, "Menambah level dan bab baru (mis. percabangan/If dan fungsi).")
    bullet(doc, "Mode bebas (sandbox) tanpa batas blok untuk bereksperimen.")
    bullet(doc, "Leaderboard dan pencapaian (achievements).")
    bullet(doc, "Integrasi backend/leaderboard online serta mode multipemain.")
    bullet(doc, "Penerbitan ke Play Store dan penyesuaian aset suara/gambar tambahan.")

    path = os.path.join(OUT_DIR, "Laporan_Progres_4.docx")
    doc.save(path)
    return path


if __name__ == "__main__":
    paths = [laporan1(), laporan2(), laporan3(), laporan4()]
    for p in paths:
        print("Dibuat:", p)
