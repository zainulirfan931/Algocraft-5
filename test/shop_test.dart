// Test alur utama Toko Kostum: layout portrait, filter kategori,
// pembelian, auto-equip, dan dialog preview.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:game_irfan/game_progress.dart';
import 'package:game_irfan/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  test('katalog Toko memiliki jumlah item sesuai kategori', () {
    int count(CostumeCategory category) =>
        kCostumeItems.where((item) => item.category == category).length;

    expect(count(CostumeCategory.baju), 10);
    expect(count(CostumeCategory.topi), 10);
    expect(count(CostumeCategory.sepatu), 8);
    expect(count(CostumeCategory.syal), 6);
    expect(count(CostumeCategory.sayap), 6);
    expect(count(CostumeCategory.aksesoris), 6);
    expect(kCostumeItems.length, 46);
    expect(
      kCostumeItems.map((item) => item.id).toSet().length,
      kCostumeItems.length,
    );
    expect(kCostumeById.length, kCostumeItems.length);
  });

  Future<void> openShop(
    WidgetTester tester, {
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final progress = GameProgress.instance;
    progress.reset();
    progress.changes.value++;

    await tester.pumpWidget(const AlgoCraftApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Toko'));
    await tester.pumpAndSettle();

    // Isi saldo setelah Beranda tidak lagi ter-mount agar header Beranda
    // tidak ikut diuji dengan font lebar milik widget test.
    progress.coins = 5000;
    progress.changes.value++;
    await tester.pumpAndSettle();
  }

  testWidgets('Toko tampil portrait, bisa filter dan membeli kostum', (
    tester,
  ) async {
    await openShop(tester);

    expect(find.text('Toko Kostum'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Katalog Kostum'), findsOneWidget);
    expect(find.text('Kaos Kode'), findsWidgets);
    expect(tester.takeException(), isNull);

    // Kategori bisa digeser horizontal sampai Aksesoris.
    await tester.drag(find.byType(ListView).first, const Offset(-320, 0));
    await tester.pumpAndSettle();
    expect(find.text('Aksesoris'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(ListView).first, const Offset(320, 0));
    await tester.pumpAndSettle();

    // Pindah ke kategori topi.
    await tester.tap(find.text('Topi'));
    await tester.pumpAndSettle();
    expect(find.text('Topi Petualang'), findsWidgets);
    expect(find.text('Topi Koki'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Beli item pertama kategori topi.
    final progress = GameProgress.instance;
    // Geser halaman ke bawah agar tombol beli berada di atas navigasi bawah.
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, -140),
    );
    await tester.pumpAndSettle();
    final beli = find.text('Beli').first;
    await tester.ensureVisible(beli);
    await tester.pumpAndSettle();
    await tester.tap(beli);
    await tester.pumpAndSettle();

    expect(progress.ownsItem('topi_petualang'), isTrue);
    expect(progress.isItemEquipped('topi', 'topi_petualang'), isTrue);
    expect(progress.coins, 5000 - 90);
    expect(find.text('Dipakai'), findsWidgets);
    expect(tester.takeException(), isNull);

    // Dialog preview karakter (panel preview ada di bagian atas halaman).
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, 400),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preview').first);
    await tester.pumpAndSettle();
    expect(find.text('Preview Karakter'), findsOneWidget);
    expect(find.text('TUTUP'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('TUTUP'));
    await tester.pumpAndSettle();

    // Lepas kostum dari panel preview.
    await tester.tap(find.byTooltip('Lepas kostum'));
    await tester.pumpAndSettle();
    expect(progress.isItemEquipped('topi', 'topi_petualang'), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Toko tidak overflow di layar 360x800', (tester) async {
    await openShop(tester, size: const Size(360, 800));
    expect(find.text('Toko Kostum'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Geser tab kategori secara horizontal untuk menjangkau Sepatu.
    await tester.drag(find.byType(ListView).first, const Offset(-150, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sepatu'));
    await tester.pumpAndSettle();
    expect(find.text('Sepatu Lari'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
