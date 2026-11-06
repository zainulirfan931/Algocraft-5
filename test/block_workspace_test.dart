import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_irfan/game_progress.dart';
import 'package:game_irfan/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

MissionLevel levelByNumber(int n) => kLevels.firstWhere((l) => l.number == n);

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  setUp(() {
    GameProgress.instance.reset();
  });

  testWidgets('drag block dari palet ke workspace', (tester) async {
    tester.view.physicalSize = const Size(430, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(home: ChallengeScreen(level: levelByNumber(1))),
    );
    await tester.pump(const Duration(milliseconds: 500));

    final palette = find.text('gerak_maju()').last;
    final empty = find.text('Seret blok ke area ini');
    expect(palette, findsOneWidget);
    expect(empty, findsOneWidget);

    final from = tester.getCenter(palette);
    final to = tester.getCenter(empty);
    await tester.dragFrom(from, to - from);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('1 / 2 balok'), findsOneWidget);
  });

  testWidgets('drop pada bagian atas blok menyisipkan di depannya', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(home: ChallengeScreen(level: levelByNumber(2))),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Tambah satu blok maju ke workspace kosong.
    final empty = find.text('Seret blok ke area ini');
    final majuPalette = find.text('gerak_maju()').last;
    await tester.dragFrom(
      tester.getCenter(majuPalette),
      tester.getCenter(empty) - tester.getCenter(majuPalette),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('1 / 8 balok'), findsOneWidget);

    // Jatuhkan belok_kanan() di bagian atas blok maju -> sisip di depannya.
    final kananPalette = find.text('belok_kanan()').last;
    final majuWorkspace = find.text('gerak_maju()').first;
    final target =
        tester.getTopLeft(majuWorkspace) +
        Offset(tester.getSize(majuWorkspace).width / 2, 4);
    final from = tester.getCenter(kananPalette);
    await tester.dragFrom(from, target - from);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('2 / 8 balok'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('belok_kanan()').first).dy,
      lessThan(tester.getTopLeft(find.text('gerak_maju()').first).dy),
    );
  });

  testWidgets('blok workspace bisa dipindah dan diurutkan ulang', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(home: ChallengeScreen(level: levelByNumber(2))),
    );
    await tester.pump(const Duration(milliseconds: 500));

    Future<void> addBlock(String code) async {
      final finder = find.text(code).last;
      await tester.ensureVisible(finder);
      await tester.pump();
      await tester.tap(finder);
      await tester.pump(const Duration(milliseconds: 250));
    }

    await addBlock('gerak_maju()');
    await addBlock('belok_kanan()');
    await addBlock('belok_kiri()');
    expect(find.text('3 / 8 balok'), findsOneWidget);

    // Pindahkan belok_kiri() dari urutan ketiga ke paling atas.
    final kiriWorkspace = find.text('belok_kiri()').first;
    final target =
        tester.getTopLeft(find.text('gerak_maju()').first) +
        Offset(tester.getSize(find.text('gerak_maju()').first).width / 2, 4);
    final from = tester.getCenter(kiriWorkspace);
    await tester.dragFrom(from, target - from);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('3 / 8 balok'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('belok_kiri()').first).dy,
      lessThan(tester.getTopLeft(find.text('gerak_maju()').first).dy),
    );
    expect(
      tester.getTopLeft(find.text('gerak_maju()').first).dy,
      lessThan(tester.getTopLeft(find.text('belok_kanan()').first).dy),
    );
  });

  testWidgets('blok bisa dihapus dari workspace lewat tombol silang', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(home: ChallengeScreen(level: levelByNumber(1))),
    );
    await tester.pump(const Duration(milliseconds: 500));

    final palette = find.text('gerak_maju()').last;
    await tester.tap(palette);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('1 / 2 balok'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('0 / 2 balok'), findsOneWidget);
    expect(find.text('Seret blok ke area ini'), findsOneWidget);
  });

  testWidgets('drag tetap bekerja saat halaman bisa di-scroll', (tester) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(home: ChallengeScreen(level: levelByNumber(1))),
    );
    await tester.pump(const Duration(milliseconds: 500));

    final palette = find.text('gerak_maju()').last;
    await tester.ensureVisible(palette);
    await tester.pump(const Duration(milliseconds: 300));

    final empty = find.text('Seret blok ke area ini');
    final from = tester.getCenter(palette);
    final to = tester.getCenter(empty);
    await tester.dragFrom(from, to - from);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('1 / 2 balok'), findsOneWidget);
  });
}
