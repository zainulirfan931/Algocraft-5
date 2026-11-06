// Menghasilkan tangkapan layar bukti untuk laporan.
//
// Jalankan manual (tidak termasuk `flutter test` biasa):
//   flutter test tool/screenshots_test.dart --update-goldens
//
// Hasil PNG muncul di tool/screenshots/.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game_irfan/game_progress.dart';
import 'package:game_irfan/main.dart';

MissionLevel levelByNumber(int n) => kLevels.firstWhere((l) => l.number == n);

Future<void> capture(
  WidgetTester tester,
  String name,
  Widget home, {
  Size size = const Size(430, 900),
  Duration warmup = const Duration(milliseconds: 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),
      home: home,
    ),
  );
  await tester.pump(warmup);
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('screenshots/$name.png'),
  );
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
}

Future<void> _loadFont(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final file in files) {
    final bytes = File('tool/fonts/$file').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    // Lingkungan flutter_test memakai font Ahem (kotak-kotak). Untuk
    // tangkapan layar bukti, muat Roboto dan Material Icons yang asli.
    await _loadFont('Roboto', [
      'Roboto-Regular.ttf',
      'Roboto-Medium.ttf',
      'Roboto-Bold.ttf',
      'Roboto-Black.ttf',
    ]);
    await _loadFont('MaterialIcons', ['MaterialIcons-Regular.otf']);
  });

  setUp(() {
    // ignore: invalid_use_of_visible_for_testing_member
    GameProgress.instance.reset();
  });

  testWidgets('capture: pose robot', (tester) async {
    await capture(
      tester,
      '01_pose_robot',
      const Scaffold(
        backgroundColor: C.navy,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'POSE ROBOT KODI',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 12),
                KodiPoseStrip(height: 230),
                SizedBox(height: 8),
                Text(
                  'diam · berjalan · menebang · berhasil · gagal',
                  style: TextStyle(color: C.muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
      size: const Size(700, 420),
    );
  });

  for (final nomor in [1, 3, 4, 6]) {
    testWidgets('capture: arena level $nomor', (tester) async {
      await capture(
        tester,
        '02_arena_level_$nomor',
        ChallengeScreen(level: levelByNumber(nomor)),
        size: const Size(430, 900),
      );
    });
  }

  Widget frameStrip({
    required String title,
    required List<ArenaShowcase> frames,
  }) {
    return Scaffold(
      backgroundColor: C.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < frames.length; i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    SizedBox(
                      width: 320,
                      height: 260,
                      child: frames[i],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Frame diambil dari painter arena yang sama dengan permainan.',
                style: TextStyle(color: C.muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addBlock(WidgetTester tester, String code) async {
    final finder = find.text(code).last;
    await tester.ensureVisible(finder);
    await tester.pump();
    await tester.tap(finder);
    await tester.pump();
  }

  Future<void> captureLiveAction(
    WidgetTester tester,
    String name,
    int levelNumber,
    List<String> blocks,
    String statusFragment,
  ) async {
    tester.view.physicalSize = const Size(430, 1600);
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),
        home: ChallengeScreen(level: levelByNumber(levelNumber)),
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));
    for (final block in blocks) {
      await addBlock(tester, block);
    }
    final tombol = find.text('JALANKAN');
    await tester.ensureVisible(tombol);
    await tester.pump();
    await tester.tap(tombol);
    await tester.pump();
    for (var i = 0; i < 120; i++) {
      if (find.textContaining(statusFragment).evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 30));
    }
    // Ambil frame di tengah animasi aksi (620 ms).
    await tester.pump(const Duration(milliseconds: 260));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('screenshots/$name.png'),
    );
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  }

  testWidgets('capture: layar penuh animasi menebang', (tester) async {
    await captureLiveAction(
      tester,
      '20_live_menebang',
      3,
      ['gerak_maju()', 'gerak_maju()', 'destroy()'],
      'Menebang pohon',
    );
  });

  testWidgets('capture: layar penuh animasi mencukur', (tester) async {
    await captureLiveAction(
      tester,
      '21_live_mencukur',
      4,
      [
        'belok_kiri()',
        'gerak_maju()',
        'ulangi_blok()',
        'shear()',
        'belok_kanan()',
        'gerak_maju()',
        'gerak_maju()',
        'shear()',
      ],
      'Mencukur domba',
    );
  });

  testWidgets('capture: rangkaian animasi menebang', (tester) async {
    final lv = levelByNumber(3);
    await capture(
      tester,
      '05_animasi_menebang',
      frameStrip(
        title: 'ANIMASI MENEBANG POHON · HUTAN CEMARA',
        frames: [
          ArenaShowcase(
            level: lv,
            robotRow: 3,
            robotCol: 2,
            robotDir: 1,
            pose: RobotPose.chop,
            poseT: 0.15,
            activeTree: 0,
            frameLabel: '1. angkat kapak',
          ),
          ArenaShowcase(
            level: lv,
            robotRow: 3,
            robotCol: 2,
            robotDir: 1,
            pose: RobotPose.chop,
            poseT: 0.50,
            activeTree: 0,
            frameLabel: '2. ayunkan kapak',
          ),
          ArenaShowcase(
            level: lv,
            robotRow: 3,
            robotCol: 2,
            robotDir: 1,
            pose: RobotPose.chop,
            poseT: 0.85,
            activeTree: 0,
            frameLabel: '3. pohon tumbang',
          ),
        ],
      ),
      size: const Size(1060, 360),
      warmup: const Duration(milliseconds: 900),
    );
  });

  testWidgets('capture: rangkaian animasi mencukur', (tester) async {
    final lv = levelByNumber(4);
    await capture(
      tester,
      '06_animasi_mencukur',
      frameStrip(
        title: 'ANIMASI MENCUKUR DOMBA · KANDANG DOMBA',
        frames: [
          ArenaShowcase(
            level: lv,
            robotRow: 0,
            robotCol: 0,
            robotDir: 1,
            pose: RobotPose.shear,
            poseT: 0.15,
            activeSheep: 0,
            frameLabel: '1. siapkan gunting',
          ),
          ArenaShowcase(
            level: lv,
            robotRow: 0,
            robotCol: 0,
            robotDir: 1,
            pose: RobotPose.shear,
            poseT: 0.50,
            activeSheep: 0,
            frameLabel: '2. cukur wol',
          ),
          ArenaShowcase(
            level: lv,
            robotRow: 0,
            robotCol: 0,
            robotDir: 1,
            pose: RobotPose.shear,
            poseT: 0.85,
            activeSheep: 0,
            frameLabel: '3. wol terlepas',
          ),
        ],
      ),
      size: const Size(1060, 360),
      warmup: const Duration(milliseconds: 900),
    );
  });

  testWidgets('capture: rangkaian animasi memasang papan', (tester) async {
    final lv = levelByNumber(6);
    await capture(
      tester,
      '08_animasi_papan',
      frameStrip(
        title: 'ANIMASI MEMASANG PAPAN · LAHAN BANGUN',
        frames: [
          ArenaShowcase(
            level: lv,
            robotRow: 1,
            robotCol: 0,
            robotDir: 2,
            pose: RobotPose.build,
            poseT: 0.15,
            placed: const [
              [1, 0, 0],
            ],
            activePlank: '2,0',
            activePlankMat: 0,
            frameLabel: '1. angkat papan',
          ),
          ArenaShowcase(
            level: lv,
            robotRow: 1,
            robotCol: 0,
            robotDir: 2,
            pose: RobotPose.build,
            poseT: 0.50,
            placed: const [
              [1, 0, 0],
            ],
            activePlank: '2,0',
            activePlankMat: 0,
            frameLabel: '2. pasang papan',
          ),
          ArenaShowcase(
            level: lv,
            robotRow: 1,
            robotCol: 0,
            robotDir: 2,
            pose: RobotPose.build,
            poseT: 0.85,
            placed: const [
              [1, 0, 0],
            ],
            activePlank: '2,0',
            activePlankMat: 0,
            frameLabel: '3. papan terpasang',
          ),
        ],
      ),
      size: const Size(1060, 360),
      warmup: const Duration(milliseconds: 900),
    );
  });

  testWidgets('capture: tema papan lima lokasi', (tester) async {
    final levels = [1, 2, 3, 4, 6].map(levelByNumber).toList();
    await capture(
      tester,
      '07_tema_papan',
      Scaffold(
        backgroundColor: C.navy,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TEMA PAPAN TIAP LOKASI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < levels.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      SizedBox(
                        width: 236,
                        height: 240,
                        child: ArenaShowcase(
                          level: levels[i],
                          frameLabel: levels[i].location,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Padang Rumput · Hutan Cemara · Kandang Domba · Lahan Bangun',
                  style: TextStyle(color: C.muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
      size: const Size(1270, 340),
      warmup: const Duration(milliseconds: 900),
    );
  });

  testWidgets('capture: layar hasil', (tester) async {
    await capture(
      tester,
      '03_layar_hasil',
      LevelCompleteScreen(level: levelByNumber(6), stars: 3),
      size: const Size(430, 900),
      warmup: const Duration(milliseconds: 700),
    );
  });

  testWidgets('capture: kostum di arena', (tester) async {
    final prog = GameProgress.instance;
    await prog.recordWin(number: 1, stars: 3, xpGain: 50, coinGain: 300);
    await prog.buyItem('baju_kaos', 80);
    await prog.equipItem('baju', 'baju_kaos');
    await prog.buyItem('topi_petualang', 90);
    await prog.equipItem('topi', 'topi_petualang');
    await prog.buyItem('syal_biru', 60);
    await prog.equipItem('syal', 'syal_biru');

    await capture(
      tester,
      '04_robot_berkostum',
      ChallengeScreen(level: levelByNumber(1)),
      size: const Size(430, 900),
    );
  });
}
