# AlgoCraft 1.2.0

Game edukasi algoritma berbasis blok kode untuk anak. Pemain menyusun perintah
seperti `gerak_maju()`, `belok_kanan()`, `ulangi_blok()`, `destroy()`, `shear()`,
dan `place()` untuk membantu robot Kodi menyelesaikan misi di tujuh level.

Versi **1.2.0** menambahkan aset visual dan animasi tanpa mengubah logika
permainan, progres, atau penilaian bintang.

## Fitur visual 1.2.0

- Delapan pose robot Kodi: diam, berjalan, lompat, menebang, mencukur, membangun,
  berhasil, dan gagal.
- Kostum yang sedang dipakai tampil sebagai overlay di arena (baju, topi, sepatu,
  syal, sayap, dan aksesoris).
- Animasi gerak, belok, dan lompat saat program dijalankan.
- Pohon tumbang, domba dicukur, dan papan bangunan muncul dengan animasi.
- Lima tema papan: Padang Rumput, Jalan Setapak, Hutan Cemara, Kandang Domba,
  dan Lahan Bangun.
- Transisi layar fade + slide serta perayaan piala, bintang, dan konfeti di layar
  hasil.

## Menjalankan

```bash
flutter pub get
flutter run -d chrome
```

## Pengujian

```bash
flutter analyze
flutter test
```

Hasil terbaru: `flutter analyze` tanpa masalah dan **21/21 pengujian lulus**
(`test/visual_test.dart`, `test/widget_test.dart`, `test/shop_test.dart`).

Tangkapan layar bukti dapat dibuat ulang dengan:

```bash
flutter test tool/screenshots_test.dart --update-goldens
```

Hasilnya tersimpan di `tool/screenshots/`.

## Laporan dan bukti

- Laporan mingguan: [`docs/laporan/laporan-mingguan-1.2.0.md`](docs/laporan/laporan-mingguan-1.2.0.md)
- Dokumen Word: [`docs/laporan/Laporan_Mingguan_AlgoCraft_1.2.0.docx`](docs/laporan/Laporan_Mingguan_AlgoCraft_1.2.0.docx)
- Tangkapan layar: [`docs/laporan/img/animasi/`](docs/laporan/img/animasi/)
- Hasil pengujian: [`docs/laporan/bukti/`](docs/laporan/bukti/)

## Struktur utama

| Berkas | Keterangan |
|---|---|
| `lib/main.dart` | Model level, blok perintah, mesin eksekusi, arena, dan layar hasil. |
| `lib/arena_visuals.dart` | Tema papan, pose robot, `paintKodi`, konfeti, transisi, dan galeri pose. |
| `lib/shop_screen.dart` | Toko kostum dan katalog item. |
| `lib/game_progress.dart` | Progres bintang, XP, koin, kostum, dan penyimpanan lokal. |
| `lib/game_audio.dart` | Musik latar dan efek suara. |
| `test/visual_test.dart` | Pengujian tema, pose, animasi, kostum, dan lebar layar. |
| `tool/screenshots_test.dart` | Generator tangkapan layar bukti. |
