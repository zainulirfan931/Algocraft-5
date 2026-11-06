// Pengujian visual & animasi AlgoCraft 1.2.0.
//
// Fokus pengujian ini adalah memastikan penambahan tema, pose, dan animasi
// tidak merusak tata letak maupun hasil eksekusi program.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game_irfan/game_progress.dart';
import 'package:game_irfan/main.dart';

MissionLevel levelByNumber(int n) => kLevels.firstWhere((l) => l.number == n);

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    GameProgress.instance.reset();
  });

  Future<void> addBlock(WidgetTester tester, String code) async {
    final finder = find.text(code).last;
    await tester.ensureVisible(finder);
    await tester.pump();
    await tester.tap(finder);
    await tester.pump();
  }

  Future<void> runUntilSelesai(WidgetTester tester) async {
    final tombol = find.text('JALANKAN');
    await tester.ensureVisible(tombol);
    await tester.pump();
    await tester.tap(tombol);
    for (var i = 0; i < 300; i++) {
      if (find.text('HORE! MISI BERHASIL!').evaluate().isNotEmpty) return;
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  test('tema papan berbeda untuk lima lokasi', () {
    final lokasi = <String>[
      'Padang Rumput',
      'Jalan Setapak',
      'Hutan Cemara',
      'Kandang Domba',
      'Lahan Bangun',
    ];
    final themes = lokasi.map(BoardTheme.of).toList();
    expect(themes.map((t) => t.name).toSet().length, 5);
    expect(themes.map((t) => t.top.toARGB32()).toSet().length, 5);
    expect(themes.map((t) => t.decorKind).toSet().length, 5);
    // Level 5–7 berada di kawasan pembangunan yang sama.
    expect(BoardTheme.of('Lahan Kosong').name, BoardTheme.of('Lahan Bangun').name);
  });

  test('pose robot mencakup diam, jalan, tebang, berhasil, gagal', () {
    const wajib = {
      RobotPose.idle,
      RobotPose.walk,
      RobotPose.chop,
      RobotPose.happy,
      RobotPose.sad,
    };
    expect(RobotPose.values.toSet().containsAll(wajib), isTrue);
  });

  for (final lebar in [320.0, 360.0, 430.0, 768.0]) {
    testWidgets('arena level 1 tidak overflow pada lebar $lebar', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = Size(lebar, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(home: ChallengeScreen(level: levelByNumber(1))),
      );
      await tester.pump(const Duration(milliseconds: 120));
      expect(tester.takeException(), isNull);
      expect(find.textContaining('Lv 1'), findsWidgets);
    });
  }

  testWidgets('tema papan dipakai sesuai lokasi level', (
    WidgetTester tester,
  ) async {
    for (final nomor in [3, 4, 6]) {
      await tester.pumpWidget(
        MaterialApp(home: ChallengeScreen(level: levelByNumber(nomor))),
      );
      await tester.pump(const Duration(milliseconds: 120));
      expect(tester.takeException(), isNull);
      expect(find.textContaining('Lv $nomor'), findsWidgets);
    }
  });

  testWidgets('level 1 tetap selesai dengan animasi aktif', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: ChallengeScreen(level: levelByNumber(1))),
    );
    await addBlock(tester, 'gerak_maju()');
    await addBlock(tester, 'gerak_maju()');
    await runUntilSelesai(tester);

    expect(find.text('HORE! MISI BERHASIL!'), findsOneWidget);
    expect(GameProgress.instance.starsOf(1), 3);
  });

  testWidgets('animasi menebang tetap menyelesaikan level 3', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: ChallengeScreen(level: levelByNumber(3))),
    );
    await addBlock(tester, 'gerak_maju()');
    await addBlock(tester, 'gerak_maju()');
    await addBlock(tester, 'destroy()');
    await runUntilSelesai(tester);

    expect(find.text('HORE! MISI BERHASIL!'), findsOneWidget);
    expect(GameProgress.instance.starsOf(3), 3);
  });

  testWidgets('animasi mencukur tetap menyelesaikan level 4', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: ChallengeScreen(level: levelByNumber(4))),
    );
    await addBlock(tester, 'belok_kiri()');
    await addBlock(tester, 'gerak_maju()');
    await addBlock(tester, 'ulangi_blok()');
    await addBlock(tester, 'shear()');
    await addBlock(tester, 'belok_kanan()');
    await addBlock(tester, 'gerak_maju()');
    await addBlock(tester, 'gerak_maju()');
    await addBlock(tester, 'shear()');
    await runUntilSelesai(tester);

    expect(find.text('HORE! MISI BERHASIL!'), findsOneWidget);
    expect(GameProgress.instance.starsOf(4), 3);
  });

  testWidgets('kostum terpasang tampil di arena tanpa galat', (
    WidgetTester tester,
  ) async {
    final prog = GameProgress.instance;
    await prog.recordWin(number: 1, stars: 3, xpGain: 50, coinGain: 200);
    expect(await prog.buyItem('topi_petualang', 90), isTrue);
    await prog.equipItem('topi', 'topi_petualang');
    expect(prog.equippedId('topi'), 'topi_petualang');

    await tester.pumpWidget(
      MaterialApp(home: ChallengeScreen(level: levelByNumber(1))),
    );
    await tester.pump(const Duration(milliseconds: 120));
    expect(tester.takeException(), isNull);
  });

  testWidgets('layar hasil menampilkan perayaan pada layar sempit', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: LevelCompleteScreen(level: levelByNumber(6), stars: 3),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));
    expect(tester.takeException(), isNull);
    expect(find.text('HORE! MISI BERHASIL!'), findsOneWidget);
    expect(find.text('Level 6: Dinding Pertama'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('galeri pose Kodi dibangun tanpa galat aset', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xFF0B1533),
          body: Center(child: KodiPoseStrip()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));
    expect(tester.takeException(), isNull);
    expect(find.text('DIAM'), findsOneWidget);
    expect(find.text('MENEBANG'), findsOneWidget);
    expect(find.text('BERHASIL'), findsOneWidget);
  });
}
