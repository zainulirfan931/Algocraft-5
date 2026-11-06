import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'game_audio.dart';
import 'game_progress.dart';

part 'arena_visuals.dart';
part 'shop_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GameAudio.instance.init(); // musik latar + preferensi suara
  GameProgress.instance.init(); // progres bintang/XP/koin
  runApp(const AlgoCraftApp());
}

/// Pemisah ribuan gaya Indonesia: 1450 → "1.450".
String _groupNum(int n) {
  final s = n.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

// ============================================================
// COLOR PALETTE
// ============================================================
class C {
  // Core
  static const bg = Color(0xFFF8F6F0); // off-white main bg
  static const darkBg = Color(0xFF1A1A2E); // dark charcoal outer bg
  static const card = Color(0xFFFFFFFF); // pure white cards
  static const peach = Color(0xFFFFE7D1); // peach/cream cards
  static const peachLight = Color(0xFFFFF3E0);

  // Primary / Secondary
  static const green = Color(0xFF3BA10B);
  static const greenDark = Color(0xFF2D7A08);
  static const blue = Color(0xFF1E9BF0);
  static const blueDark = Color(0xFF1577C2);

  // Accent
  static const gold = Color(0xFFFFC107);
  static const goldDark = Color(0xFFC8920A);
  static const orange = Color(0xFFFFA726);
  static const red = Color(0xFFE53935);
  static const pink = Color(0xFFFF9BC1); // wool / domba accent
  static const purple = Color(0xFF7C4DFF);

  // Text
  static const textDark = Color(0xFF2D2D2D);
  static const textLight = Color(0xFF666666);
  static const textWhite = Color(0xFFFFFFFF);

  // Dark theme surfaces
  static const outerBg = Color(0xFF08080F); // outside the app frame
  static const muted = Color(0xFF8FA3CC); // secondary text on dark
  static const dim = Color(0xFF6E82AE); // inactive / disabled text

  // ── Mission Stage (dark navy theme) ──
  static const navy = Color(0xFF0B1533); // main dark bg
  static const navyDeep = Color(0xFF070E24); // deeper shade
  static const navyCard = Color(0xFF16224A); // panel surface
  static const navyCard2 = Color(0xFF1E2E5C); // raised surface
  static const navyLine = Color(0xFF2C3E73); // hairline / border
  static const cyan = Color(0xFF38E1F0); // cyan accent
  static const cyanSoft = Color(0xFF9BF0F7);
  static const orangePop = Color(0xFFFF8A2B); // primary action orange
  static const orangeDeep = Color(0xFFE96A0C);
  static const boardTop = Color(0xFF1E3D2B); // dark green board
  static const boardTop2 = Color(0xFF255236); // alternating tile
  static const boardSide = Color(0xFF122318);
  static const boardEdge = Color(0xFF3E7A52);

  // Voxel island
  static const grass = Color(0xFF7CB342);
  static const grassDark = Color(0xFF558B2F);
  static const dirt = Color(0xFF8D6E63);
  static const dirtDark = Color(0xFF5D4037);
  static const stone = Color(0xFF9E9E9E);
  static const sky = Color(0xFF87CEEB);
  static const skyLight = Color(0xFFB3E5FC);
}

// ============================================================
// APP ROOT
// ============================================================
class AlgoCraftApp extends StatelessWidget {
  const AlgoCraftApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'AlgoCraft',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: C.darkBg,
      colorScheme: ColorScheme.fromSeed(seedColor: C.green),
      fontFamily: 'Roboto',
    ),
    home: const MainShell(),
  );
}

// ============================================================
// DOT PATTERN BACKGROUND
// ============================================================
class DotPattern extends StatelessWidget {
  const DotPattern({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DotPainter(), size: Size.infinite);
  }
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: .04);
    const spacing = 24.0;
    const radius = 1.2;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// MAIN SHELL — dark bg + white phone container
// ============================================================
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onTab: (i) => setState(() => index = i)),
      const LevelMapScreen(),
      const CustomizeScreen(),
    ];

    return Scaffold(
      backgroundColor: C.outerBg,
      body: Stack(
        children: [
          const Positioned.fill(child: DotPattern()),
          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 430),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: C.navy,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .5),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: C.cyan.withValues(alpha: .12),
                      blurRadius: 44,
                      spreadRadius: -8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: pages[index],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              // Samakan lebar navigasi dengan container utama (maxWidth 430).
              constraints: const BoxConstraints(maxWidth: 430),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF070C1D),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: C.navyLine),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .45),
                      blurRadius: 18,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _navItem(0, Icons.home_rounded, 'Beranda'),
                    _navItem(1, Icons.map_rounded, 'Peta'),
                    _navItem(2, Icons.storefront_rounded, 'Toko'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int i, IconData ic, String label) {
    final active = index == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => index = i),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: active ? C.cyan.withValues(alpha: .13) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(ic, size: 20, color: active ? C.cyan : C.dim),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  letterSpacing: .2,
                  fontWeight: active ? FontWeight.w900 : FontWeight.w700,
                  color: active ? C.cyan : C.dim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SHARED WIDGETS
// ============================================================
class BigButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final VoidCallback onTap;
  final double? height;
  const BigButton(
    this.label,
    this.color,
    this.onTap, {
    this.icon,
    this.height,
    super.key,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: height ?? 52,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Color.lerp(color, Colors.black, 0.25)!,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 8),
          ],
          // Flexible + ellipsis: label panjang tetap muat walau font fallback
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class StatChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const StatChip(this.icon, this.color, this.text, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: C.navyCard,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: C.navyLine),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 15),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

class BlockTile extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;
  const BlockTile(this.text, this.color, this.icon, {this.onTap, super.key});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.lerp(color, Colors.black, 0.15)!,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ============================================================
// 1. HOME SCREEN
// ============================================================
class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onTab;
  const HomeScreen({required this.onTab, super.key});

  void _snack(BuildContext c, String m) {
    ScaffoldMessenger.of(c).showSnackBar(
      SnackBar(
        content: Text(m),
        backgroundColor: C.navyCard2,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _startMission(BuildContext c) {
    Navigator.push(c, playfulRoute(ChallengeScreen(level: kLevels[0])));
  }

  /// Jumlah level yang sudah selesai (dapat minimal 1 bintang).
  int get _doneLevels =>
      kLevels.where((l) => GameProgress.instance.starsOf(l.number) > 0).length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(context),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _heroBanner(),
                const SizedBox(height: 22),
                _welcome(),
                const SizedBox(height: 20),
                _missionCard(context),
                const SizedBox(height: 26),
                ValueListenableBuilder<int>(
                  valueListenable: GameProgress.instance.changes,
                  builder: (_, _, _) => _learningProgress(context),
                ),
                const SizedBox(height: 14),
                _communityCard(),
                const SizedBox(height: 14),
                _soundCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── HEADER: XP, energi, koin, speaker, avatar ──
  Widget _header(BuildContext c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [C.orangePop, C.orangeDeep],
              ),
              borderRadius: BorderRadius.circular(11),
              boxShadow: [
                BoxShadow(
                  color: C.orangePop.withValues(alpha: .35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ValueListenableBuilder<int>(
              valueListenable: GameProgress.instance.changes,
              builder: (_, _, _) => Text(
                '${GameProgress.instance.xp} XP',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: .3,
                ),
              ),
            ),
          ),
          const SizedBox(width: 7),
          _pill(Icons.bolt_rounded, C.cyan, '100'),
          const SizedBox(width: 7),
          ValueListenableBuilder<int>(
            valueListenable: GameProgress.instance.changes,
            builder: (_, _, _) => _pill(
              Icons.monetization_on_rounded,
              C.gold,
              _groupNum(GameProgress.instance.coins),
            ),
          ),
          const Spacer(),
          ValueListenableBuilder<int>(
            valueListenable: GameAudio.instance.changes,
            builder: (c, _, _) => _roundIcon(
              GameAudio.instance.soundOn
                  ? Icons.volume_up_rounded
                  : Icons.volume_off_rounded,
              () => GameAudio.instance.setSoundOn(!GameAudio.instance.soundOn),
            ),
          ),
          const SizedBox(width: 9),
          GestureDetector(
            onTap: () => onTab(2),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [C.cyan, C.blue]),
                boxShadow: [
                  BoxShadow(
                    color: C.cyan.withValues(alpha: .35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/karakter_kepala.png',
                  fit: BoxFit.contain,
                  width: 36,
                  height: 36,
                  errorBuilder: (_, _, _) =>
                      const CustomPaint(painter: _KodiFacePainter()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(IconData ic, Color col, String txt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: C.navyCard,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: C.navyLine),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ic, size: 14, color: col),
          const SizedBox(width: 4),
          Text(
            txt,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundIcon(IconData ic, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: C.navyCard,
          shape: BoxShape.circle,
          border: Border.all(color: C.navyLine),
        ),
        child: Icon(ic, size: 17, color: C.cyanSoft),
      ),
    );
  }

  // ── HERO BANNER ──
  Widget _heroBanner() {
    return Container(
      height: 238,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: C.blue.withValues(alpha: .32),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // gambar banner beranda
            Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1878D4),
                      Color(0xFF4FB8F5),
                      Color(0xFFAEE8FF),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // label pill
            Positioned(
              left: 16,
              top: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: C.cyan,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: C.cyan.withValues(alpha: .5),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'KODI - Sobat Robot',
                  style: TextStyle(
                    color: C.navyDeep,
                    fontWeight: FontWeight.w900,
                    fontSize: 10.5,
                    letterSpacing: .2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── SAPAN ──
  Widget _welcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Halo Sobat Kode! 🚀',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pulau logika menunggumu. Siap melanjutkan petualangan algoritma hari ini?',
          style: const TextStyle(
            fontSize: 12.5,
            color: C.muted,
            height: 1.45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ── MISI AKTIF ──
  Widget _missionCard(BuildContext c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1C2C5C), Color(0xFF121D42)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: C.navyLine),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [C.cyan, Color(0xFF2AA8FF)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: C.cyan.withValues(alpha: .35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.terminal_rounded,
                  color: C.navyDeep,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MISI AKTIF',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: C.cyan,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Level ${kLevels[0].number}: Menuju Kambing',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: C.orangePop.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Text(
                  '85% Selesai',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    color: C.orangePop,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _bar(.85),
          const SizedBox(height: 16),
          BigButton(
            'LANJUTKAN MISI SEKARANG',
            C.orangePop,
            () => _startMission(c),
            icon: Icons.play_arrow_rounded,
            height: 54,
          ),
        ],
      ),
    );
  }

  Widget _bar(double v) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: C.navyDeep.withValues(alpha: .85),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: v,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [C.cyan, Color(0xFF2AA8FF)],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: C.cyan.withValues(alpha: .5), blurRadius: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── KARTU SUARA (on/off + volume) ──
  Widget _soundCard() {
    return ValueListenableBuilder<int>(
      valueListenable: GameAudio.instance.changes,
      builder: (context, _, _) {
        final audio = GameAudio.instance;
        final pct = (audio.volume * 100).round();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
          decoration: BoxDecoration(
            color: C.navyCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: C.navyLine),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => GameAudio.instance.setSoundOn(!audio.soundOn),
                    child: Icon(
                      audio.soundOn
                          ? Icons.volume_up_rounded
                          : Icons.volume_off_rounded,
                      size: 20,
                      color: audio.soundOn ? C.cyan : Colors.white38,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Musik & Suara',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '$pct%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: C.cyanSoft,
                    ),
                  ),
                ],
              ),
              Slider(
                value: audio.volume,
                onChanged: (v) => GameAudio.instance.setVolume(v),
                activeColor: C.cyan,
                inactiveColor: C.navyCard2,
              ),
            ],
          ),
        );
      },
    );
  }

  // ── PROGRES BELAJAR ──
  Widget _learningProgress(BuildContext c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: C.cyan.withValues(alpha: .14),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                color: C.cyan,
                size: 19,
              ),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'Progres Belajar',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => onTab(1),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: C.navyCard,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: C.navyLine),
                ),
                child: const Text(
                  '12 / 15',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: C.cyanSoft,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _chapterUnlocked(c),
        const SizedBox(height: 12),
        _chapterLocked(c),
      ],
    );
  }

  Widget _chapterUnlocked(BuildContext c) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.navyCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.navyLine),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .28),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _chapterBadge(Icons.directions_walk_rounded, C.green),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BAB 1',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: C.cyan,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Gerak & Arah',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Logika blok maju, belok, & langkah',
                      style: TextStyle(fontSize: 11.5, color: C.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: C.green.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  '$_doneLevels/${kLevels.length} Tuntas',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF6EE7A8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _bar(kLevels.isEmpty ? 0 : _doneLevels / kLevels.length),
        ],
      ),
    );
  }

  Widget _chapterLocked(BuildContext c) {
    return GestureDetector(
      onTap: () => _snack(c, 'Selesaikan Bab 1 dulu untuk membuka bab ini!'),
      child: Opacity(
        opacity: .6,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: C.navyCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: C.navyLine),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _chapterBadge(Icons.lock_rounded, C.dim),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'BAB 2',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            color: C.dim,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Perulangan (Loop)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Otomatisasi blok kode berulang',
                          style: TextStyle(fontSize: 11.5, color: C.muted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .07),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Text(
                      'Terkunci',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        color: C.dim,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _bar(.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chapterBadge(IconData ic, Color col) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [col, Color.lerp(col, Colors.black, .28)!],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(ic, color: Colors.white, size: 20),
    );
  }

  // ── KOMUNITAS ALGO ──
  Widget _communityCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF17264F), Color(0xFF111C3E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.navyLine),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [C.cyan, Color(0xFF2AA8FF)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: C.cyan.withValues(alpha: .3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: C.navyDeep,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'KOMUNITAS ALGO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: C.cyan,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '8.420 Sobat Kode telah menyelesaikan petualangan algoritma bersama!',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: C.muted,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// KODI — avatar face (header)
// ============================================================
class _KodiFacePainter extends CustomPainter {
  const _KodiFacePainter();
  @override
  void paint(Canvas canvas, Size size) {
    final u = size.width;
    final cx = u / 2, cy = size.height / 2;
    final screen = Paint()..color = const Color(0xFF0E1836);
    final glow = Paint()..color = const Color(0xFF8FF3FF);

    canvas.drawCircle(Offset(cx, cy), u * .36, screen);
    canvas.drawCircle(Offset(cx - u * .13, cy - u * .05), u * .075, glow);
    canvas.drawCircle(Offset(cx + u * .13, cy - u * .05), u * .075, glow);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, cy + u * .06),
        width: u * .30,
        height: u * .20,
      ),
      0,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFF8FF3FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = u * .045
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _KodiFacePainter oldDelegate) => false;
}

// ============================================================
// MISSION COMMANDS
// ============================================================
class Cmd {
  final String id;
  final String label;
  final String sub;
  final String code;
  final IconData icon;
  final Color color;
  const Cmd(this.id, this.label, this.sub, this.code, this.icon, this.color);
}

const kCmds = <String, Cmd>{
  'maju': Cmd(
    'maju',
    'Gerak Maju',
    'langkah: 1',
    'gerak_maju()',
    Icons.arrow_upward_rounded,
    C.cyan,
  ),
  'maju2': Cmd(
    'maju2',
    'Gerak Maju',
    'langkah: 2',
    'gerak_maju(2)',
    Icons.directions_walk_rounded,
    Color(0xFF7FD8FF),
  ),
  'lompat': Cmd(
    'lompat',
    'Lompat',
    'langkah: 2',
    'lompat()',
    Icons.trending_up_rounded,
    Color(0xFFB7A1FF),
  ),
  'kanan': Cmd(
    'kanan',
    'Belok Kanan',
    'putaran: 90°',
    'belok_kanan()',
    Icons.turn_right_rounded,
    Color(0xFF6EE7A8),
  ),
  'kiri': Cmd(
    'kiri',
    'Belok Kiri',
    'putaran: 90°',
    'belok_kiri()',
    Icons.turn_left_rounded,
    Color(0xFF57D98F),
  ),
  'ulang': Cmd(
    'ulang',
    'Ulangi',
    '2x lagi blok sebelumnya',
    'ulangi_blok()',
    Icons.repeat_rounded,
    Color(0xFFFFD166),
  ),
  'ulang3': Cmd(
    'ulang3',
    'Ulangi 3x',
    'jalankan 3x blok di atasnya',
    'ulangi_blok(3)',
    Icons.repeat_rounded,
    Color(0xFFFFB74D),
  ),
  'ulang4': Cmd(
    'ulang4',
    'Ulangi 4x',
    'jalankan 4x blok di atasnya',
    'ulangi_blok(4)',
    Icons.repeat_rounded,
    Color(0xFFFFE082),
  ),
  'destroy': Cmd(
    'destroy',
    'Tebang Pohon',
    'damping pohon',
    'destroy()',
    Icons.cut_rounded,
    Color(0xFF8BD450),
  ),
  'shear': Cmd(
    'shear',
    'Cukur Domba',
    'kumpulkan wool',
    'shear()',
    Icons.content_cut_rounded,
    Color(0xFFFF9BC1),
  ),
  'place': Cmd(
    'place',
    'Letakkan Kayu',
    'papan kayu',
    'place("kayu")',
    Icons.carpenter_rounded,
    Color(0xFFE0A05A),
  ),
  'placeBatu': Cmd(
    'placeBatu',
    'Letakkan Batu',
    'batu bata',
    'place("batu")',
    Icons.foundation_rounded,
    Color(0xFF9FB0CC),
  ),
  'tunggu': Cmd(
    'tunggu',
    'Tunggu',
    '1 detik',
    'tunggu(1)',
    Icons.hourglass_bottom_rounded,
    Color(0xFF9AA8C7),
  ),
};

/// Balok pengulang: 'ulang' mengulang 1 balok sebelumnya,
/// 'ulang3' / 'ulang4' mengulang seluruh kelompok balok di atasnya.
bool _isRepeat(String id) => id == 'ulang' || id == 'ulang3' || id == 'ulang4';

/// Berapa kali balok pengulang [id] menjalankan tugasnya.
int _repeatTimes(String id) => id == 'ulang' ? 2 : (id == 'ulang3' ? 3 : 4);

// Arah: 0 = atas, 1 = kanan, 2 = bawah, 3 = kiri
const kDr = [-1, 0, 1, 0];
const kDc = [0, 1, 0, -1];

// ============================================================
// MISSION LEVEL MODEL
// ============================================================
class MissionLevel {
  final int number;
  final String title;
  final String tabTitle; // label ringkas di tab game
  final String location;
  final String difficulty;
  final String mission;
  final String hint;
  final String quickTip;
  final List<String> palette; // id blok yang boleh dipakai
  final int capacity; // maksimum jumlah blok
  final int par; // jumlah blok minimum untuk 3 bintang (0 = jarak langsung)
  final int starTarget;
  final int
  boardSize; // sisi papan (default 4, level membangun bisa lebih besar)
  final int startRow, startCol, startDir;
  final int goalRow, goalCol;
  final List<List<int>> rocks; // batu penghalang
  final List<List<int>> bushes; // dekorasi semak
  final List<List<int>>
  trees; // pohon yang bisa ditebang (sasaran blok destroy)
  final List<List<int>> sheep; // domba yang bisa dicukur (sasaran blok shear)
  final List<List<int>> walls; // petak area bangunan (sasaran blok place)
  final List<String> tips;
  final int reward;

  const MissionLevel({
    required this.number,
    required this.title,
    this.tabTitle = '',
    required this.location,
    this.difficulty = 'TINGKAT MUDAH',
    required this.mission,
    this.hint = '',
    this.quickTip = '',
    required this.palette,
    this.capacity = 8,
    this.par = 0,
    this.starTarget = 3,
    this.boardSize = 4,
    required this.startRow,
    required this.startCol,
    required this.startDir,
    required this.goalRow,
    required this.goalCol,
    required this.rocks,
    this.bushes = const [],
    this.trees = const [],
    this.sheep = const [],
    this.walls = const [],
    required this.tips,
    required this.reward,
  });

  bool rockAt(int r, int c) => rocks.any((p) => p[0] == r && p[1] == c);

  bool treeAt(int r, int c) => trees.any((p) => p[0] == r && p[1] == c);

  /// Indeks pohon di petak (r, c), atau -1 kalau tidak ada pohon.
  int treeIndexAt(int r, int c) {
    for (var i = 0; i < trees.length; i++) {
      if (trees[i][0] == r && trees[i][1] == c) return i;
    }
    return -1;
  }

  /// Indeks domba di petak (r, c), atau -1 kalau tidak ada domba.
  int sheepIndexAt(int r, int c) {
    for (var i = 0; i < sheep.length; i++) {
      if (sheep[i][0] == r && sheep[i][1] == c) return i;
    }
    return -1;
  }

  /// Level ini memakai fitur menebang: menang dengan menebang pohon,
  /// bukan dengan menduduki petak sasaran.
  bool get hasTree => trees.isNotEmpty;

  /// Level ini memakai fitur mengoleksi wool: menang dengan mencukur
  /// semua domba, bukan dengan menduduki petak sasaran.
  bool get hasSheep => sheep.isNotEmpty;

  /// Level ini memakai fitur membangun: menang dengan menutup semua
  /// petak area bangunan (walls) menggunakan blok place().
  bool get hasBuild => walls.isNotEmpty;

  /// Jumlah petak area bangunan yang harus dipasangi papan.
  int get buildTotal => walls.length;

  /// Indeks petak area bangunan di (r, c), atau -1 kalau bukan area bangunan.
  int wallIndexAt(int r, int c) {
    for (var i = 0; i < walls.length; i++) {
      if (walls[i][0] == r && walls[i][1] == c) return i;
    }
    return -1;
  }

  /// True kalau level ini punya sasaran khusus (pohon, domba, atau area bangunan).
  bool get hasCollectTarget => hasTree || hasSheep || hasBuild;

  /// Jarak Manhattan dari titik awal ke sasaran.
  int get distance => (goalRow - startRow).abs() + (goalCol - startCol).abs();

  /// Jumlah blok minimum untuk menyelesaikan level ini.
  int get parBlocks => par > 0 ? par : distance;

  String get tabLabel => tabTitle.isNotEmpty ? tabTitle : title;
}

// ============================================================
// 7 LEVEL — konsisten untuk semua memakai layout yang sama
// ============================================================
const kLevels = <MissionLevel>[
  MissionLevel(
    number: 1,
    title: 'Menuju Kambing',
    location: 'Padang Rumput',
    difficulty: 'TINGKAT MUDAH',
    mission: 'Pasang 2 balok gerak_maju() agar bot sampai ke kambing di padang rumput!',
    hint:
        'Bantu bot melangkah maju mendekati kambing di padang rumput! '
        'Pasang 2 balok gerak_maju agar sampai ke sasaran.',
    quickTip:
        'Kambing berada tepat 2 petak di depanmu. Jalankan kode untuk melihat '
        'robot mendekati kambing, lalu raih 3 bintang!',
    palette: ['maju'],
    capacity: 2,
    starTarget: 3,
    startRow: 3,
    startCol: 1,
    startDir: 1,
    goalRow: 3,
    goalCol: 3,
    rocks: [],
    bushes: [
      [0, 0],
      [1, 3],
      [2, 1],
    ],
    tips: [
      'Blok disusun dari atas ke bawah. Bot berjalan mengikuti urutan itu.',
      'Kapasitas level ini hanya 2 balok — sudah cukup untuk sampai.',
      'Kalau salah, tekan Atur Ulang lalu coba lagi.',
    ],
    reward: 50,
  ),
  MissionLevel(
    number: 2,
    title: 'Pertanyaan Berurutan',
    tabTitle: 'Tebang Kayu',
    location: 'Jalan Setapak',
    difficulty: 'TINGKAT SEDANG',
    mission: 'Susun beberapa perintah berurutan agar bot mengelilingi batu dan sampai ke kambing!',
    hint:
        'Batu besar menutup jalan lurus. Belok kiri, naik 1 petak, lalu jalan '
        'memutar ke kanan dan turun lagi untuk sampai ke kambing.',
    quickTip:
        'Saat menghadap kanan, "belok_kiri()" membuat bot menghadap atas. '
        'Jalankan langkah demi langkah untuk melihat arahnya berubah.',
    palette: ['maju', 'kanan', 'kiri'],
    capacity: 8,
    par: 8,
    startRow: 3,
    startCol: 0,
    startDir: 1,
    goalRow: 3,
    goalCol: 3,
    rocks: [
      [3, 1],
      [3, 2],
    ],
    bushes: [
      [0, 0],
    ],
    tips: [
      'Batu di depan menutup jalan lurus - bot harus memutar arah.',
      'Urutan solved: Belok Kiri, Gerak Maju, Belok Kanan, Gerak Maju 3x, '
          'Belok Kanan, Gerak Maju. Total 8 balok.',
      'Arah awal bot menghadap kanan, jadi belok pertama ke kiri.',
    ],
    reward: 60,
  ),
  MissionLevel(
    number: 3,
    title: 'Tebang Pohon',
    tabTitle: 'Tebang Kayu',
    location: 'Hutan Cemara',
    difficulty: 'TINGKAT SEDANG',
    mission:
        'Kayu adalah materi pembelajaran yang sangat penting. Banyak hal '
        'terbuat darinya. Jalan menuju pohon dan gunakan blok perintah '
        'destroy untuk memotongnya.',
    hint:
        'Pohon besar menutup petak sasaran. Bot tidak bisa melangkah ke petak '
        'pohon, jadi berjalan sampai petak di sebelahnya lalu pakai destroy().',
    quickTip:
        'destroy() hanya berhasil kalau bot berdiri tepat di samping pohon. '
        'Arahkan wajah bot ke pohon lalu tekan Jalankan.',
    palette: ['maju', 'ulang', 'destroy'],
    capacity: 8,
    par: 3,
    startRow: 3,
    startCol: 0,
    startDir: 1,
    goalRow: 3,
    goalCol: 3,
    rocks: [],
    bushes: [
      [0, 2],
      [1, 0],
    ],
    trees: [
      [3, 3],
    ],
    tips: [
      'Pohon tidak bisa dilalui seperti batu — harus ditebang lebih dulu.',
      'Jalan 2 petak sampai berdiri di samping pohon, lalu pakai destroy().',
      'Contoh urutan menang: gerak_maju(), gerak_maju(), destroy().',
    ],
    reward: 70,
  ),
  MissionLevel(
    number: 4,
    title: 'Mencukur Domba',
    tabTitle: 'Cukur Domba',
    location: 'Kandang Domba',
    difficulty: 'TINGKAT SEDANG',
    mission:
        'Waktunya mencukur domba! Gunakan perintah shear untuk mengumpulkan '
        'wool dari kedua domba.',
    hint:
        'Dekati domba sampai berdiri di petak sebelahnya, lalu pakai shear(). '
        'Setelah dicukur, petak domba jadi kosong dan bisa dilalui.',
    quickTip:
        'Kedua domba harus dicukur dalam satu kali jalan. Kalau masih ada '
        'domba yang belum dicukur, tekan Atur Ulang lalu coba lagi.',
    palette: ['maju', 'lompat', 'kanan', 'kiri', 'ulang', 'shear'],
    capacity: 10,
    par: 8,
    startRow: 3,
    startCol: 0,
    startDir: 1,
    goalRow: 3,
    goalCol: 3,
    rocks: [],
    bushes: [
      [1, 1],
      [2, 3],
      [3, 2],
    ],
    sheep: [
      [0, 1],
      [0, 3],
    ],
    tips: [
      'Domba tidak bisa dilalui sebelum dicukur - cukur dulu dengan shear().',
      'shear() hanya berhasil saat bot berdiri tepat di sebelah domba.',
      'Contoh urutan menang: kiri, maju, ulang, shear, kanan, maju, maju, shear.',
    ],
    reward: 80,
  ),
  MissionLevel(
    number: 5,
    title: 'Bangun Rumah',
    tabTitle: 'Bangun Rumah',
    location: 'Lahan Kosong',
    difficulty: 'TINGKAT SULIT',
    mission:
        'Kita harus membangun rumah sebelum matahari terbenam. Rumah '
        'memerlukan sangat banyak kayu. Tebang ke-3 pohon.',
    hint:
        'Ada 3 pohon yang harus ditebang semua. Setiap destroy() hanya '
        'menebang satu pohon, jadi tebang satu per satu.',
    quickTip:
        'Pohon di depan bot memblokir jalan. Tebang dulu, baru jalan lewat petak '
        'yang tadinya dihuni pohon itu.',
    palette: ['maju', 'ulang', 'kanan', 'kiri', 'lompat', 'destroy'],
    capacity: 12,
    par: 8,
    startRow: 3,
    startCol: 0,
    startDir: 1,
    goalRow: 3,
    goalCol: 3,
    rocks: [],
    bushes: [
      [0, 1],
      [1, 1],
      [2, 1],
    ],
    trees: [
      [3, 1],
      [3, 3],
      [1, 3],
    ],
    tips: [
      'Butuh 3 destroy() - satu untuk setiap pohon.',
      'Setelah pohon ditebang, petaknya kosong dan bisa dilalui.',
      'Contoh urutan menang: destroy, maju, maju, destroy, maju, kiri, maju, '
          'destroy. Total 8 balok.',
    ],
    reward: 100,
  ),
  MissionLevel(
    number: 6,
    title: 'Dinding Pertama',
    tabTitle: 'Dinding Rumah',
    location: 'Lahan Bangun',
    difficulty: 'TINGKAT SULIT',
    mission:
        'Setiap rumah dimulai dengan dinding. Bangunlah bagian pertama rumah '
        'Anda dengan meletakkan perintah place dan move forward ke dalam '
        'repeat loop.',
    hint:
        'Petak bergaris oranye di sisi kiri adalah area dinding. place() '
        'meletakkan papan kayu di petak di depan bot, lalu gerak_maju() '
        'membuat bot melangkah ke petak itu.',
    quickTip:
        'Masukkan place("kayu") dan gerak_maju() ke dalam perulangan: '
        'ulangi_blok(4) menjalankan keduanya 4 kali sehingga 4 papan terpasang '
        'hanya dengan 3 balok.',
    palette: ['place', 'maju', 'ulang4'],
    capacity: 5,
    par: 3,
    starTarget: 3,
    boardSize: 5,
    startRow: 0,
    startCol: 0,
    startDir: 2, // menghadap bawah
    goalRow: 4,
    goalCol: 0,
    rocks: [],
    bushes: [
      [0, 3],
      [1, 4],
      [3, 3],
    ],
    walls: [
      [1, 0],
      [2, 0],
      [3, 0],
      [4, 0],
    ],
    tips: [
      'ulangi_blok(4) menjalankan place + maju tepat 4 kali - balok di atasnya '
          'tidak ikut dijalankan lagi di luar loop.',
      'Urutan menang: place("kayu"), gerak_maju(), ulangi_blok(4). '
          'Total 3 balok untuk 4 papan.',
      'Papan harus dipasang sebelum bot melangkah. Kalau maju dulu baru '
          'place, bot akan melewati petak dinding tanpa memasang papan.',
    ],
    reward: 120,
  ),
  MissionLevel(
    number: 7,
    title: 'Sisa Rumah',
    tabTitle: 'Sisa Rumah',
    location: 'Lahan Bangun',
    difficulty: 'TINGKAT SULIT',
    mission:
        'Bangunlah sisa rumah Anda dari material sesuka Anda. Perintah repeat '
        'akan membantu.',
    hint:
        'Sisa dindingnya berbentuk huruf L. ulangi_blok(3) mengulang place + '
        'maju tiga kali untuk sisi pertama, lalu belok kiri dan pasang papan '
        'satu per satu untuk sisi kedua.',
    quickTip:
        'Material bebas: place("kayu") dan place("batu") sama-sama dihitung '
        'sebagai papan dinding. Contoh urutan: place, maju, ulangi_blok(3), '
        'belok_kiri, place, maju, place, maju.',
    palette: ['place', 'placeBatu', 'maju', 'kanan', 'kiri', 'ulang3'],
    capacity: 9,
    par: 8,
    starTarget: 3,
    boardSize: 5,
    startRow: 0,
    startCol: 0,
    startDir: 2, // menghadap bawah
    goalRow: 3,
    goalCol: 2,
    rocks: [],
    bushes: [
      [0, 2],
      [1, 4],
      [4, 1],
      [4, 4],
    ],
    walls: [
      [1, 0],
      [2, 0],
      [3, 0],
      [3, 1],
      [3, 2],
    ],
    tips: [
      'ulangi_blok(3) menjalankan balok di atasnya tepat 3 kali - balok itu '
          'tidak dijalankan lagi di luar loop.',
      'Urutan menang: place, maju, ulangi_blok(3), kiri, place, maju, '
          'place, maju. Total 8 balok untuk 5 papan.',
      'Campurkan material sesuka Anda: papan kayu dan batu sama-sama menutup '
          'petak area bangunan.',
    ],
    reward: 140,
  ),
];

// ============================================================
// 2. MISSION STAGE SCREEN
// ============================================================
class ChallengeScreen extends StatefulWidget {
  final MissionLevel level;
  const ChallengeScreen({required this.level, super.key});
  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen>
    with TickerProviderStateMixin {
  int get boardSize => lv.boardSize;

  final List<String> _program = [];
  int _row = 3, _col = 0, _dir = 1;
  int _moves = 0;
  int _stepIndex = 0;
  int _tab = 0; // 0 = Area Kode, 1 = Pratinjau Teks
  bool _running = false;
  bool _success = false;
  final Set<int> _chopped = {}; // indeks pohon yang sudah ditebang
  final Set<int> _shorn = {}; // indeks domba yang sudah dicukur
  final List<List<int>> _placed = []; // papan terpasang: [row, col, material]
  String _status = 'Susun balok kode, lalu tekan Jalankan';

  // ── WORKSPACE DRAG & DROP ─────────────────────────────────
  // _program tetap menjadi satu-satunya sumber urutan instruksi.
  // Key dipakai untuk menghitung posisi sisip saat blok dijatuhkan.
  final GlobalKey _workspaceKey = GlobalKey();
  final List<GlobalKey> _blockKeys = [];
  bool _draggingBlock = false;
  int? _hoverSlot;
  Offset? _dragPointer;
  // Sprite arena diekstrak dari sheet terbaru
  // assets/images/domba dan pohon.png: domba tampak samping kanan,
  // pohon tampak belakang. Dipakai di semua level yang punya domba/pohon.
  ui.Image?
  _karakterImage; // sprite karakter dari assets/images/karakter_depan.png
  ui.Image? _dombaImage; // sprite domba dari assets/images/domba.png
  ui.Image? _pohonImage; // sprite pohon dari assets/images/pohon.png

  // ── STATE VISUAL (tidak memengaruhi logika) ───────────────
  // _actionCtrl menggerakkan satu aksi: jalan, belok, tebang, cukur,
  // pasang papan, berhasil, atau gagal. _idleCtrl hanya untuk gerak diam.
  // Makin besar nilainya, makin pelan animasi karakter. Semua durasi aksi
  // (belok, maju, tebang, cukur) dikalikan dengan nilai ini di _playAction.
  static const double _animSlowdown = 5.0;
  // Jeda setelah tiap aksi supaya gerakan karakter tidak terasa menyambung
  // terlalu cepat dari satu langkah ke langkah berikutnya.
  static const Duration _postActionPause = Duration(milliseconds: 250);
  late final AnimationController _actionCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
    value: 1,
  );
  late final AnimationController _idleCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  RobotPose _pose = RobotPose.idle;
  double _fromRow = 3, _toRow = 3;
  double _fromCol = 0, _toCol = 0;
  double _fromDir = 1, _toDir = 1;
  bool _robotJump = false;
  int? _activeTree;
  int? _activeSheep;
  String? _activePlank;
  int _activePlankMat = 0;

  MissionLevel get lv => widget.level;

  MissionLevel? _levelAt(int n) {
    for (final l in kLevels) {
      if (l.number == n) return l;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _resetRobot();
    _loadArenaAssets();
  }

  @override
  void dispose() {
    _actionCtrl.dispose();
    _idleCtrl.dispose();
    super.dispose();
  }

  /// Muat semua sprite arena sekali, lalu gambar lewat [_ArenaPainter].
  Future<void> _loadArenaAssets() async {
    final images = await Future.wait([
      loadUiImage('assets/images/karakter_depan.png'),
      loadUiImage('assets/images/domba.png'),
      loadUiImage('assets/images/pohon.png'),
    ]);
    if (!mounted) return;
    setState(() {
      _karakterImage = images[0];
      _dombaImage = images[1];
      _pohonImage = images[2];
    });
  }

  // ── LOGIC ────────────────────────────────────────────────
  bool _inside(int r, int c) =>
      r >= 0 && r < boardSize && c >= 0 && c < boardSize;

  int get _starsUsed {
    final used = _program.length;
    if (used == 0) return 0;
    return used <= lv.parBlocks ? 3 : 2;
  }

  void _resetRobot() {
    _row = lv.startRow;
    _col = lv.startCol;
    _dir = lv.startDir;
    _moves = 0;
    _chopped.clear();
    _shorn.clear();
    _placed.clear();
    // Visual ikut kembali ke petak awal tanpa animasi.
    _pose = RobotPose.idle;
    _fromRow = _toRow = _row.toDouble();
    _fromCol = _toCol = _col.toDouble();
    _fromDir = _toDir = _dir.toDouble();
    _robotJump = false;
    _activeTree = null;
    _activeSheep = null;
    _activePlank = null;
    _activePlankMat = 0;
    _actionCtrl.value = 1;
  }

  /// Menjalankan satu animasi aksi dan menunggu sampai selesai.
  /// Durasi menyesuaikan jenis aksi, bukan kecepatan logika.
  Future<void> _playAction(Duration duration) async {
    if (!mounted) return;
    // Semua animasi aksi diperlambat agar gerakan karakter lebih mudah diikuti.
    _actionCtrl.duration = Duration(
      microseconds: (duration.inMicroseconds * _animSlowdown).round(),
    );
    try {
      await _actionCtrl.forward(from: 0);
    } on TickerCanceled {
      // Layar ditutup di tengah animasi — hentikan dengan tenang.
    }
    if (!mounted) return;
    await Future.delayed(_postActionPause);
  }

  /// Menyelesaikan pose setelah animasi selesai, kembali ke diam.
  void _settleVisual({RobotPose pose = RobotPose.idle}) {
    if (!mounted) return;
    final nd = ((_dir % 4) + 4) % 4;
    setState(() {
      _fromRow = _toRow = _row.toDouble();
      _fromCol = _toCol = _col.toDouble();
      _fromDir = _toDir = nd.toDouble();
      _robotJump = false;
      _activeTree = null;
      _activeSheep = null;
      _activePlank = null;
      _activePlankMat = 0;
      _pose = pose;
    });
  }

  /// Kayu terkumpul: "1/3".
  int get _woodCount => _chopped.length;
  int get _woodTotal => lv.trees.length;

  /// Wool terkumpul: "1/2".
  int get _woolCount => _shorn.length;
  int get _woolTotal => lv.sheep.length;

  /// Papan terpasang: "3/4".
  int get _wallDone =>
      lv.walls.where((w) => _placedIndexAt(w[0], w[1]) >= 0).length;

  /// Indeks papan di petak (r, c), atau -1 kalau belum ada papan.
  int _placedIndexAt(int r, int c) {
    for (var i = 0; i < _placed.length; i++) {
      if (_placed[i][0] == r && _placed[i][1] == c) return i;
    }
    return -1;
  }

  /// Semua petak area bangunan sudah terpasang papan.
  bool get _buildDone => lv.hasBuild && _wallDone >= lv.buildTotal;

  /// Judul header arena, menyesuaikan tipe sasaran level.
  String get _arenaTitle {
    if (lv.hasBuild) return 'Bangun ${lv.buildTotal} Papan Dinding';
    if (lv.hasSheep) return 'Cukur $_woolTotal Domba';
    if (lv.hasTree) return 'Tebang $_woodTotal Pohon';
    return 'Target 2 Pihak';
  }

  void _resetAll() {
    setState(() {
      _program.clear();
      _resetRobot();
      _stepIndex = 0;
      _running = false;
      _success = false;
      _status = 'Susun balok kode, lalu tekan Jalankan';
    });
  }

  void _toast(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(m),
        backgroundColor: C.navyCard2,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addBlock(String id) {
    if (_running) return;
    if (_program.length >= lv.capacity) {
      _toast('Kapasitas level ini hanya ${lv.capacity} balok');
      return;
    }
    setState(() {
      _program.add(id);
      _stepIndex = 0;
      _success = false;
      _status = '${kCmds[id]!.code} ditambahkan';
    });
    GameAudio.instance.playSfx('click');
  }

  void _removeBlock(int i) {
    if (_running) return;
    setState(() {
      _program.removeAt(i);
      _resetRobot();
      _stepIndex = 0;
      _success = false;
      _status = 'Balok dihapus';
    });
    GameAudio.instance.playSfx('click');
  }

  // ── DRAG & DROP BLOCK LOGIC ──────────────────────────────
  /// Pastikan jumlah key blok selalu sama dengan jumlah instruksi.
  void _syncBlockKeys() {
    while (_blockKeys.length < _program.length) {
      _blockKeys.add(GlobalKey());
    }
    if (_blockKeys.length > _program.length) {
      _blockKeys.removeRange(_program.length, _blockKeys.length);
    }
  }

  void _beginBlockDrag() {
    if (!mounted) return;
    setState(() {
      _draggingBlock = true;
      _hoverSlot = null;
    });
  }

  void _trackBlockDrag(DragUpdateDetails details) {
    _dragPointer = details.globalPosition;
  }

  void _endBlockDrag() {
    if (!mounted) return;
    setState(() {
      _draggingBlock = false;
      _hoverSlot = null;
      _dragPointer = null;
    });
  }

  /// Posisi sisip (0.._program.length) berdasarkan titik lepas blok.
  /// Titik di atas bagian tengah sebuah blok disisipkan sebelum blok itu.
  int _dropSlotFor(Offset globalPointer) {
    for (var i = 0; i < _program.length && i < _blockKeys.length; i++) {
      final box =
          _blockKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final centerY = box.localToGlobal(Offset(0, box.size.height / 2)).dy;
      if (globalPointer.dy < centerY) return i;
    }
    return _program.length;
  }

  /// Menambah blok baru atau memindahkan blok yang sudah ada ke [slot].
  void _dropBlock(_BlockDragData data, Offset globalPointer) {
    if (!mounted || _running) return;
    final slot = _dropSlotFor(globalPointer);

    if (data.fromIndex == null) {
      if (_program.length >= lv.capacity) {
        _toast('Kapasitas level ini hanya ${lv.capacity} blok');
        return;
      }
      setState(() {
        _program.insert(slot, data.id);
        _stepIndex = 0;
        _success = false;
        _status = '${kCmds[data.id]!.code} ditambahkan';
      });
      GameAudio.instance.playSfx('click');
      return;
    }

    final from = data.fromIndex!;
    // Lepas tepat di posisi semula tidak mengubah apa pun.
    if (slot == from || slot == from + 1) return;
    setState(() {
      final id = _program.removeAt(from);
      var to = slot > from ? slot - 1 : slot;
      if (to < 0) to = 0;
      if (to > _program.length) to = _program.length;
      _program.insert(to, id);
      _resetRobot();
      _stepIndex = 0;
      _success = false;
      _status = 'Urutan blok diperbarui';
    });
    GameAudio.instance.playSfx('click');
  }

  Future<bool> _turn(int delta, Cmd cmd) async {
    final from = _toDir;
    setState(() {
      _dir = (_dir + delta + 4) % 4;
      _status = cmd.code;
      _fromDir = from;
      _toDir = from + delta;
      _pose = RobotPose.idle;
    });
    await _playAction(const Duration(milliseconds: 230));
    _settleVisual();
    return true;
  }

  Future<bool> _move(int count, bool jump, Cmd cmd) async {
    for (var i = 0; i < count; i++) {
      final nr = _row + kDr[_dir];
      final nc = _col + kDc[_dir];
      final last = i == count - 1;
      final outOfBoard = !_inside(nr, nc);
      // Lompat boleh melewati batu di tengah, tapi tidak mendarat di batu
      final onRock = lv.rockAt(nr, nc);
      // Pohon juga menutup petak sampai ditebang
      final ti = lv.treeIndexAt(nr, nc);
      final onTree = ti >= 0 && !_chopped.contains(ti);
      // Domba menutup petak sampai dicukur
      final si = lv.sheepIndexAt(nr, nc);
      final onSheep = si >= 0 && !_shorn.contains(si);
      final blocked = onRock || onTree || onSheep;
      if (outOfBoard || (blocked && !(jump && !last))) {
        setState(() {
          _status = onSheep
              ? 'Domba menghalangi jalan! Cukur dulu dengan shear().'
              : onTree
              ? 'Pohon menghalangi jalan! Tebang dulu dengan destroy().'
              : jump
              ? 'Gagal! lompat() mendarat di batu.'
              : 'Batu menghalangi jalan!';
          _robotJump = false;
          _pose = RobotPose.sad;
        });
        await _playAction(const Duration(milliseconds: 420));
        _settleVisual();
        return false;
      }
      final oldR = _row, oldC = _col;
      setState(() {
        _row = nr;
        _col = nc;
        _moves++;
        _status = '${cmd.code} · ${cmd.sub}';
        _fromRow = oldR.toDouble();
        _fromCol = oldC.toDouble();
        _toRow = nr.toDouble();
        _toCol = nc.toDouble();
        _robotJump = jump;
        _pose = jump ? RobotPose.jump : RobotPose.walk;
      });
      await _playAction(Duration(milliseconds: jump ? 360 : 330));
      _settleVisual();
    }
    return true;
  }

  /// Menebang pohon di petak sebelah bot. Satu pohon per pemanggilan —
  /// kalau ada beberapa pohon, panggil destroy() berulang kali.
  Future<bool> _destroy(Cmd cmd) async {
    if (!lv.hasTree) {
      setState(() {
        _status = 'Level ini tidak punya pohon untuk ditebang';
        _pose = RobotPose.sad;
      });
      await _playAction(const Duration(milliseconds: 380));
      _settleVisual();
      return false;
    }
    if (_woodCount >= _woodTotal) {
      setState(() => _status = '${cmd.code} · Semua pohon sudah ditebang');
      await _playAction(const Duration(milliseconds: 220));
      _settleVisual();
      return true;
    }
    int? target;
    for (var i = 0; i < lv.trees.length; i++) {
      if (_chopped.contains(i)) continue;
      if (_beside(lv.trees[i][0], lv.trees[i][1])) {
        target = i;
        break;
      }
    }
    if (target == null) {
      setState(() {
        _status = 'Gagal! destroy() butuh bot di samping pohon';
        _pose = RobotPose.sad;
      });
      await _playAction(const Duration(milliseconds: 420));
      _settleVisual();
      return false;
    }
    // variabel final supaya bisa dibaca di dalam closure setState
    final cut = target;
    setState(() {
      _activeTree = cut;
      _pose = RobotPose.chop;
      _status = '${cmd.code} · Menebang pohon...';
    });
    await _playAction(const Duration(milliseconds: 620));
    if (!mounted) return false;
    setState(() {
      _chopped.add(cut);
      _status = '${cmd.code} · Kayu $_woodCount/$_woodTotal terkumpul!';
      _activeTree = null;
      _pose = RobotPose.idle;
    });
    _settleVisual();
    return true;
  }

  /// True kalau petak (r, c) bersebelahan dengan petak bot.
  bool _beside(int r, int c) =>
      (r == _row + kDr[_dir] && c == _col + kDc[_dir]) ||
      (r == _row - 1 && c == _col) ||
      (r == _row + 1 && c == _col) ||
      (r == _row && c == _col - 1) ||
      (r == _row && c == _col + 1);

  /// Mencukur domba di petak sebelah bot dan mengoleksi wool-nya.
  Future<bool> _shear(Cmd cmd) async {
    if (!lv.hasSheep) {
      setState(() {
        _status = 'Level ini tidak punya domba untuk dicukur';
        _pose = RobotPose.sad;
      });
      await _playAction(const Duration(milliseconds: 380));
      _settleVisual();
      return false;
    }
    if (_woolCount >= _woolTotal) {
      setState(() => _status = '${cmd.code} · Semua domba sudah dicukur');
      await _playAction(const Duration(milliseconds: 220));
      _settleVisual();
      return true;
    }
    int? target;
    for (var i = 0; i < lv.sheep.length; i++) {
      if (_shorn.contains(i)) continue;
      if (_beside(lv.sheep[i][0], lv.sheep[i][1])) {
        target = i;
        break;
      }
    }
    if (target == null) {
      setState(() {
        _status = 'Gagal! shear() butuh bot di samping domba';
        _pose = RobotPose.sad;
      });
      await _playAction(const Duration(milliseconds: 420));
      _settleVisual();
      return false;
    }
    // variabel final supaya bisa dibaca di dalam closure setState
    final shorn = target;
    setState(() {
      _activeSheep = shorn;
      _pose = RobotPose.shear;
      _status = '${cmd.code} · Mencukur domba...';
    });
    await _playAction(const Duration(milliseconds: 620));
    if (!mounted) return false;
    setState(() {
      _shorn.add(shorn);
      _status = '${cmd.code} · Wool $_woolCount/$_woolTotal terkumpul!';
      _activeSheep = null;
      _pose = RobotPose.idle;
    });
    _settleVisual();
    return true;
  }

  /// Meletakkan papan di petak area bangunan di depan bot.
  /// [mat] 0 = papan kayu, 1 = batu bata. Papan tidak menghalangi jalan,
  /// jadi bot tetap bisa melangkah ke petak yang baru dipasang.
  Future<bool> _place(int mat, Cmd cmd) async {
    if (!lv.hasBuild) {
      setState(() {
        _status = 'Level ini tidak punya area bangunan';
        _pose = RobotPose.sad;
      });
      await _playAction(const Duration(milliseconds: 380));
      _settleVisual();
      return false;
    }
    final fr = _row + kDr[_dir];
    final fc = _col + kDc[_dir];
    if (!_inside(fr, fc)) {
      setState(() {
        _status = 'Gagal! ${cmd.code} - tidak ada petak di depan bot';
        _pose = RobotPose.sad;
      });
      await _playAction(const Duration(milliseconds: 380));
      _settleVisual();
      return false;
    }
    if (lv.wallIndexAt(fr, fc) < 0) {
      setState(() {
        _status =
            'Gagal! ${cmd.code} harus di petak area bangunan (garis oranye)';
        _pose = RobotPose.sad;
      });
      await _playAction(const Duration(milliseconds: 380));
      _settleVisual();
      return false;
    }
    if (lv.rockAt(fr, fc) ||
        lv.treeAt(fr, fc) ||
        lv.sheepIndexAt(fr, fc) >= 0) {
      setState(() {
        _status = 'Petak di depan bot masih terisi objek lain';
        _pose = RobotPose.sad;
      });
      await _playAction(const Duration(milliseconds: 380));
      _settleVisual();
      return false;
    }
    if (_placedIndexAt(fr, fc) >= 0) {
      setState(() => _status = '${cmd.code} · Petak itu sudah terpasang papan');
      await _playAction(const Duration(milliseconds: 200));
      _settleVisual();
      return true;
    }
    setState(() {
      _activePlank = '$fr,$fc';
      _activePlankMat = mat;
      _pose = RobotPose.build;
      _status = '${cmd.code} · Memasang papan...';
    });
    GameAudio.instance.playSfx('place');
    await _playAction(const Duration(milliseconds: 520));
    if (!mounted) return false;
    setState(() {
      _placed.add([fr, fc, mat]);
      _activePlank = null;
      _pose = RobotPose.idle;
      _status = '${cmd.code} · Papan $_wallDone/${lv.buildTotal} terpasang!';
    });
    _settleVisual();
    return true;
  }

  Future<bool> _execCmd(String id) async {
    final cmd = kCmds[id]!;
    switch (id) {
      case 'maju':
        return _move(1, false, cmd);
      case 'maju2':
        return _move(2, false, cmd);
      case 'lompat':
        return _move(2, true, cmd);
      case 'kanan':
        return _turn(1, cmd);
      case 'kiri':
        return _turn(-1, cmd);
      case 'destroy':
        return _destroy(cmd);
      case 'shear':
        return _shear(cmd);
      case 'place':
        return _place(0, cmd);
      case 'placeBatu':
        return _place(1, cmd);
      case 'tunggu':
        setState(() => _status = 'tunggu(1) · 1 detik');
        await Future.delayed(const Duration(milliseconds: 900));
        return true;
      default:
        return true;
    }
  }

  /// Indeks awal kelompok balok yang diulang oleh balok repeat di [at].
  /// Kelompok berhenti tepat sebelum balok repeat sebelumnya (atau awal program).
  int _groupStart(int at) {
    for (var i = at - 1; i >= 0; i--) {
      if (_isRepeat(_program[i])) return i + 1;
    }
    return 0;
  }

  /// Balok repeat pertama SETELAH balok [i], atau -1 kalau tidak ada.
  /// Hanya ulangi_blok(3)/(4) yang menarik balok di atasnya ke dalam loop,
  /// jadi balok isi loop tidak ikut dijalankan di alur utama - loop-nya
  /// sendiri yang menjalankannya tepat N kali.
  int _repeatOwner(int i) {
    for (var j = i + 1; j < _program.length; j++) {
      if (!_isRepeat(_program[j])) continue;
      return _program[j] == 'ulang' ? -1 : j;
    }
    return -1;
  }

  /// Menjalankan balok pengulang (ulangi_blok) di posisi [at].
  Future<bool> _execRepeat(int at) async {
    final id = _program[at];
    if (at == 0) {
      setState(
        () => _status = '${kCmds[id]!.code} harus dipakai setelah balok lain',
      );
      await Future.delayed(const Duration(milliseconds: 420));
      return false;
    }
    if (id == 'ulang') {
      final prev = _program[at - 1];
      setState(() => _status = 'Mengulang 2x: ${kCmds[prev]!.code}');
      await Future.delayed(const Duration(milliseconds: 160));
      var ok = await _execCmd(prev);
      if (ok) ok = await _execCmd(prev);
      return ok;
    }
    final start = _groupStart(at);
    final times = _repeatTimes(id);
    if (start >= at) {
      setState(
        () => _status = '${kCmds[id]!.code} harus punya balok di atasnya',
      );
      await Future.delayed(const Duration(milliseconds: 420));
      return false;
    }
    setState(() => _status = 'Mengulang ${times}x: balok ${start + 1}-$at');
    await Future.delayed(const Duration(milliseconds: 160));
    for (var k = 0; k < times; k++) {
      for (var i = start; i < at; i++) {
        if (!await _execCmd(_program[i])) return false;
      }
    }
    return true;
  }

  /// Menjalankan satu instruksi (dipakai mode "Langkah").
  Future<bool> _execOne(String id, int at) async {
    if (_isRepeat(id)) return _execRepeat(at);
    return _execCmd(id);
  }

  Future<void> _finish(bool ok) async {
    // Level berpohon menang lewat penebangan, level berdomba menang lewat
    // wool lengkap, level biasa menang lewat petak sasaran.
    final win =
        ok &&
        (lv.hasBuild
            ? _buildDone
            : lv.hasSheep
            ? _woolCount >= _woolTotal
            : lv.hasTree
            ? _woodCount >= _woodTotal
            : (_row == lv.goalRow && _col == lv.goalCol));
    setState(() {
      _running = false;
      _success = win;
      _pose = win ? RobotPose.happy : RobotPose.sad;
      _status = win
          ? 'Misi berhasil! Kamu raih $_starsUsed bintang.'
          : lv.hasBuild
          ? 'Kode selesai, papan baru $_wallDone/${lv.buildTotal}.'
          : lv.hasSheep
          ? 'Kode selesai, wool baru $_woolCount/$_woolTotal.'
          : lv.hasTree
          ? 'Kode selesai, kayu baru $_woodCount/$_woodTotal.'
          : 'Kode selesai, kambing belum tercapai.';
    });
    if (win) {
      await GameProgress.instance.recordWin(
        number: lv.number,
        stars: _starsUsed,
        xpGain: lv.reward,
        coinGain: lv.reward ~/ 10,
      );
      GameAudio.instance.playSfx('win');
      // Pose berhasil sempat terlihat sebelum layar hasil dibuka.
      await _playAction(const Duration(milliseconds: 650));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        playfulRoute(LevelCompleteScreen(level: lv, stars: _starsUsed)),
      );
    } else {
      GameAudio.instance.playSfx('fail');
      await _playAction(const Duration(milliseconds: 520));
      if (!mounted) return;
      _settleVisual(pose: RobotPose.sad);
    }
  }

  Future<void> _run() async {
    if (_running) return;
    if (_program.isEmpty) {
      _toast('Tambahkan balok dulu di Palet Blok Perintah');
      return;
    }
    setState(() {
      _running = true;
      _success = false;
      _stepIndex = 0;
      _resetRobot();
      _status = 'Menjalankan kode...';
    });
    GameAudio.instance.playSfx('click');

    var ok = true;
    for (var i = 0; i < _program.length && ok; i++) {
      final id = _program[i];
      if (_isRepeat(id)) {
        setState(() => _stepIndex = i);
        ok = await _execRepeat(i);
        continue;
      }
      // balok isi loop dijalankan oleh balok ulangi_blok, bukan di sini
      if (_repeatOwner(i) >= 0) continue;
      setState(() => _stepIndex = i);
      ok = await _execCmd(id);
    }

    if (!mounted) return;
    await _finish(ok);
  }

  Future<void> _step() async {
    if (_running) return;
    if (_program.isEmpty) {
      _toast('Tambahkan balok dulu di Palet Blok Perintah');
      return;
    }
    if (_stepIndex == 0) _resetRobot();
    // balok isi loop dilewati: nanti dijalankan oleh balok ulangi_blok
    var skipped = 0;
    while (_stepIndex < _program.length && _repeatOwner(_stepIndex) >= 0) {
      _stepIndex++;
      skipped++;
    }
    if (skipped > 0) {
      setState(
        () => _status = 'Balok isi perulangan dijalankan oleh ulangi_blok',
      );
    }
    if (_stepIndex >= _program.length) {
      _toast('Semua balok sudah dijalankan. Tekan Atur Ulang.');
      return;
    }
    setState(() => _running = true);

    final id = _program[_stepIndex];
    final ok = await _execOne(id, _stepIndex);
    if (!mounted) return;
    _stepIndex++;

    final last = _stepIndex >= _program.length;
    if (last) {
      await _finish(ok);
      return;
    }
    setState(() {
      _running = false;
      _success = false;
      _status =
          'Balok $_stepIndex/${_program.length} selesai. Tekan Langkah lagi.';
    });
  }

  // ── BUILD ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.navy,
      body: Stack(
        children: [
          const Positioned.fill(child: DotPattern()),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    _header(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _levelTabs(),
                            const SizedBox(height: 10),
                            _infoPanel(),
                            const SizedBox(height: 10),
                            _missionCard(),
                            const SizedBox(height: 10),
                            _hintCard(),
                            const SizedBox(height: 10),
                            _arena(),
                            const SizedBox(height: 12),
                            _controls(),
                            const SizedBox(height: 14),
                            _editorTabs(),
                            const SizedBox(height: 10),
                            _codePanel(),
                            const SizedBox(height: 12),
                            _palette(),
                            const SizedBox(height: 12),
                            _quickTip(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _panel(Color c, {double r = 18}) => BoxDecoration(
    color: c,
    borderRadius: BorderRadius.circular(r),
    border: Border.all(color: Colors.white.withValues(alpha: .07)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: .30),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );

  Widget _roundBtn(IconData ic, VoidCallback onTap, {Color? tint}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: C.navyCard2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: C.navyLine),
        ),
        child: Icon(ic, size: 17, color: tint ?? C.cyanSoft),
      ),
    );
  }

  // ── HEADER ──
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: Row(
        children: [
          _roundBtn(Icons.arrow_back_rounded, () => Navigator.pop(context)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [C.orangePop, Color(0xFFFFB061)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'LEVEL ${lv.number}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: C.navyDeep,
                      letterSpacing: .8,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AlgoCraft - Petualangan Kode',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          _roundBtn(
            Icons.star_rounded,
            () => _toast('Target: ${lv.starTarget} bintang'),
            tint: C.gold,
          ),
          const SizedBox(width: 6),
          ValueListenableBuilder<int>(
            valueListenable: GameAudio.instance.changes,
            builder: (_, _, _) => _roundBtn(
              GameAudio.instance.soundOn
                  ? Icons.volume_up_rounded
                  : Icons.volume_off_rounded,
              () => GameAudio.instance.setSoundOn(!GameAudio.instance.soundOn),
            ),
          ),
          const SizedBox(width: 6),
          _roundBtn(
            Icons.more_horiz_rounded,
            () => _toast('Pilihan belum tersedia'),
          ),
        ],
      ),
    );
  }

  // ── TAB LEVEL ──
  Widget _levelTabs() {
    final next = _levelAt(lv.number + 1);
    return Row(
      children: [
        Expanded(child: _lvTab(lv, true)),
        const SizedBox(width: 8),
        Expanded(
          child: next == null ? _lvTab(null, false) : _lvTab(next, false),
        ),
      ],
    );
  }

  Widget _lvTab(MissionLevel? l, bool active) {
    if (l == null) {
      return Container(
        height: 38,
        decoration: BoxDecoration(
          color: C.navyCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: C.navyLine),
        ),
      );
    }
    final locked = l.number > lv.number;
    return GestureDetector(
      onTap: () {
        if (locked) {
          _toast('Selesaikan Level ${lv.number} dulu!');
          return;
        }
        Navigator.pushReplacement(
          context,
          playfulRoute(ChallengeScreen(level: l)),
        );
      },
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(colors: [C.cyan, Color(0xFF2BB8C9)])
              : null,
          color: active ? null : C.navyCard,
          borderRadius: BorderRadius.circular(20),
          border: active ? null : Border.all(color: C.navyLine),
        ),
        child: Row(
          children: [
            Icon(
              locked ? Icons.lock_rounded : Icons.check_circle_rounded,
              size: 13,
              color: active ? C.navyDeep : C.dim,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Lv ${l.number}: ${l.tabLabel}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  color: active ? C.navyDeep : (locked ? C.dim : C.cyanSoft),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── PANEL INFO MISI ──
  Widget _infoPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: _panel(C.navyCard, r: 16),
      child: Row(
        children: [
          Expanded(
            child: _infoCol(lv.difficulty, C.green, Icons.verified_rounded),
          ),
          _vLine(),
          Expanded(child: _starCol()),
          _vLine(),
          Expanded(
            child: _infoCol(
              '${_program.length} / ${lv.capacity}',
              C.cyan,
              Icons.inventory_2_rounded,
              cap: 'KAPASITAS',
            ),
          ),
        ],
      ),
    );
  }

  Widget _vLine() => Container(
    width: 1,
    height: 30,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    color: C.navyLine,
  );

  Widget _infoCol(String value, Color col, IconData ic, {String? cap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cap ?? 'TINGKAT',
          style: const TextStyle(
            fontSize: 8.5,
            fontWeight: FontWeight.w900,
            color: C.dim,
            letterSpacing: .8,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Icon(ic, size: 13, color: col),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _starCol() {
    final got = _starsUsed;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TARGET',
          style: TextStyle(
            fontSize: 8.5,
            fontWeight: FontWeight.w900,
            color: C.dim,
            letterSpacing: .8,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            for (var i = 0; i < lv.starTarget; i++)
              Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Icon(
                  Icons.star_rounded,
                  size: 13,
                  color: i < got ? C.gold : C.navyLine,
                ),
              ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '${lv.starTarget} Bintang',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── PETUNJUK ALGOBOOT ──
  // ── MISI LEVEL ──
  Widget _missionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [C.cyan.withValues(alpha: .16), C.navyCard],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: C.cyan.withValues(alpha: .40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [C.cyan, Color(0xFF2AA8FF)],
              ),
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: C.cyan.withValues(alpha: .4),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.flag_rounded, color: C.navyDeep, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MISI',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    color: C.cyan,
                    letterSpacing: .9,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lv.mission,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.white,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hintCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [C.blue.withValues(alpha: .18), C.navyCard],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: C.blue.withValues(alpha: .45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5AB4FF), C.blueDark],
              ),
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: C.blue.withValues(alpha: .4),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PETUNJUK ALGOBOOT',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    color: C.cyanSoft,
                    letterSpacing: .9,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lv.hint,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFC9D6F2),
                    height: 1.38,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Chip penghitung koleksi (Kayu / Wool) di header arena.
  Widget _countChip(IconData ic, Color col, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: col.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ic, size: 10, color: col),
          const SizedBox(width: 3),
          Text(
            label,
            maxLines: 1,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
              color: col,
            ),
          ),
        ],
      ),
    );
  }

  // ── ARENA ──
  Widget _arena() {
    final theme = BoardTheme.of(lv.location);
    final hat = equippedCostume(CostumeCategory.topi);
    final shirt = equippedCostume(CostumeCategory.baju);
    final shoes = equippedCostume(CostumeCategory.sepatu);
    final scarf = equippedCostume(CostumeCategory.syal);
    final wings = equippedCostume(CostumeCategory.sayap);
    final accessory = equippedCostume(CostumeCategory.aksesoris);
    return Container(
      width: double.infinity,
      decoration: _panel(C.navyCard, r: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 2),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: C.cyan,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: C.cyan.withValues(alpha: .6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Flexible + ellipsis supaya judul tetap muat di layar sempit
                Flexible(
                  child: Text(
                    _arenaTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: .5,
                    ),
                  ),
                ),
                const Spacer(),
                if (lv.hasBuild) ...[
                  _countChip(
                    Icons.carpenter_rounded,
                    const Color(0xFFE0A05A),
                    'Papan $_wallDone/${lv.buildTotal}',
                  ),
                  const SizedBox(width: 6),
                ],
                if (lv.hasTree) ...[
                  _countChip(
                    Icons.forest_rounded,
                    C.green,
                    'Kayu $_woodCount/$_woodTotal',
                  ),
                  const SizedBox(width: 6),
                ],
                if (lv.hasSheep) ...[
                  _countChip(
                    Icons.emoji_nature_rounded,
                    C.pink,
                    'Wool $_woolCount/$_woolTotal',
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  '$_moves langkah',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: C.cyanSoft,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 196,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 2),
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: Listenable.merge([_actionCtrl, _idleCtrl]),
                  builder: (context, _) {
                    final moved = Curves.easeInOutCubic.transform(
                      _actionCtrl.value,
                    );
                    final turned = Curves.easeOutCubic.transform(
                      _actionCtrl.value,
                    );
                    final row = _fromRow + (_toRow - _fromRow) * moved;
                    final col = _fromCol + (_toCol - _fromCol) * moved;
                    final dir = _fromDir + (_toDir - _fromDir) * turned;
                    return CustomPaint(
                      size: Size.infinite,
                      painter: _ArenaPainter(
                        size: boardSize,
                        rocks: lv.rocks,
                        bushes: lv.bushes,
                        trees: lv.trees,
                        treesChopped: [
                          for (var i = 0; i < lv.trees.length; i++)
                            _chopped.contains(i),
                        ],
                        sheep: lv.sheep,
                        sheepShorn: [
                          for (var i = 0; i < lv.sheep.length; i++)
                            _shorn.contains(i),
                        ],
                        walls: lv.walls,
                        placed: [
                          for (final p in _placed) [p[0], p[1], p[2]],
                        ],
                        robotRow: row,
                        robotCol: col,
                        robotDir: dir,
                        goalRow: lv.goalRow,
                        goalCol: lv.goalCol,
                        karakter: _karakterImage,
                        domba: _dombaImage,
                        pohon: _pohonImage,
                        theme: theme,
                        pose: _pose,
                        poseT: _actionCtrl.value,
                        idleT: _idleCtrl.value,
                        jump: _robotJump,
                        activeTree: _activeTree,
                        activeSheep: _activeSheep,
                        activePlank: _activePlank,
                        activePlankMat: _activePlankMat,
                        hat: hat,
                        shirt: shirt,
                        shoes: shoes,
                        scarf: scarf,
                        wings: wings,
                        accessory: accessory,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(10, 4, 10, 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: _success
                  ? C.green.withValues(alpha: .18)
                  : C.navyDeep.withValues(alpha: .65),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: _success
                    ? C.green.withValues(alpha: .6)
                    : Colors.transparent,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      _success
                          ? Icons.check_circle_rounded
                          : Icons.my_location_rounded,
                      size: 13,
                      color: _success ? C.green : C.cyanSoft,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'X:$_col, Y:$_row',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        color: C.cyanSoft,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 12,
                      color: C.dim.withValues(alpha: .8),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        lv.hasBuild
                            ? 'Papan: $_wallDone/${lv.buildTotal}'
                            : 'Target X:${lv.goalCol}, Y:${lv.goalRow}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: C.orangePop,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: _success ? C.green : C.dim,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── TOMBOL UTAMA ──
  Widget _controls() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: _running ? null : _run,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: _running
                    ? const LinearGradient(
                        colors: [Color(0xFF6B4A2A), Color(0xFF54381F)],
                      )
                    : const LinearGradient(colors: [C.orangePop, C.orangeDeep]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: C.orangePop.withValues(alpha: _running ? .1 : .4),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _running
                            ? Icons.hourglass_top_rounded
                            : Icons.play_arrow_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        _running ? 'MENJALANKAN' : 'JALANKAN',
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: .5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _sideBtn(Icons.skip_next_rounded, 'Langkah', _step),
        const SizedBox(width: 8),
        _sideBtn(Icons.restart_alt_rounded, '', _resetAll, square: true),
      ],
    );
  }

  Widget _sideBtn(
    IconData ic,
    String label,
    VoidCallback onTap, {
    bool square = false,
  }) {
    return GestureDetector(
      onTap: _running && label.isEmpty ? null : onTap,
      child: Container(
        height: 52,
        width: square ? 52 : null,
        padding: square ? null : const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: C.navyCard2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: C.navyLine),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ic, size: 18, color: C.cyanSoft),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  color: C.cyanSoft,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── TAB EDITOR ──
  Widget _editorTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: C.navyDeep.withValues(alpha: .6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tabChip(
            0,
            'Area Kode (${_program.length} Blok)',
            Icons.extension_rounded,
          ),
          const SizedBox(width: 6),
          _tabChip(1, 'Pratinjau Teks', Icons.terminal_rounded),
        ],
      ),
    );
  }

  Widget _tabChip(int i, String label, IconData ic) {
    final active = _tab == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = i),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(colors: [C.cyan, Color(0xFF2BB8C9)])
                : null,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                ic,
                size: 13,
                color: active ? C.navyDeep : const Color(0xFF8FA3CC),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: active ? C.navyDeep : const Color(0xFFB9C6E8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── PANEL KODE ──
  Widget _codePanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: _panel(C.navyCard, r: 20),
      child: _tab == 0 ? _executionArea() : _textPreview(),
    );
  }

  Widget _executionArea() {
    _syncBlockKeys();
    final feedbackWidth = math.min(
      340.0,
      MediaQuery.sizeOf(context).width - 52,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Urutan Kode',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              '${_program.length} / ${lv.capacity} balok',
              style: const TextStyle(fontSize: 9.5, color: C.dim),
            ),
          ],
        ),
        const SizedBox(height: 3),
        const Text(
          'Seret blok ke bawah blok mulai. Ketuk palet untuk menambah cepat.',
          style: TextStyle(fontSize: 9.5, color: C.dim, height: 1.3),
        ),
        const SizedBox(height: 9),
        DragTarget<_BlockDragData>(
          onWillAcceptWithDetails: (_) => !_running,
          onMove: (details) {
            final pointer = _dragPointer ?? details.offset;
            final slot = _dropSlotFor(pointer);
            if (_hoverSlot != slot) {
              setState(() => _hoverSlot = slot);
            }
          },
          onLeave: (_) {
            if (_hoverSlot != null) setState(() => _hoverSlot = null);
          },
          onAcceptWithDetails: (details) =>
              _dropBlock(details.data, _dragPointer ?? details.offset),
          builder: (context, candidate, rejected) {
            final active = candidate.isNotEmpty && !_running;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
              decoration: BoxDecoration(
                color: C.navyDeep.withValues(alpha: .48),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: active ? C.cyan : C.navyLine,
                  width: active ? 1.6 : 1,
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: C.cyan.withValues(alpha: .25),
                          blurRadius: 14,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                key: _workspaceKey,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PuzzleBlock(
                    color: C.orangePop,
                    icon: Icons.play_arrow_rounded,
                    code: 'ketika_dijalankan()',
                    sub: 'mulai program',
                    isStart: true,
                  ),
                  if (_program.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: _emptyWorkspace(active),
                    )
                  else ...[
                    for (var i = 0; i < _program.length; i++)
                      _workspaceBlock(i, feedbackWidth),
                    if (_draggingBlock && _hoverSlot == _program.length)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: _dropIndicator(),
                      ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _workspaceBlock(int i, double feedbackWidth) {
    final cmd = kCmds[_program[i]]!;
    final block = _PuzzleBlock(
      color: cmd.color,
      icon: cmd.icon,
      code: cmd.code,
      sub: cmd.sub,
      onDelete: () => _removeBlock(i),
      running: _running && _stepIndex == i,
    );
    final feedbackBlock = _PuzzleBlock(
      color: cmd.color,
      icon: cmd.icon,
      code: cmd.code,
      sub: cmd.sub,
    );
    return SizedBox(
      key: _blockKeys[i],
      child: Draggable<_BlockDragData>(
        data: _BlockDragData(_program[i], fromIndex: i),
        maxSimultaneousDrags: _running ? 0 : 1,
        onDragStarted: _beginBlockDrag,
        onDragUpdate: _trackBlockDrag,
        onDragEnd: (_) => _endBlockDrag(),
        feedback: Material(
          type: MaterialType.transparency,
          child: SizedBox(width: feedbackWidth, child: feedbackBlock),
        ),
        childWhenDragging: Opacity(opacity: .35, child: block),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            block,
            if (_draggingBlock && _hoverSlot == i)
              Positioned(
                left: 4,
                right: 4,
                top: -3,
                child: _dropIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _dropIndicator() {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        color: C.cyan,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(color: C.cyan.withValues(alpha: .75), blurRadius: 8),
        ],
      ),
    );
  }

  Widget _emptyWorkspace(bool active) {
    return Container(
      height: 66,
      decoration: BoxDecoration(
        color: active
            ? C.cyan.withValues(alpha: .08)
            : C.navyDeep.withValues(alpha: .4),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: active ? C.cyan : C.navyLine,
          width: active ? 1.6 : 1,
        ),
      ),
      child: Center(
        child: Text(
          active ? 'Lepaskan blok di sini' : 'Seret blok ke area ini',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: active ? C.cyan : C.dim,
          ),
        ),
      ),
    );
  }

  Widget _textPreview() {
    final lines = <String>[
      'ketika_dijalankan() {',
      for (final id in _program) '  ${kCmds[id]!.code};',
      '}',
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: C.navyDeep.withValues(alpha: .65),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: C.navyLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pratinjau Kode',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < lines.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                lines[i],
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                  color: i == 0
                      ? C.orangePop
                      : (i == lines.length - 1 ? C.cyanSoft : C.cyan),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── PALET BLOK ──
  Widget _palette() {
    final feedbackWidth = math.min(
      340.0,
      MediaQuery.sizeOf(context).width - 52,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PALET BLOK PERINTAH',
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: .9,
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'Seret blok ke Area Kode, atau ketuk untuk menambah di urutan akhir.',
          style: TextStyle(fontSize: 9.5, color: C.dim, height: 1.3),
        ),
        const SizedBox(height: 9),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            for (final id in kCmds.keys)
              _paletteBlock(id, lv.palette.contains(id), feedbackWidth),
          ],
        ),
      ],
    );
  }

  Widget _paletteBlock(String id, bool enabled, double feedbackWidth) {
    final cmd = kCmds[id]!;
    final canDrag = enabled && !_running;
    final block = _PuzzleBlock(
      color: enabled ? cmd.color : C.dim,
      icon: enabled ? cmd.icon : Icons.lock_rounded,
      code: cmd.code,
      sub: enabled ? cmd.sub : 'belum dibuka',
      compact: true,
      locked: !enabled,
    );
    final feedbackBlock = _PuzzleBlock(
      color: cmd.color,
      icon: cmd.icon,
      code: cmd.code,
      sub: cmd.sub,
    );

    final draggable = Draggable<_BlockDragData>(
      data: _BlockDragData(id),
      maxSimultaneousDrags: canDrag ? 1 : 0,
      onDragStarted: canDrag ? _beginBlockDrag : null,
      onDragUpdate: canDrag ? _trackBlockDrag : null,
      onDragEnd: canDrag ? (_) => _endBlockDrag() : null,
      feedback: Material(
        type: MaterialType.transparency,
        child: SizedBox(width: feedbackWidth, child: feedbackBlock),
      ),
      childWhenDragging: Opacity(opacity: .35, child: block),
      child: block,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: enabled
            ? () => _addBlock(id)
            : () => _toast('Balok ini belum dibuka di level ${lv.number}'),
        child: Opacity(opacity: enabled ? 1 : .55, child: draggable),
      ),
    );
  }

  // ── TIPS CEPAT ──
  Widget _quickTip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: _panel(C.navyCard2, r: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [C.gold, C.orange]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Colors.white,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tips Cepat',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: C.gold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lv.quickTip,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: C.muted,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PUZZLE BLOCK — tampilan blok visual ala Scratch/Blockly
// ============================================================
class _BlockDragData {
  final String id;
  final int? fromIndex; // null = blok baru dari palet
  const _BlockDragData(this.id, {this.fromIndex});
}

class _PuzzleBlock extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String code;
  final String? sub;
  final bool isStart;
  final bool compact;
  final bool locked;
  final bool running;
  final VoidCallback? onDelete;

  const _PuzzleBlock({
    required this.color,
    required this.icon,
    required this.code,
    this.sub,
    this.isStart = false,
    this.compact = false,
    this.locked = false,
    this.running = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PuzzleBlockPainter(
        color: color,
        isStart: isStart,
        compact: compact,
        running: running,
      ),
      child: Padding(
        padding: compact
            ? const EdgeInsets.fromLTRB(9, 8, 8, 7)
            : const EdgeInsets.fromLTRB(11, 10, 8, 9),
        child: Row(
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Icon(
              icon,
              color: C.navyDeep.withValues(alpha: locked ? .55 : .9),
              size: compact ? 12 : 15,
            ),
            SizedBox(width: compact ? 6 : 8),
            if (compact)
              Text(
                code,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: C.navyDeep.withValues(alpha: locked ? .7 : 1),
                  fontFamily: 'monospace',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      code,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: C.navyDeep,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                    if (sub != null)
                      Text(
                        sub!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0x66212B44),
                          fontWeight: FontWeight.w800,
                          fontSize: 9,
                        ),
                      ),
                  ],
                ),
              ),
            if (onDelete != null)
              GestureDetector(
                onTap: onDelete,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: C.navyDeep.withValues(alpha: .14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Color(0x99212B44),
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PuzzleBlockPainter extends CustomPainter {
  final Color color;
  final bool isStart;
  final bool compact;
  final bool running;

  const _PuzzleBlockPainter({
    required this.color,
    required this.isStart,
    required this.compact,
    required this.running,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 4 || size.height <= 4) return;
    final radius = compact ? 8.0 : 11.0;
    final tabW = compact ? 22.0 : 28.0;
    final tabH = compact ? 5.0 : 6.0;
    final tabX = compact ? 14.0 : 18.0;

    final body = RRect.fromLTRBAndCorners(
      0,
      0,
      size.width,
      size.height,
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
    var path = Path()..addRRect(body);

    // Lekuk di atas agar blok bisa disambung dengan blok sebelumnya.
    if (!isStart) {
      final notch = RRect.fromRectAndRadius(
        Rect.fromLTWH(tabX, -tabH, tabW, tabH * 2),
        Radius.circular(tabH),
      );
      path = Path.combine(
        PathOperation.difference,
        path,
        Path()..addRRect(notch),
      );
    }

    // Tonjolan di bawah yang masuk ke lekuk blok berikutnya.
    final tab = RRect.fromRectAndRadius(
      Rect.fromLTWH(tabX, size.height - tabH, tabW, tabH * 2),
      Radius.circular(tabH),
    );
    path = Path.combine(PathOperation.union, path, Path()..addRRect(tab));

    canvas.drawShadow(
      path,
      Colors.black.withValues(alpha: .38),
      compact ? 2 : 4,
      false,
    );
    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color, Color.lerp(color, Colors.black, .10)!],
      ).createShader(Offset.zero & size);
    canvas.drawPath(path, fill);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = running ? 2 : 1
        ..color = running ? Colors.white : Colors.white.withValues(alpha: .14),
    );

    // Kilau tipis di tepi atas supaya blok terlihat premium.
    canvas.save();
    canvas.clipPath(path);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, 1.2),
      Paint()..color = Colors.white.withValues(alpha: .20),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PuzzleBlockPainter old) =>
      old.color != color ||
      old.isStart != isStart ||
      old.compact != compact ||
      old.running != running;
}

// ============================================================
// CARTOON ART — robot, kambing, batu, semak, pohon, tunggul
// ============================================================
class _CartoonArt {
  static void dashedCircle(
    Canvas cv,
    Offset c,
    double radius,
    Paint p, {
    int dashes = 18,
    double duty = 0.55,
  }) {
    final rect = Rect.fromCircle(center: c, radius: radius);
    final step = (2 * math.pi) / dashes;
    for (var i = 0; i < dashes; i++) {
      cv.drawArc(rect, i * step, step * duty, false, p);
    }
  }

  /// Robot: topi oranye, pakaian biru
  static void robot(Canvas cv, Offset c, double s) {
    final suit = Paint()..color = const Color(0xFF2F80ED);
    final suitDark = Paint()..color = const Color(0xFF1B5FBF);
    final skin = Paint()..color = const Color(0xFFFFD9B8);
    final hat = Paint()..color = const Color(0xFFFF8A2B);
    final hatDark = Paint()..color = const Color(0xFFE96A0C);
    final ink = Paint()..color = const Color(0xFF2B2B3A);

    // kaki
    cv.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: c + Offset(-0.13 * s, 0.30 * s),
          width: 0.20 * s,
          height: 0.30 * s,
        ),
        Radius.circular(0.09 * s),
      ),
      suitDark,
    );
    cv.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: c + Offset(0.13 * s, 0.30 * s),
          width: 0.20 * s,
          height: 0.30 * s,
        ),
        Radius.circular(0.09 * s),
      ),
      suitDark,
    );
    // lengan
    cv.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: c + Offset(-0.34 * s, 0.04 * s),
          width: 0.17 * s,
          height: 0.34 * s,
        ),
        Radius.circular(0.08 * s),
      ),
      suit,
    );
    cv.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: c + Offset(0.34 * s, 0.04 * s),
          width: 0.17 * s,
          height: 0.34 * s,
        ),
        Radius.circular(0.08 * s),
      ),
      suit,
    );
    // badan
    cv.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: c + Offset(0, 0.02 * s),
          width: 0.58 * s,
          height: 0.52 * s,
        ),
        Radius.circular(0.19 * s),
      ),
      suit,
    );
    // lencana
    cv.drawCircle(
      c + Offset(0, 0.02 * s),
      0.09 * s,
      Paint()..color = const Color(0xFFCFEAFF),
    );
    // kepala
    cv.drawCircle(c + Offset(0, -0.30 * s), 0.27 * s, skin);
    // mahkota topi
    cv.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: c + Offset(0, -0.50 * s),
          width: 0.42 * s,
          height: 0.30 * s,
        ),
        Radius.circular(0.14 * s),
      ),
      hat,
    );
    // brim topi
    cv.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: c + Offset(0, -0.35 * s),
          width: 0.64 * s,
          height: 0.11 * s,
        ),
        Radius.circular(0.055 * s),
      ),
      hatDark,
    );
    // mata
    cv.drawCircle(c + Offset(-0.09 * s, -0.30 * s), 0.035 * s, ink);
    cv.drawCircle(c + Offset(0.09 * s, -0.30 * s), 0.035 * s, ink);
    // senyum
    cv.drawArc(
      Rect.fromCenter(
        center: c + Offset(0, -0.245 * s),
        width: 0.20 * s,
        height: 0.16 * s,
      ),
      0,
      math.pi,
      false,
      Paint()
        ..color = ink.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.032 * s
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Kambing putih lucu (karakter sasaran level 1)
  static void goat(Canvas cv, Offset c, double s) {
    final cream = Paint()..color = const Color(0xFFFDF6EC);
    final creamShade = Paint()..color = const Color(0xFFE6DACB);
    final horn = Paint()..color = const Color(0xFFC9B79A);
    final hoof = Paint()..color = const Color(0xFF5C5163);
    final ink = Paint()..color = const Color(0xFF3A3A4A);
    final blush = Paint()..color = const Color(0xFFFFAFA0);

    // kaki ramping + sendok
    for (final dx in [-0.16, -0.06, 0.07, 0.17]) {
      cv.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: c + Offset(dx * s, 0.28 * s),
            width: 0.07 * s,
            height: 0.22 * s,
          ),
          Radius.circular(0.03 * s),
        ),
        hoof,
      );
    }
    // ekor miring ke atas
    cv.drawCircle(c + Offset(-0.27 * s, -0.02 * s), 0.06 * s, creamShade);

    // badan (oval, lebih langsing dari domba)
    cv.drawOval(
      Rect.fromCenter(
        center: c + Offset(-0.02 * s, 0.02 * s),
        width: 0.52 * s,
        height: 0.40 * s,
      ),
      cream,
    );
    cv.drawOval(
      Rect.fromCenter(
        center: c + Offset(-0.02 * s, 0.10 * s),
        width: 0.46 * s,
        height: 0.22 * s,
      ),
      creamShade,
    );

    // tanduk melengkung ke belakang
    for (final sx in [-0.10, 0.10]) {
      final p = Path()
        ..moveTo(c.dx + sx * s, c.dy - 0.30 * s)
        ..quadraticBezierTo(
          c.dx + (sx - 0.06) * s,
          c.dy - 0.50 * s,
          c.dx + (sx - 0.16) * s,
          c.dy - 0.46 * s,
        )
        ..lineTo(c.dx + (sx - 0.14) * s, c.dy - 0.40 * s)
        ..quadraticBezierTo(
          c.dx + (sx - 0.08) * s,
          c.dy - 0.42 * s,
          c.dx + (sx + 0.02) * s,
          c.dy - 0.26 * s,
        )
        ..close();
      cv.drawPath(p, horn);
    }

    // telinga jatuh ke samping
    cv.drawOval(
      Rect.fromCenter(
        center: c + Offset(-0.14 * s, -0.24 * s),
        width: 0.16 * s,
        height: 0.09 * s,
      ),
      creamShade,
    );
    cv.drawOval(
      Rect.fromCenter(
        center: c + Offset(0.16 * s, -0.24 * s),
        width: 0.16 * s,
        height: 0.09 * s,
      ),
      creamShade,
    );

    // kepala
    cv.drawCircle(c + Offset(0.01 * s, -0.28 * s), 0.18 * s, cream);
    // jenggot
    cv.drawPath(
      Path()
        ..moveTo(c.dx - 0.05 * s, c.dy - 0.16 * s)
        ..lineTo(c.dx + 0.07 * s, c.dy - 0.16 * s)
        ..lineTo(c.dx + 0.01 * s, c.dy - 0.02 * s)
        ..close(),
      creamShade,
    );
    // mata + senyum
    cv.drawCircle(c + Offset(-0.05 * s, -0.30 * s), 0.030 * s, ink);
    cv.drawCircle(c + Offset(0.07 * s, -0.30 * s), 0.030 * s, ink);
    cv.drawArc(
      Rect.fromCenter(
        center: c + Offset(0.01 * s, -0.25 * s),
        width: 0.13 * s,
        height: 0.10 * s,
      ),
      0,
      math.pi,
      false,
      Paint()
        ..color = ink.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.026 * s
        ..strokeCap = StrokeCap.round,
    );
    // pipi
    cv.drawCircle(c + Offset(-0.11 * s, -0.24 * s), 0.032 * s, blush);
    cv.drawCircle(c + Offset(0.13 * s, -0.24 * s), 0.032 * s, blush);
  }

  static void rock(Canvas cv, Offset c, double s) {
    final g = Paint()..color = const Color(0xFF8A94A8);
    final gDark = Paint()..color = const Color(0xFF636C80);
    final body = Path()
      ..moveTo(c.dx - 0.30 * s, c.dy + 0.10 * s)
      ..lineTo(c.dx - 0.22 * s, c.dy - 0.18 * s)
      ..lineTo(c.dx + 0.02 * s, c.dy - 0.28 * s)
      ..lineTo(c.dx + 0.28 * s, c.dy - 0.12 * s)
      ..lineTo(c.dx + 0.24 * s, c.dy + 0.12 * s)
      ..close();
    cv.drawPath(body, g);
    cv.drawPath(
      Path()
        ..moveTo(c.dx + 0.02 * s, c.dy - 0.28 * s)
        ..lineTo(c.dx + 0.28 * s, c.dy - 0.12 * s)
        ..lineTo(c.dx + 0.24 * s, c.dy + 0.12 * s)
        ..lineTo(c.dx + 0.06 * s, c.dy + 0.10 * s)
        ..close(),
      gDark,
    );
  }

  /// Domba woolly. [shorn] = true kalau wolnya sudah dicukur.
  static void sheep(Canvas cv, Offset c, double s, {bool shorn = false}) {
    final wool = Paint()..color = const Color(0xFFF7F3EC);
    final woolShade = Paint()..color = const Color(0xFFDDD3C4);
    final skin = Paint()..color = const Color(0xFF4A4356);
    final ink = Paint()..color = const Color(0xFF3A3A4A);

    cv.drawOval(
      Rect.fromCenter(
        center: c + Offset(0, 0.14 * s),
        width: 0.44 * s,
        height: 0.14 * s,
      ),
      Paint()..color = const Color(0x33000000),
    );
    // kaki
    for (final dx in [-0.17, -0.06, 0.07, 0.18]) {
      cv.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: c + Offset(dx * s, 0.24 * s),
            width: 0.07 * s,
            height: 0.20 * s,
          ),
          Radius.circular(0.03 * s),
        ),
        skin,
      );
    }

    if (shorn) {
      // Setelah dicukur: badan lebih langsing, tanpa bulatan wol
      cv.drawOval(
        Rect.fromCenter(
          center: c + Offset(-0.02 * s, 0.02 * s),
          width: 0.50 * s,
          height: 0.34 * s,
        ),
        skin,
      );
      cv.drawOval(
        Rect.fromCenter(
          center: c + Offset(-0.02 * s, 0.10 * s),
          width: 0.42 * s,
          height: 0.16 * s,
        ),
        Paint()..color = const Color(0xFF5C5468),
      );
    } else {
      // badan berbulu: kumpulan bulatan
      cv.drawCircle(c + Offset(-0.02 * s, 0.02 * s), 0.19 * s, wool);
      cv.drawCircle(c + Offset(-0.19 * s, 0.06 * s), 0.13 * s, wool);
      cv.drawCircle(c + Offset(0.16 * s, 0.06 * s), 0.13 * s, wool);
      cv.drawCircle(c + Offset(-0.10 * s, -0.10 * s), 0.13 * s, wool);
      cv.drawCircle(c + Offset(0.09 * s, -0.10 * s), 0.13 * s, wool);
      cv.drawCircle(c + Offset(-0.02 * s, -0.13 * s), 0.14 * s, wool);
      cv.drawCircle(c + Offset(0.02 * s, 0.10 * s), 0.15 * s, woolShade);
    }

    // kepala
    cv.drawCircle(c + Offset(0.22 * s, -0.10 * s), 0.13 * s, skin);
    // telinga
    cv.drawOval(
      Rect.fromCenter(
        center: c + Offset(0.13 * s, -0.16 * s),
        width: 0.13 * s,
        height: 0.07 * s,
      ),
      skin,
    );
    // mata
    cv.drawCircle(c + Offset(0.25 * s, -0.12 * s), 0.026 * s, ink);
    cv.drawCircle(c + Offset(0.31 * s, -0.12 * s), 0.026 * s, ink);
    // senyum
    cv.drawArc(
      Rect.fromCenter(
        center: c + Offset(0.26 * s, -0.07 * s),
        width: 0.10 * s,
        height: 0.08 * s,
      ),
      0,
      math.pi,
      false,
      Paint()
        ..color = ink.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.022 * s
        ..strokeCap = StrokeCap.round,
    );
    // ekor
    cv.drawCircle(
      c + Offset(-0.22 * s, -0.04 * s),
      0.055 * s,
      shorn ? skin : wool,
    );
  }

  static void tree(Canvas cv, Offset c, double s) {
    // bayangan lembut di dasar
    cv.drawOval(
      Rect.fromCenter(
        center: c + Offset(0, 0.16 * s),
        width: 0.46 * s,
        height: 0.16 * s,
      ),
      Paint()..color = const Color(0x33000000),
    );
    // batang
    cv.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: c + Offset(0, 0.02 * s),
          width: 0.13 * s,
          height: 0.30 * s,
        ),
        Radius.circular(0.03 * s),
      ),
      Paint()..color = const Color(0xFF6B4A2F),
    );
    cv.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: c + Offset(-0.03 * s, 0.02 * s),
          width: 0.05 * s,
          height: 0.28 * s,
        ),
        Radius.circular(0.02 * s),
      ),
      Paint()..color = const Color(0xFF8A6242),
    );
    // tajuk: bulatan bertumpuk, hijau tua + highlight
    final dark = Paint()..color = const Color(0xFF1E6B34);
    final mid = Paint()..color = const Color(0xFF2F9E63);
    final light = Paint()..color = const Color(0xFF5ECB86);
    cv.drawCircle(c + Offset(0, -0.20 * s), 0.21 * s, dark);
    cv.drawCircle(c + Offset(-0.17 * s, -0.10 * s), 0.15 * s, dark);
    cv.drawCircle(c + Offset(0.17 * s, -0.10 * s), 0.15 * s, dark);
    cv.drawCircle(c + Offset(0, -0.26 * s), 0.17 * s, mid);
    cv.drawCircle(c + Offset(-0.14 * s, -0.16 * s), 0.11 * s, mid);
    cv.drawCircle(c + Offset(0.14 * s, -0.16 * s), 0.11 * s, mid);
    cv.drawCircle(c + Offset(-0.05 * s, -0.32 * s), 0.09 * s, light);
    cv.drawCircle(c + Offset(0.09 * s, -0.22 * s), 0.06 * s, light);
  }

  /// Tunggul yang tersisa setelah pohon ditebang.
  static void stump(Canvas cv, Offset c, double s) {
    cv.drawOval(
      Rect.fromCenter(
        center: c + Offset(0, 0.12 * s),
        width: 0.34 * s,
        height: 0.12 * s,
      ),
      Paint()..color = const Color(0x33000000),
    );
    cv.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: c + Offset(0, 0.02 * s),
          width: 0.24 * s,
          height: 0.20 * s,
        ),
        Radius.circular(0.04 * s),
      ),
      Paint()..color = const Color(0xFF6B4A2F),
    );
    cv.drawOval(
      Rect.fromCenter(
        center: c + Offset(0, -0.07 * s),
        width: 0.24 * s,
        height: 0.10 * s,
      ),
      Paint()..color = const Color(0xFFB98A5E),
    );
    cv.drawOval(
      Rect.fromCenter(
        center: c + Offset(0, -0.07 * s),
        width: 0.14 * s,
        height: 0.06 * s,
      ),
      Paint()..color = const Color(0xFF8A6242),
    );
  }

  /// Papan dinding yang dipasang lewat place(): kayu atau batu bata.
  static void plank(Canvas cv, Offset c, double s, {bool stone = false}) {
    final w = 0.27 * s;
    final h = 0.135 * s;
    final ht = 0.20 * s;
    final topP = Offset(c.dx, c.dy - h);
    final rightP = Offset(c.dx + w, c.dy);
    final frontP = Offset(c.dx, c.dy + h);
    final leftP = Offset(c.dx - w, c.dy);

    // bayangan lembut di dasar
    cv.drawOval(
      Rect.fromCenter(
        center: c + Offset(0, ht * 0.8),
        width: w * 2.1,
        height: h * 2.1,
      ),
      Paint()..color = const Color(0x33000000),
    );

    final left = Paint()
      ..color = stone ? const Color(0xFF8B94A8) : const Color(0xFF9C6B3B);
    final right = Paint()
      ..color = stone ? const Color(0xFFA9B2C4) : const Color(0xFFC08A50);
    final top = Paint()
      ..color = stone ? const Color(0xFFCFD6E4) : const Color(0xFFE3B27C);

    // sisi kiri
    cv.drawPath(
      Path()
        ..moveTo(leftP.dx, leftP.dy)
        ..lineTo(frontP.dx, frontP.dy)
        ..lineTo(frontP.dx, frontP.dy + ht)
        ..lineTo(leftP.dx, leftP.dy + ht)
        ..close(),
      left,
    );
    // sisi kanan
    cv.drawPath(
      Path()
        ..moveTo(rightP.dx, rightP.dy)
        ..lineTo(frontP.dx, frontP.dy)
        ..lineTo(frontP.dx, frontP.dy + ht)
        ..lineTo(rightP.dx, rightP.dy + ht)
        ..close(),
      right,
    );
    // muka atas
    cv.drawPath(
      Path()
        ..moveTo(topP.dx, topP.dy)
        ..lineTo(rightP.dx, rightP.dy)
        ..lineTo(frontP.dx, frontP.dy)
        ..lineTo(leftP.dx, leftP.dy)
        ..close(),
      top,
    );

    // pola material: serat papan untuk kayu, nat bata untuk batu
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.020 * s
      ..strokeCap = StrokeCap.round
      ..color = (stone ? const Color(0xFF6E778C) : const Color(0xFFB07E45))
          .withValues(alpha: .85);
    if (stone) {
      cv.drawLine(
        Offset.lerp(topP, leftP, .5)!,
        Offset.lerp(rightP, frontP, .5)!,
        line,
      );
      cv.drawLine(
        Offset.lerp(topP, rightP, .5)!,
        Offset.lerp(leftP, frontP, .5)!,
        line,
      );
    } else {
      for (final u in const [0.33, 0.67]) {
        cv.drawLine(
          Offset.lerp(topP, leftP, u)!,
          Offset.lerp(rightP, frontP, u)!,
          line,
        );
      }
    }
    // garis pemisah dua sisi depan
    cv.drawLine(frontP, frontP + Offset(0, ht), line);
  }

  static void bush(Canvas cv, Offset c, double s) {
    cv.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: c + Offset(0, 0.20 * s),
          width: 0.14 * s,
          height: 0.22 * s,
        ),
        Radius.circular(0.05 * s),
      ),
      Paint()..color = const Color(0xFF6B4A2F),
    );
    final leaf = Paint()..color = const Color(0xFF2F9E63);
    final leaf2 = Paint()..color = const Color(0xFF3FBE77);
    cv.drawCircle(c + Offset(0, -0.02 * s), 0.20 * s, leaf);
    cv.drawCircle(c + Offset(-0.16 * s, 0.04 * s), 0.15 * s, leaf);
    cv.drawCircle(c + Offset(0.16 * s, 0.04 * s), 0.15 * s, leaf);
    cv.drawCircle(c + Offset(-0.04 * s, -0.12 * s), 0.14 * s, leaf2);
  }
}

// ============================================================
// ARENA PAINTER — papan isometrik
// ============================================================
enum _ItemKind {
  bush,
  rock,
  robot,
  goat,
  tree,
  stump,
  sheep,
  sheepShorn,
  plank,
  plankActive,
}

class _Item {
  final double r, c;
  final _ItemKind kind;
  final int mat; // material papan: 0 = kayu, 1 = batu
  final int index; // indeks pohon/domba di data level
  _Item(num r, num c, this.kind, [this.mat = 0, this.index = -1])
    : r = r.toDouble(),
      c = c.toDouble();
}

class _ArenaPainter extends CustomPainter {
  final int size;
  final List<List<int>> rocks;
  final List<List<int>> bushes;
  final List<List<int>> trees;
  final List<bool> treesChopped; // sejajar dengan trees
  final List<List<int>> sheep;
  final List<bool> sheepShorn; // sejajar dengan sheep
  final List<List<int>> walls; // petak area bangunan
  final List<List<int>> placed; // papan terpasang: [row, col, material]
  final double robotRow, robotCol, robotDir;
  final int goalRow, goalCol;
  final ui.Image?
  karakter; // sprite karakter pemain (null = pakai gambar bawaan)
  final ui.Image? domba; // sprite domba (null = pakai gambar bawaan)
  final ui.Image? pohon; // sprite pohon (null = pakai gambar bawaan)

  // ── Visual (tidak memengaruhi logika) ─────────────────────
  final BoardTheme theme;
  final RobotPose pose;
  final double poseT, idleT;
  final bool jump;
  final int? activeTree;
  final int? activeSheep;
  final String? activePlank;
  final int activePlankMat;
  final CostumeItem? hat;
  final CostumeItem? shirt;
  final CostumeItem? shoes;
  final CostumeItem? scarf;
  final CostumeItem? wings;
  final CostumeItem? accessory;

  _ArenaPainter({
    required this.size,
    required this.rocks,
    required this.bushes,
    required this.trees,
    required this.treesChopped,
    required this.sheep,
    required this.sheepShorn,
    required this.walls,
    required this.placed,
    required this.robotRow,
    required this.robotCol,
    required this.robotDir,
    required this.goalRow,
    required this.goalCol,
    this.karakter,
    this.domba,
    this.pohon,
    this.theme = BoardTheme.padangRumput,
    this.pose = RobotPose.idle,
    this.poseT = 1,
    this.idleT = 0,
    this.jump = false,
    this.activeTree,
    this.activeSheep,
    this.activePlank,
    this.activePlankMat = 0,
    this.hat,
    this.shirt,
    this.shoes,
    this.scarf,
    this.wings,
    this.accessory,
  });

  bool _placedAt(int r, int c) => placed.any((p) => p[0] == r && p[1] == c);

  /// Dekorasi kecil di atas petak, deterministik berdasarkan (r, c)
  /// supaya tidak berubah-ubah tiap frame.
  void _paintTileDecor(
    Canvas cv,
    Offset p,
    double tw,
    double th,
    int r,
    int c,
  ) {
    final seed = (r * 17 + c * 31) % 9;
    final a = tw * 0.11;
    switch (theme.decorKind) {
      case BoardDecor.flowers:
        if (seed > 2) return;
        final cx = p.dx + (seed - 1) * tw * 0.16;
        final cy = p.dy + (seed.isEven ? 1 : -1) * th * 0.10;
        cv.drawLine(
          Offset(cx, cy),
          Offset(cx, cy - a * 0.9),
          Paint()
            ..color = const Color(0xFF3C7D24)
            ..strokeWidth = tw * 0.012
            ..strokeCap = StrokeCap.round,
        );
        cv.drawCircle(
          Offset(cx, cy - a * 1.1),
          a * 0.42,
          Paint()..color = theme.decor,
        );
        cv.drawCircle(
          Offset(cx, cy - a * 1.1),
          a * 0.18,
          Paint()..color = const Color(0xFFFFF3B0),
        );
        break;
      case BoardDecor.pebbles:
        if (seed != 0 && seed != 4 && seed != 7) return;
        cv.drawOval(
          Rect.fromCenter(
            center: p + Offset((seed - 3) * tw * 0.10, th * 0.05),
            width: a * 1.4,
            height: a * 0.7,
          ),
          Paint()..color = theme.decor.withValues(alpha: .7),
        );
        break;
      case BoardDecor.conifer:
        if (seed != 1 && seed != 5 && seed != 8) return;
        final cx = p.dx + (seed - 4) * tw * 0.10;
        final cy = p.dy - th * 0.04;
        final tri = Path()
          ..moveTo(cx, cy - a * 1.5)
          ..lineTo(cx + a * 0.8, cy + a * 0.4)
          ..lineTo(cx - a * 0.8, cy + a * 0.4)
          ..close();
        cv.drawPath(tri, Paint()..color = theme.decor.withValues(alpha: .8));
        break;
      case BoardDecor.straw:
        if (seed != 2 && seed != 5) return;
        final cx = p.dx + (seed - 3) * tw * 0.10;
        final cy = p.dy + th * 0.04;
        final line = Paint()
          ..color = theme.decor.withValues(alpha: .65)
          ..strokeWidth = tw * 0.012
          ..strokeCap = StrokeCap.round;
        cv.drawLine(
          Offset(cx - a, cy),
          Offset(cx + a * 0.8, cy - a * 0.5),
          line,
        );
        cv.drawLine(
          Offset(cx - a * 0.6, cy + a * 0.4),
          Offset(cx + a, cy),
          line,
        );
        break;
      case BoardDecor.foundation:
        final line = Paint()
          ..color = theme.edge.withValues(alpha: .16)
          ..strokeWidth = tw * 0.008;
        cv.drawLine(
          Offset(p.dx - tw * 0.30, p.dy),
          Offset(p.dx + tw * 0.30, p.dy),
          line,
        );
        cv.drawLine(
          Offset(p.dx, p.dy - th * 0.30),
          Offset(p.dx, p.dy + th * 0.30),
          line,
        );
        if (seed == 0) {
          cv.drawCircle(
            Offset(p.dx, p.dy),
            tw * 0.018,
            Paint()..color = theme.accent.withValues(alpha: .55),
          );
        }
        break;
    }
  }

  @override
  void paint(Canvas canvas, Size sz) {
    if (sz.width <= 0 || sz.height <= 0) return;
    final n = size;

    var tw = sz.width * 0.90 / (n + 0.55);
    var th = tw * 0.5;
    var depth = th * 0.85;
    final needH = n * th + depth;
    final availH = sz.height * 0.94;
    if (needH > availH && needH > 0) {
      final k = availH / needH;
      tw *= k;
      th *= k;
      depth *= k;
    }

    final ox = sz.width / 2;
    final oy = (sz.height - (n * th + depth)) / 2 + th / 2;

    Offset center(num r, num c) => Offset(
      ox + (c.toDouble() - r.toDouble()) * tw / 2,
      oy + (r.toDouble() + c.toDouble()) * th / 2,
    );

    final top = Offset(ox, oy - th / 2);
    final right = center(n - 1, 0) + Offset(tw / 2, 0);
    final bottom = center(n - 1, n - 1) + Offset(0, th / 2);
    final left = center(0, n - 1) + Offset(-tw / 2, 0);

    // sisi papan (efek 3D)
    canvas.drawPath(
      Path()
        ..moveTo(bottom.dx, bottom.dy)
        ..lineTo(left.dx, left.dy)
        ..lineTo(left.dx, left.dy + depth)
        ..lineTo(bottom.dx, bottom.dy + depth)
        ..close(),
      Paint()..color = Color.lerp(theme.side, Colors.black, 0.2)!,
    );
    canvas.drawPath(
      Path()
        ..moveTo(right.dx, right.dy)
        ..lineTo(bottom.dx, bottom.dy)
        ..lineTo(bottom.dx, bottom.dy + depth)
        ..lineTo(right.dx, right.dy + depth)
        ..close(),
      Paint()..color = theme.side,
    );

    // alas papan
    final base = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy)
      ..close();
    canvas.drawPath(base, Paint()..color = theme.top);

    // petak
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = theme.edge.withValues(alpha: .22);
    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        final p = center(r, c);
        final tile = Path()
          ..moveTo(p.dx, p.dy - th / 2)
          ..lineTo(p.dx + tw / 2, p.dy)
          ..lineTo(p.dx, p.dy + th / 2)
          ..lineTo(p.dx - tw / 2, p.dy)
          ..close();
        canvas.drawPath(
          tile,
          Paint()..color = (r + c).isEven ? theme.top : theme.top2,
        );
        _paintTileDecor(canvas, p, tw, th, r, c);
        canvas.drawPath(tile, stroke);
        // area bangunan yang belum dipasangi papan: garis oranye putus-putus
        if (walls.any((w) => w[0] == r && w[1] == c) &&
            !_placedAt(r, c) &&
            activePlank != '$r,$c') {
          canvas.drawPath(
            tile,
            Paint()..color = C.orangePop.withValues(alpha: .16),
          );
          _dashDiamond(
            canvas,
            p,
            tw / 2,
            th / 2,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.7
              ..strokeCap = StrokeCap.round
              ..color = C.orangePop.withValues(alpha: .9),
          );
        }
      }
    }

    // objek di atas papan, diurutkan kedalaman
    final items = <_Item>[];
    for (final b in bushes) {
      items.add(_Item(b[0], b[1], _ItemKind.bush));
    }
    for (final k in rocks) {
      items.add(_Item(k[0], k[1], _ItemKind.rock));
    }
    // Pohon menggantikan sasaran kambing; setelah ditebang tinggal tunggul.
    for (var i = 0; i < trees.length; i++) {
      final cut = i < treesChopped.length && treesChopped[i];
      items.add(
        _Item(
          trees[i][0],
          trees[i][1],
          cut ? _ItemKind.stump : _ItemKind.tree,
          0,
          i,
        ),
      );
    }
    // Domba juga menggantikan sasaran kambing; setelah dicukur wolnya hilang.
    for (var i = 0; i < sheep.length; i++) {
      final done = i < sheepShorn.length && sheepShorn[i];
      items.add(
        _Item(
          sheep[i][0],
          sheep[i][1],
          done ? _ItemKind.sheepShorn : _ItemKind.sheep,
          0,
          i,
        ),
      );
    }
    // Papan yang sudah dipasang di petak area bangunan.
    for (final p in placed) {
      items.add(_Item(p[0], p[1], _ItemKind.plank, p[2]));
    }
    // Papan yang sedang dianimasikan muncul (belum masuk _placed).
    if (activePlank != null) {
      final parts = activePlank!.split(',');
      if (parts.length == 2) {
        final ar = int.tryParse(parts[0]);
        final ac = int.tryParse(parts[1]);
        if (ar != null && ac != null && !_placedAt(ar, ac)) {
          items.add(_Item(ar, ac, _ItemKind.plankActive, activePlankMat));
        }
      }
    }
    if (trees.isEmpty && sheep.isEmpty && walls.isEmpty) {
      items.add(_Item(goalRow, goalCol, _ItemKind.goat));
    }
    items.add(_Item(robotRow, robotCol, _ItemKind.robot));
    // Urutkan kedalaman; papan selalu lebih dulu di petak yang sama,
    // dan robot selalu digambar di atas papan yang ia injak.
    items.sort((a, b) {
      final aPlank =
          a.kind == _ItemKind.plank || a.kind == _ItemKind.plankActive;
      final bPlank =
          b.kind == _ItemKind.plank || b.kind == _ItemKind.plankActive;
      final ka = (a.r + a.c) * 2 + (aPlank ? 0 : 1);
      final kb = (b.r + b.c) * 2 + (bPlank ? 0 : 1);
      final cmp = ka.compareTo(kb);
      if (cmp != 0) return cmp;
      if (a.kind == _ItemKind.robot) return 1;
      if (b.kind == _ItemKind.robot) return -1;
      return 0;
    });

    final scale = tw * 0.92;

    for (final it in items) {
      final p = center(it.r, it.c);
      // duduk di atas muka petak
      final base = p + Offset(0, th * 0.06);
      switch (it.kind) {
        case _ItemKind.bush:
          // Semak dekoratif di semua level memakai sprite pohon terbaru.
          final bushImg = pohon;
          if (bushImg != null) {
            final h = scale * 0.70;
            final w = h * bushImg.width / bushImg.height;
            final dst = Rect.fromLTWH(
              base.dx - w / 2,
              base.dy + scale * 0.14 - h,
              w,
              h,
            );
            canvas.drawImageRect(
              bushImg,
              Rect.fromLTWH(
                0,
                0,
                bushImg.width.toDouble(),
                bushImg.height.toDouble(),
              ),
              dst,
              Paint()..filterQuality = FilterQuality.medium,
            );
          } else {
            _CartoonArt.bush(canvas, base, scale * 0.58);
          }
          break;
        case _ItemKind.rock:
          _CartoonArt.rock(canvas, base, scale * 0.68);
          break;
        case _ItemKind.tree:
          final falling = it.index == activeTree;
          final fall = falling
              ? Curves.easeInCubic.transform(poseT.clamp(0.0, 1.0))
              : 0.0;
          if (falling) {
            canvas.save();
            canvas.translate(base.dx, base.dy);
            canvas.rotate(0.92 * fall);
            canvas.translate(-base.dx, -base.dy);
          }
          final pohonImg = pohon;
          if (pohonImg != null) {
            final h = scale * 0.88;
            final w = h * pohonImg.width / pohonImg.height;
            final dst = Rect.fromLTWH(
              base.dx - w / 2,
              base.dy + scale * 0.14 - h,
              w,
              h,
            );
            canvas.drawImageRect(
              pohonImg,
              Rect.fromLTWH(
                0,
                0,
                pohonImg.width.toDouble(),
                pohonImg.height.toDouble(),
              ),
              dst,
              Paint()..filterQuality = FilterQuality.medium,
            );
          } else {
            _CartoonArt.tree(canvas, base, scale * 0.70);
          }
          if (falling) canvas.restore();
          break;
        case _ItemKind.stump:
          _CartoonArt.stump(canvas, base, scale * 0.55);
          break;
        case _ItemKind.sheep:
          final active = it.index == activeSheep;
          final shearP = active
              ? Curves.easeOutCubic.transform(poseT.clamp(0.0, 1.0))
              : 0.0;
          if (active) {
            canvas.save();
            canvas.translate(base.dx, base.dy);
            canvas.scale(
              1 + 0.08 * math.sin(shearP * math.pi),
              1 - 0.14 * shearP,
            );
            canvas.translate(-base.dx, -base.dy);
          }
          final dombaImg = domba;
          if (dombaImg != null) {
            final h = scale * 0.62;
            final w = h * dombaImg.width / dombaImg.height;
            final dst = Rect.fromLTWH(
              base.dx - w / 2,
              base.dy + scale * 0.16 - h,
              w,
              h,
            );
            canvas.drawImageRect(
              dombaImg,
              Rect.fromLTWH(
                0,
                0,
                dombaImg.width.toDouble(),
                dombaImg.height.toDouble(),
              ),
              dst,
              Paint()..filterQuality = FilterQuality.medium,
            );
          } else {
            _CartoonArt.sheep(canvas, base, scale * 0.58);
          }
          if (active) {
            canvas.restore();
            // Gumpalan wool terbang saat domba dicukur.
            for (var i = 0; i < 6; i++) {
              final a = -math.pi / 2 + (i - 2.5) * 0.34;
              final d = shearP * scale * (0.20 + i * 0.025);
              final pos =
                  base +
                  Offset(math.cos(a), math.sin(a)) * d -
                  Offset(0, scale * 0.28);
              canvas.drawCircle(
                pos,
                scale * 0.035 * (1 - shearP * 0.55),
                Paint()..color = Colors.white.withValues(alpha: 1 - shearP),
              );
            }
          }
          break;
        case _ItemKind.sheepShorn:
          _CartoonArt.sheep(canvas, base, scale * 0.58, shorn: true);
          break;
        case _ItemKind.plank:
          _CartoonArt.plank(canvas, base, scale * 0.9, stone: it.mat == 1);
          break;
        case _ItemKind.plankActive:
          final pop = Curves.easeOutBack.transform(poseT.clamp(0.0, 1.0));
          canvas.save();
          canvas.translate(base.dx, base.dy);
          canvas.scale(0.2 + 0.8 * pop);
          canvas.translate(-base.dx, -base.dy);
          _CartoonArt.plank(canvas, base, scale * 0.9, stone: it.mat == 1);
          canvas.restore();
          break;
        case _ItemKind.robot:
          final lift = jump
              ? math.sin(poseT.clamp(0.0, 1.0) * math.pi) * scale * 0.45
              : 0.0;
          paintKodi(
            canvas,
            ground: base,
            scale: scale,
            pose: pose,
            poseT: poseT,
            idleT: idleT,
            dir: robotDir,
            sprite: karakter,
            hat: hat,
            shirt: shirt,
            shoes: shoes,
            scarf: scarf,
            wings: wings,
            accessory: accessory,
            lift: lift,
          );
          break;
        case _ItemKind.goat:
          // lingkaran target oranye putus-putus
          _CartoonArt.dashedCircle(
            canvas,
            base,
            scale * 0.30,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = scale * 0.038
              ..color = C.orangePop,
            dashes: 14,
            duty: 0.5,
          );
          // Sasaran kambing memakai sprite domba terbaru kalau tersedia.
          final kambingImg = domba;
          if (kambingImg != null) {
            final h = scale * 0.62;
            final w = h * kambingImg.width / kambingImg.height;
            final dst = Rect.fromLTWH(
              base.dx - w / 2,
              base.dy + scale * 0.16 - h,
              w,
              h,
            );
            canvas.drawImageRect(
              kambingImg,
              Rect.fromLTWH(
                0,
                0,
                kambingImg.width.toDouble(),
                kambingImg.height.toDouble(),
              ),
              dst,
              Paint()..filterQuality = FilterQuality.medium,
            );
          } else {
            _CartoonArt.goat(canvas, base, scale * 0.58);
          }
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ArenaPainter old) =>
      old.karakter != karakter ||
      old.domba != domba ||
      old.pohon != pohon ||
      old.robotRow != robotRow ||
      old.robotCol != robotCol ||
      old.robotDir != robotDir ||
      old.goalRow != goalRow ||
      old.goalCol != goalCol ||
      old.theme != theme ||
      old.pose != pose ||
      old.poseT != poseT ||
      old.idleT != idleT ||
      old.jump != jump ||
      old.activeTree != activeTree ||
      old.activeSheep != activeSheep ||
      old.activePlank != activePlank ||
      old.activePlankMat != activePlankMat ||
      old.hat != hat ||
      old.shirt != shirt ||
      old.shoes != shoes ||
      old.scarf != scarf ||
      old.wings != wings ||
      old.accessory != accessory ||
      !_sameFlags(old.treesChopped, treesChopped) ||
      !_sameFlags(old.sheepShorn, sheepShorn) ||
      !_sameGrid(old.walls, walls) ||
      !_sameGrid(old.placed, placed);

  static bool _sameFlags(List<bool> a, List<bool> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _sameGrid(List<List<int>> a, List<List<int>> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].length != b[i].length) return false;
      for (var j = 0; j < a[i].length; j++) {
        if (a[i][j] != b[i][j]) return false;
      }
    }
    return true;
  }

  /// Garis putus-putus berbentuk belah ketupat untuk menandai petak
  /// area bangunan (setengah lebar [hw], setengah tinggi [hh]).
  static void _dashDiamond(
    Canvas cv,
    Offset p,
    double hw,
    double hh,
    Paint paint,
  ) {
    final pts = <Offset>[
      Offset(p.dx, p.dy - hh),
      Offset(p.dx + hw, p.dy),
      Offset(p.dx, p.dy + hh),
      Offset(p.dx - hw, p.dy),
    ];
    const seg = 3;
    for (var i = 0; i < 4; i++) {
      final a = pts[i];
      final b = pts[(i + 1) % 4];
      for (var k = 0; k < seg; k++) {
        final t0 = k / seg;
        final t1 = t0 + 0.55 / seg;
        cv.drawLine(Offset.lerp(a, b, t0)!, Offset.lerp(a, b, t1)!, paint);
      }
    }
  }
}

// ============================================================
// 3. LEVEL MAP SCREEN
// ============================================================
class LevelMapScreen extends StatelessWidget {
  const LevelMapScreen({super.key});

  /// Total bintang maksimum seluruh level (untuk StatChip di kepala peta).
  int get _maxStars => kLevels.fold<int>(0, (a, l) => a + l.starTarget);

  @override
  Widget build(BuildContext context) {
    // Peta dibangun ulang otomatis tiap kali progres berubah.
    return ValueListenableBuilder<int>(
      valueListenable: GameProgress.instance.changes,
      builder: (context, _, _) => _buildMap(context),
    );
  }

  Widget _buildMap(BuildContext context) {
    final prog = GameProgress.instance;
    // Kunci progresif: level baru terbuka setelah level sebelumnya selesai.
    final levels = [
      for (final lv in kLevels)
        (lv, prog.isUnlocked(lv.number) ? 'open' : 'lock'),
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dunia 1',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              StatChip(
                Icons.star_rounded,
                C.gold,
                '${prog.totalStars} / $_maxStars',
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            itemCount: levels.length,
            itemBuilder: (_, i) {
              final (lv, state) = levels[i];
              final locked = state == 'lock';
              final color = locked ? C.navyCard2 : C.green;
              return Align(
                alignment: i.isEven
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: state == 'lock'
                            ? null
                            : () => Navigator.push(
                                context,
                                playfulRoute(ChallengeScreen(level: lv)),
                              ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: color,
                          child: Icon(
                            locked ? Icons.lock_rounded : Icons.smart_toy,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${lv.number}. ${lv.title}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: locked ? C.muted : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var s = 0; s < lv.starTarget; s++)
                            Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: s < prog.starsOf(lv.number)
                                  ? C.gold
                                  : C.navyLine,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: C.navyCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: C.navyLine),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .28),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MISI AKTIF',
                style: TextStyle(
                  fontSize: 10,
                  color: C.cyan,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 3),
              // ikut data level supaya tidak pernah basi kalau konten berubah
              Text(
                'Level ${kLevels[3].number}: ${kLevels[3].title}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                kLevels[3].mission,
                style: const TextStyle(
                  fontSize: 12,
                  color: C.muted,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              BigButton(
                'AYO MULAI',
                C.green,
                () => Navigator.push(
                  context,
                  playfulRoute(ChallengeScreen(level: kLevels[3])),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 4. LEVEL COMPLETE SCREEN
// ============================================================
class LevelCompleteScreen extends StatefulWidget {
  final MissionLevel level;

  /// Bintang yang diraih di percobaan ini (0-3) — ditampilkan apa adanya.
  final int stars;
  const LevelCompleteScreen({
    required this.level,
    required this.stars,
    super.key,
  });

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _celebrate = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..forward();
  late final List<ConfettiPiece> _confetti = ConfettiPiece.make(
    widget.level.number * 13 + widget.stars * 7,
  );

  /// Level berikutnya, atau null kalau ini level terakhir.
  MissionLevel? get nextLevel {
    final i = kLevels.indexWhere((l) => l.number == widget.level.number);
    if (i < 0 || i + 1 >= kLevels.length) return null;
    return kLevels[i + 1];
  }

  @override
  void dispose() {
    _celebrate.dispose();
    super.dispose();
  }

  double _entrance(double start, {Curve curve = Curves.easeOutBack}) {
    final local = ((_celebrate.value - start) / 0.22).clamp(0.0, 1.0);
    return curve.transform(local);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.navy,
      body: Stack(
        children: [
          // Cahaya lembut di belakang piala.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.35),
                  radius: 0.9,
                  colors: [
                    C.gold.withValues(alpha: .14),
                    C.navy.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          // Konfeti perayaan.
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _celebrate,
                  builder: (context, _) => CustomPaint(
                    painter: ConfettiPainter(
                      t: _celebrate.value,
                      pieces: _confetti,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AnimatedBuilder(
                      animation: _celebrate,
                      builder: (context, _) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: 0.6 + 0.4 * _entrance(0),
                            child: Transform.rotate(
                              angle:
                                  math.sin(_celebrate.value * math.pi * 4) *
                                  0.05 *
                                  (1 - _celebrate.value),
                              child: Icon(
                                Icons.emoji_events_rounded,
                                size: 90,
                                color: C.gold.withValues(
                                  alpha: _entrance(0).clamp(0.0, 1.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Opacity(
                            opacity: _entrance(0.08).clamp(0.0, 1.0),
                            child: const Text(
                              'HORE! MISI BERHASIL!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: C.green,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Level ${widget.level.number}: ${widget.level.title}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: C.muted,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0; i < 3; i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  child: Transform.scale(
                                    scale: i < widget.stars
                                        ? _entrance(0.16 + i * 0.14)
                                        : 1,
                                    child: Icon(
                                      Icons.star_rounded,
                                      size: i == 1 ? 60 : 48,
                                      color: i < widget.stars
                                          ? C.gold
                                          : C.navyLine,
                                      shadows: i < widget.stars
                                          ? [
                                              Shadow(
                                                color: C.gold.withValues(
                                                  alpha: .55,
                                                ),
                                                blurRadius: 14,
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: C.navyCard,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: C.navyLine),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .28),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  '${widget.level.reward} XP',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: C.cyanSoft,
                                  ),
                                ),
                                Text(
                                  '+${widget.level.reward ~/ 10} koin',
                                  style: const TextStyle(
                                    color: C.gold,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    widget.level.location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: C.muted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (nextLevel != null)
                            BigButton(
                              'LEVEL BERIKUTNYA',
                              C.green,
                              () => Navigator.pushReplacement(
                                context,
                                playfulRoute(
                                  ChallengeScreen(level: nextLevel!),
                                ),
                              ),
                              icon: Icons.arrow_forward_rounded,
                            )
                          else
                            const Text(
                              'Semua level sudah selesai!',
                              style: TextStyle(
                                color: C.muted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          const SizedBox(height: 12),
                          BigButton(
                            'ULANGI & SEMPURNAKAN',
                            C.blue,
                            () => Navigator.pushReplacement(
                              context,
                              playfulRoute(
                                ChallengeScreen(level: widget.level),
                              ),
                            ),
                            icon: Icons.refresh_rounded,
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.popUntil(context, (r) => r.isFirst),
                            child: const Text(
                              'Kembali ke Beranda',
                              style: TextStyle(color: C.muted),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 5. TOKO KOSTUM SCREEN (implementasi di lib/shop_screen.dart)
// ============================================================
