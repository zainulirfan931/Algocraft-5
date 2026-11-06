part of 'main.dart';

// ============================================================
// A. VISUAL SYSTEM — tema papan, pose robot, transisi, perayaan
// ============================================================
// Semua komponen di file ini bersifat presentational: tidak ada satu pun
// yang mengubah posisi logis, penghitungan bintang, atau hasil eksekusi.

/// Memuat gambar UI (PNG) dari bundle tanpa melempar error saat aset hilang.
Future<ui.Image?> loadUiImage(String path) async {
  try {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  } catch (_) {
    return null;
  }
}

/// Pose visual Kodi. Nilainya hanya dipakai untuk menggambar, bukan logika.
enum RobotPose { idle, walk, jump, chop, shear, build, happy, sad }

/// Dekorasi khas yang digambar di atas petak papan.
enum BoardDecor { flowers, pebbles, conifer, straw, foundation }

/// Palet dan dekorasi papan per lokasi level.
///
/// Lima lokasi punya tema sendiri, tetapi level 5–7 sama-sama berada di
/// kawasan pembangunan sehingga memakai tema fondasi yang sama.
class BoardTheme {
  final String name;
  final Color top;
  final Color top2;
  final Color side;
  final Color edge;
  final Color accent;
  final Color decor;
  final BoardDecor decorKind;

  const BoardTheme({
    required this.name,
    required this.top,
    required this.top2,
    required this.side,
    required this.edge,
    required this.accent,
    required this.decor,
    required this.decorKind,
  });

  static const padangRumput = BoardTheme(
    name: 'Padang Rumput',
    top: Color(0xFF79C24A),
    top2: Color(0xFF6DB43F),
    side: Color(0xFF3D7A2B),
    edge: Color(0xFFA6E27A),
    accent: Color(0xFFFFE082),
    decor: Color(0xFFFF8FB1),
    decorKind: BoardDecor.flowers,
  );

  static const jalanSetapak = BoardTheme(
    name: 'Jalan Setapak',
    top: Color(0xFFB08968),
    top2: Color(0xFFA37A58),
    side: Color(0xFF6B4F3A),
    edge: Color(0xFFDCC09A),
    accent: Color(0xFFE8D5B7),
    decor: Color(0xFF8B6B4A),
    decorKind: BoardDecor.pebbles,
  );

  static const hutanCemara = BoardTheme(
    name: 'Hutan Cemara',
    top: Color(0xFF2E6B46),
    top2: Color(0xFF275C3C),
    side: Color(0xFF153826),
    edge: Color(0xFF5DAE7C),
    accent: Color(0xFF9BE0B0),
    decor: Color(0xFF1B4A30),
    decorKind: BoardDecor.conifer,
  );

  static const kandangDomba = BoardTheme(
    name: 'Kandang Domba',
    top: Color(0xFFD9B25F),
    top2: Color(0xFFCDA44D),
    side: Color(0xFF8A6A2F),
    edge: Color(0xFFF3DA96),
    accent: Color(0xFFFFF1C2),
    decor: Color(0xFFB98C36),
    decorKind: BoardDecor.straw,
  );

  static const lahanBangun = BoardTheme(
    name: 'Lahan Bangun',
    top: Color(0xFF9C7B5B),
    top2: Color(0xFF8F6E50),
    side: Color(0xFF5D4330),
    edge: Color(0xFFC9A47F),
    accent: Color(0xFFFFA726),
    decor: Color(0xFF7A5B42),
    decorKind: BoardDecor.foundation,
  );

  /// Tema berdasarkan nama lokasi level.
  static BoardTheme of(String location) {
    switch (location) {
      case 'Padang Rumput':
        return padangRumput;
      case 'Jalan Setapak':
        return jalanSetapak;
      case 'Hutan Cemara':
        return hutanCemara;
      case 'Kandang Domba':
        return kandangDomba;
      case 'Lahan Kosong':
      case 'Lahan Bangun':
        return lahanBangun;
      default:
        return padangRumput;
    }
  }
}

/// Kostum yang sedang dipakai pada [category], atau null bila tidak ada.
CostumeItem? equippedCostume(CostumeCategory category) {
  final id = GameProgress.instance.equippedId(category.name);
  if (id == null) return null;
  for (final item in kCostumeItems) {
    if (item.id == id) return item;
  }
  return null;
}

// ============================================================
// B. TRANSISI LAYAR
// ============================================================
/// Transisi lembut (fade + naik sedikit) untuk perpindahan antar layar.
Route<T> playfulRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (_, _, _) => page,
    transitionsBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.045),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

// ============================================================
// C. ROBOT KODI — pose, kostum, dan efek
// ============================================================
/// Menggambar Kodi lengkap dengan cincin petak, penunjuk arah, pose,
/// kostum terpasang, dan efek kecil (kapak, gunting, palu, bintang).
///
/// [poseT] adalah progres animasi aksi (0..1) dan [idleT] adalah waktu
/// berulang untuk gerak diam. Keduanya murni visual.
void paintKodi(
  Canvas cv, {
  required Offset ground,
  required double scale,
  required RobotPose pose,
  required double poseT,
  required double idleT,
  required double dir,
  required ui.Image? sprite,
  CostumeItem? hat,
  CostumeItem? shirt,
  CostumeItem? shoes,
  CostumeItem? scarf,
  CostumeItem? wings,
  CostumeItem? accessory,
  double lift = 0,
  bool showRing = true,
  bool showArrow = true,
}) {
  final t = poseT.clamp(0.0, 1.0);
  final base = ground;

  if (showRing) {
    cv.drawCircle(
      base,
      scale * 0.30,
      Paint()..color = const Color(0xFF1E9BF0).withValues(alpha: .28),
    );
    _CartoonArt.dashedCircle(
      cv,
      base,
      scale * 0.30,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = scale * 0.028
        ..color = const Color(0xFF5FC8FF),
      dashes: 16,
    );
  }

  // Arah hadap memakai nilai pecahan supaya belokan bisa dianimasikan.
  final angle = dir * math.pi / 2;
  final dirVec = Offset(math.sin(angle), -math.cos(angle));
  if (showArrow) {
    final arrowBase = base;
    final tip = arrowBase + dirVec * (scale * 0.30);
    final side = Offset(-dirVec.dy, dirVec.dx) * (scale * 0.085);
    cv.drawPath(
      Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo((arrowBase + dirVec * (scale * 0.14) + side).dx,
            (arrowBase + dirVec * (scale * 0.14) + side).dy)
        ..lineTo((arrowBase + dirVec * (scale * 0.14) - side).dx,
            (arrowBase + dirVec * (scale * 0.14) - side).dy)
        ..close(),
      Paint()..color = C.cyan,
    );
  }

  // ── Transformasi pose ─────────────────────────────────────
  double bob = 0;
  double rot = 0;
  double sx = 1;
  double sy = 1;
  double shake = 0;
  final swing = math.sin(t * math.pi);
  switch (pose) {
    case RobotPose.idle:
      bob = math.sin(idleT * math.pi * 2) * scale * 0.018;
      sy = 1 + math.sin(idleT * math.pi * 2) * 0.008;
      break;
    case RobotPose.walk:
      bob = -swing.abs() * scale * 0.05;
      rot = math.sin(t * math.pi * 2) * 0.035;
      sy = 1 + swing * 0.02;
      break;
    case RobotPose.jump:
      bob = 0; // lompatan memakai [lift] dari pemanggil
      rot = math.sin(t * math.pi) * 0.06;
      sy = 1 + swing * 0.05;
      break;
    case RobotPose.chop:
      rot = -0.16 + swing * 0.22;
      bob = -swing * scale * 0.015;
      break;
    case RobotPose.shear:
      rot = swing * 0.10;
      bob = -swing * scale * 0.012;
      break;
    case RobotPose.build:
      bob = -swing * scale * 0.035;
      rot = -0.05 + swing * 0.06;
      break;
    case RobotPose.happy:
      bob = -swing.abs() * scale * 0.09;
      rot = math.sin(t * math.pi * 3) * 0.07;
      sy = 1 + swing * 0.04;
      break;
    case RobotPose.sad:
      rot = 0.13;
      shake = math.sin(t * math.pi * 8) * scale * 0.028 * (1 - t);
      sy = 0.97;
      break;
  }

  final h = scale * 0.78;
  final top = base.dy + scale * 0.16 - h - lift + bob;
  final cx = base.dx + shake;

  cv.save();
  cv.translate(cx, top + h * 0.55);
  cv.rotate(rot);
  cv.scale(sx, sy);
  cv.translate(-cx, -(top + h * 0.55));

  // Sayap digambar di belakang tubuh.
  if (wings != null) {
    _paintWings(cv, Offset(cx, top + h * 0.55), h, wings);
  }

  if (sprite != null) {
    final w = h * sprite.width / sprite.height;
    final dst = Rect.fromLTWH(cx - w / 2, top, w, h);
    cv.drawImageRect(
      sprite,
      Rect.fromLTWH(
        0,
        0,
        sprite.width.toDouble(),
        sprite.height.toDouble(),
      ),
      dst,
      Paint()..filterQuality = FilterQuality.medium,
    );
  } else {
    _CartoonArt.robot(cv, Offset(cx, top + h * 0.58), scale * 0.58);
  }

  // Overlay kostum mengikuti pose karena berada di kanvas yang sama.
  if (shirt != null) _paintShirt(cv, Offset(cx, top), h, shirt);
  if (shoes != null) _paintShoes(cv, Offset(cx, top), h, shoes);
  if (scarf != null) _paintScarf(cv, Offset(cx, top), h, scarf);
  if (hat != null) _paintHat(cv, Offset(cx, top), h, hat);
  if (accessory != null) {
    _paintSparkle(cv, Offset(cx + h * 0.30, top + h * 0.38), h * 0.05,
        accessory.accentColor, opacity: .95);
  }

  cv.restore();

  // ── Efek aksi di ruang layar ──────────────────────────────
  final hand = Offset(cx, top + h * 0.55) + dirVec * (scale * 0.16);
  switch (pose) {
    case RobotPose.chop:
      _paintAxe(cv, hand, dirVec, scale, t);
      _paintChips(cv, base + Offset(0, -h * 0.18), scale, t);
      break;
    case RobotPose.shear:
      _paintScissors(cv, hand, dirVec, scale, t);
      _paintWool(cv, base + Offset(0, -h * 0.30), scale, t);
      break;
    case RobotPose.build:
      _paintHammer(cv, hand, dirVec, scale, t);
      _paintSparks(cv, hand, scale, t);
      break;
    case RobotPose.happy:
      for (var i = 0; i < 3; i++) {
        final a = idleT * math.pi * 2 + i * math.pi * 2 / 3;
        final p = Offset(cx, top) +
            Offset(math.cos(a) * h * 0.34, math.sin(a) * h * 0.14 - h * 0.10);
        _paintStar(cv, p, h * 0.07, C.gold);
      }
      break;
    case RobotPose.sad:
      _paintDrop(cv, Offset(cx + h * 0.20, top + h * 0.30), h * 0.05);
      break;
    default:
      break;
  }
}

void _paintWings(Canvas cv, Offset c, double h, CostumeItem item) {
  final left = Path()
    ..moveTo(c.dx - h * 0.16, c.dy - h * 0.10)
    ..quadraticBezierTo(
      c.dx - h * 0.58,
      c.dy - h * 0.38,
      c.dx - h * 0.44,
      c.dy + h * 0.16,
    )
    ..quadraticBezierTo(
      c.dx - h * 0.30,
      c.dy + h * 0.06,
      c.dx - h * 0.14,
      c.dy + h * 0.10,
    )
    ..close();
  final right = Path()
    ..moveTo(c.dx + h * 0.16, c.dy - h * 0.10)
    ..quadraticBezierTo(
      c.dx + h * 0.58,
      c.dy - h * 0.38,
      c.dx + h * 0.44,
      c.dy + h * 0.16,
    )
    ..quadraticBezierTo(
      c.dx + h * 0.30,
      c.dy + h * 0.06,
      c.dx + h * 0.14,
      c.dy + h * 0.10,
    )
    ..close();
  final fill = Paint()..color = item.baseColor.withValues(alpha: .72);
  final line = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = h * 0.018
    ..color = item.accentColor.withValues(alpha: .85);
  cv.drawPath(left, fill);
  cv.drawPath(right, fill);
  cv.drawPath(left, line);
  cv.drawPath(right, line);
}

void _paintShirt(Canvas cv, Offset topLeft, double h, CostumeItem item) {
  final r = RRect.fromRectAndRadius(
    Rect.fromLTWH(
      topLeft.dx - h * 0.16,
      topLeft.dy + h * 0.50,
      h * 0.32,
      h * 0.27,
    ),
    Radius.circular(h * 0.06),
  );
  cv.drawRRect(r, Paint()..color = item.baseColor.withValues(alpha: .58));
  cv.drawRRect(
    r,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.015
      ..color = item.accentColor.withValues(alpha: .9),
  );
  cv.drawLine(
    Offset(topLeft.dx, topLeft.dy + h * 0.56),
    Offset(topLeft.dx, topLeft.dy + h * 0.72),
    Paint()
      ..strokeWidth = h * 0.012
      ..color = item.accentColor.withValues(alpha: .8),
  );
}

void _paintShoes(Canvas cv, Offset topLeft, double h, CostumeItem item) {
  final y = topLeft.dy + h * 0.90;
  for (final dx in [-h * 0.10, h * 0.10]) {
    cv.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(topLeft.dx + dx, y),
          width: h * 0.15,
          height: h * 0.07,
        ),
        Radius.circular(h * 0.03),
      ),
      Paint()..color = item.baseColor,
    );
  }
}

void _paintScarf(Canvas cv, Offset topLeft, double h, CostumeItem item) {
  cv.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(topLeft.dx, topLeft.dy + h * 0.43),
        width: h * 0.34,
        height: h * 0.075,
      ),
      Radius.circular(h * 0.035),
    ),
    Paint()..color = item.baseColor,
  );
  final tail = Path()
    ..moveTo(topLeft.dx + h * 0.10, topLeft.dy + h * 0.46)
    ..lineTo(topLeft.dx + h * 0.20, topLeft.dy + h * 0.63)
    ..lineTo(topLeft.dx + h * 0.13, topLeft.dy + h * 0.64)
    ..lineTo(topLeft.dx + h * 0.04, topLeft.dy + h * 0.47)
    ..close();
  cv.drawPath(tail, Paint()..color = item.accentColor);
}

void _paintHat(Canvas cv, Offset topLeft, double h, CostumeItem item) {
  final y = topLeft.dy + h * 0.10;
  switch (item.variant % 4) {
    case 1:
      // Mahkota
      cv.drawPath(
        Path()
          ..moveTo(topLeft.dx - h * 0.16, y + h * 0.05)
          ..lineTo(topLeft.dx - h * 0.12, y - h * 0.08)
          ..lineTo(topLeft.dx - h * 0.04, y + h * 0.01)
          ..lineTo(topLeft.dx, y - h * 0.10)
          ..lineTo(topLeft.dx + h * 0.04, y + h * 0.01)
          ..lineTo(topLeft.dx + h * 0.12, y - h * 0.08)
          ..lineTo(topLeft.dx + h * 0.16, y + h * 0.05)
          ..close(),
        Paint()..color = item.baseColor,
      );
      break;
    case 2:
      // Helm bulat
      cv.drawArc(
        Rect.fromCenter(
          center: Offset(topLeft.dx, y + h * 0.02),
          width: h * 0.34,
          height: h * 0.26,
        ),
        math.pi,
        math.pi,
        true,
        Paint()..color = item.baseColor,
      );
      break;
    default:
      // Topi dengan kubah + brim
      cv.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(topLeft.dx, y),
            width: h * 0.22,
            height: h * 0.15,
          ),
          Radius.circular(h * 0.06),
        ),
        Paint()..color = item.baseColor,
      );
      cv.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(topLeft.dx, y + h * 0.07),
            width: h * 0.32,
            height: h * 0.045,
          ),
          Radius.circular(h * 0.02),
        ),
        Paint()..color = item.accentColor,
      );
      break;
  }
}

void _paintAxe(Canvas cv, Offset hand, Offset dir, double scale, double t) {
  final swing = math.sin(t * math.pi);
  final bladePos = hand + dir * (scale * 0.10 + swing * scale * 0.18);
  final handle = Paint()
    ..color = const Color(0xFF8D5A2B)
    ..strokeWidth = scale * 0.035
    ..strokeCap = StrokeCap.round;
  cv.drawLine(hand, bladePos, handle);
  final blade = Path()
    ..moveTo(bladePos.dx, bladePos.dy)
    ..lineTo(
      bladePos.dx + dir.dx * scale * 0.10 - dir.dy * scale * 0.09,
      bladePos.dy + dir.dy * scale * 0.10 + dir.dx * scale * 0.09,
    )
    ..lineTo(
      bladePos.dx + dir.dx * scale * 0.13,
      bladePos.dy + dir.dy * scale * 0.13,
    )
    ..lineTo(
      bladePos.dx + dir.dx * scale * 0.10 + dir.dy * scale * 0.09,
      bladePos.dy + dir.dy * scale * 0.10 - dir.dx * scale * 0.09,
    )
    ..close();
  cv.drawPath(blade, Paint()..color = const Color(0xFFD7E3EE));
}

void _paintChips(Canvas cv, Offset c, double scale, double t) {
  if (t < .35) return;
  final p = ((t - .35) / .65).clamp(0.0, 1.0);
  for (var i = 0; i < 4; i++) {
    final a = -math.pi / 2 + (i - 1.5) * 0.45;
    final d = p * scale * (0.18 + i * 0.035);
    final pos = c + Offset(math.cos(a), math.sin(a)) * d;
    cv.drawCircle(
      pos,
      scale * 0.018 * (1 - p * 0.4),
      Paint()..color = const Color(0xFFC68B4A).withValues(alpha: 1 - p),
    );
  }
}

void _paintScissors(Canvas cv, Offset hand, Offset dir, double scale, double t) {
  final open = 0.20 + math.sin(t * math.pi * 4).abs() * 0.12;
  final a = dir.dx == 0 && dir.dy == 0 ? 0.0 : math.atan2(dir.dy, dir.dx);
  for (final s in [-1.0, 1.0]) {
    cv.save();
    cv.translate(hand.dx, hand.dy);
    cv.rotate(a + s * open);
    cv.drawLine(
      Offset.zero,
      Offset(scale * 0.20, 0),
      Paint()
        ..color = const Color(0xFFBFD8E8)
        ..strokeWidth = scale * 0.022
        ..strokeCap = StrokeCap.round,
    );
    cv.restore();
  }
}

void _paintWool(Canvas cv, Offset c, double scale, double t) {
  if (t < .25) return;
  final p = ((t - .25) / .75).clamp(0.0, 1.0);
  for (var i = 0; i < 5; i++) {
    final a = -math.pi / 2 + (i - 2) * 0.38;
    final d = p * scale * (0.16 + i * 0.02);
    final pos = c + Offset(math.cos(a), math.sin(a)) * d;
    cv.drawCircle(
      pos,
      scale * 0.035 * (1 - p * 0.5),
      Paint()..color = Colors.white.withValues(alpha: 1 - p),
    );
  }
}

void _paintHammer(Canvas cv, Offset hand, Offset dir, double scale, double t) {
  final swing = math.sin(t * math.pi);
  final head = hand + dir * (scale * 0.15 + swing * scale * 0.10);
  cv.drawLine(
    hand,
    head,
    Paint()
      ..color = const Color(0xFF8D5A2B)
      ..strokeWidth = scale * 0.032
      ..strokeCap = StrokeCap.round,
  );
  cv.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromCenter(center: head, width: scale * 0.13, height: scale * 0.08),
      Radius.circular(scale * 0.02),
    ),
    Paint()..color = const Color(0xFF9AA7B4),
  );
}

void _paintSparks(Canvas cv, Offset c, double scale, double t) {
  if (t < .45) return;
  final p = ((t - .45) / .55).clamp(0.0, 1.0);
  for (var i = 0; i < 3; i++) {
    final a = -math.pi / 2 + (i - 1) * 0.7;
    final pos = c + Offset(math.cos(a), math.sin(a)) * (p * scale * 0.14);
    _paintStar(cv, pos, scale * 0.03, C.orangePop, opacity: 1 - p);
  }
}

void _paintStar(Canvas cv, Offset c, double r, Color color,
    {double opacity = 1}) {
  final path = Path();
  for (var i = 0; i < 10; i++) {
    final rad = i.isEven ? r : r * 0.44;
    final a = -math.pi / 2 + i * math.pi / 5;
    final p = c + Offset(math.cos(a), math.sin(a)) * rad;
    if (i == 0) {
      path.moveTo(p.dx, p.dy);
    } else {
      path.lineTo(p.dx, p.dy);
    }
  }
  path.close();
  cv.drawPath(path, Paint()..color = color.withValues(alpha: opacity));
}

void _paintDrop(Canvas cv, Offset c, double r) {
  final path = Path()
    ..moveTo(c.dx, c.dy - r * 1.4)
    ..quadraticBezierTo(c.dx + r, c.dy, c.dx, c.dy + r)
    ..quadraticBezierTo(c.dx - r, c.dy, c.dx, c.dy - r * 1.4)
    ..close();
  cv.drawPath(path, Paint()..color = const Color(0xFF77CCFF));
}

void _paintSparkle(Canvas cv, Offset c, double r, Color color,
    {double opacity = 1}) {
  final paint = Paint()
    ..color = color.withValues(alpha: opacity)
    ..strokeWidth = r * 0.45
    ..strokeCap = StrokeCap.round;
  cv.drawLine(c + Offset(-r, 0), c + Offset(r, 0), paint);
  cv.drawLine(c + Offset(0, -r), c + Offset(0, r), paint);
}

// ============================================================
// D. PERAYAAN LAYAR HASIL
// ============================================================
class ConfettiPiece {
  final double x;
  final double speed;
  final double phase;
  final double size;
  final Color color;
  final double spin;
  final bool circle;

  const ConfettiPiece({
    required this.x,
    required this.speed,
    required this.phase,
    required this.size,
    required this.color,
    required this.spin,
    required this.circle,
  });

  /// Partikel deterministik supaya animasi tidak berubah tiap repaint.
  static List<ConfettiPiece> make(int seed, {int count = 46}) {
    final rnd = math.Random(seed);
    const palette = [
      C.gold,
      C.orangePop,
      C.cyan,
      C.green,
      C.pink,
      C.purple,
      Colors.white,
    ];
    return List.generate(count, (i) {
      return ConfettiPiece(
        x: rnd.nextDouble(),
        speed: 0.55 + rnd.nextDouble() * 0.9,
        phase: rnd.nextDouble() * math.pi * 2,
        size: 4 + rnd.nextDouble() * 6,
        color: palette[rnd.nextInt(palette.length)],
        spin: (rnd.nextDouble() - 0.5) * 10,
        circle: rnd.nextBool(),
      );
    });
  }
}

/// Konfeti yang jatuh selama durasi perayaan.
class ConfettiPainter extends CustomPainter {
  final double t;
  final List<ConfettiPiece> pieces;

  const ConfettiPainter({required this.t, required this.pieces});

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0 || t >= 1.05) return;
    for (final p in pieces) {
      final fall = (t * p.speed * 1.15).clamp(0.0, 1.0);
      final x = p.x * size.width +
          math.sin(t * math.pi * 5 + p.phase) * size.width * 0.04;
      final y = -24 + fall * (size.height + 48);
      final opacity = (1 - fall * 0.35).clamp(0.0, 1.0);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * p.spin + p.phase);
      final paint = Paint()..color = p.color.withValues(alpha: opacity);
      if (p.circle) {
        canvas.drawCircle(Offset.zero, p.size * 0.45, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.55,
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter old) =>
      old.t != t || old.pieces != pieces;
}

// ============================================================
// E. GALERI POSE (dipakai untuk pratinjau & bukti tangkapan layar)
// ============================================================
/// Deretan pose Kodi untuk keperluan pratinjau visual.
class KodiPoseStrip extends StatefulWidget {
  final List<RobotPose> poses;
  final double height;
  const KodiPoseStrip({
    this.poses = const [
      RobotPose.idle,
      RobotPose.walk,
      RobotPose.chop,
      RobotPose.happy,
      RobotPose.sad,
    ],
    this.height = 150,
    super.key,
  });

  @override
  State<KodiPoseStrip> createState() => _KodiPoseStripState();
}

class _KodiPoseStripState extends State<KodiPoseStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _idle;
  ui.Image? _sprite;

  @override
  void initState() {
    super.initState();
    _idle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    loadUiImage('assets/images/karakter_depan.png').then((img) {
      if (mounted) setState(() => _sprite = img);
    });
  }

  @override
  void dispose() {
    _idle.dispose();
    super.dispose();
  }

  static String _label(RobotPose pose) {
    switch (pose) {
      case RobotPose.idle:
        return 'DIAM';
      case RobotPose.walk:
        return 'BERJALAN';
      case RobotPose.jump:
        return 'LOMPAT';
      case RobotPose.chop:
        return 'MENEBANG';
      case RobotPose.shear:
        return 'MENCUKUR';
      case RobotPose.build:
        return 'MEMBANGUN';
      case RobotPose.happy:
        return 'BERHASIL';
      case RobotPose.sad:
        return 'GAGAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hat = equippedCostume(CostumeCategory.topi);
    final shirt = equippedCostume(CostumeCategory.baju);
    final shoes = equippedCostume(CostumeCategory.sepatu);
    final scarf = equippedCostume(CostumeCategory.syal);
    final wings = equippedCostume(CostumeCategory.sayap);
    final accessory = equippedCostume(CostumeCategory.aksesoris);

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _idle,
        builder: (context, _) => Row(
          children: [
            for (final pose in widget.poses)
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: CustomPaint(
                        painter: _PoseCardPainter(
                          pose: pose,
                          t: pose == RobotPose.idle ? 0 : .55,
                          idleT: _idle.value,
                          sprite: _sprite,
                          hat: hat,
                          shirt: shirt,
                          shoes: shoes,
                          scarf: scarf,
                          wings: wings,
                          accessory: accessory,
                        ),
                        size: Size.infinite,
                      ),
                    ),
                    Text(
                      _label(pose),
                      style: const TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .4,
                        color: C.cyanSoft,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Papan pratinjau untuk laporan/tangkapan layar.
///
/// Memakai painter yang sama dengan arena permainan, tetapi semua nilai
/// visual dapat diatur langsung sehingga satu frame animasi bisa direkam
/// tanpa menjalankan program.
class ArenaShowcase extends StatefulWidget {
  final MissionLevel level;
  final double robotRow;
  final double robotCol;
  final double robotDir;
  final RobotPose pose;
  final double poseT;
  final double idleT;
  final bool jump;
  final int? activeTree;
  final int? activeSheep;
  final String? activePlank;
  final int activePlankMat;
  final Set<int> chopped;
  final Set<int> shorn;
  final List<List<int>> placed;
  final String? frameLabel;

  const ArenaShowcase({
    required this.level,
    this.robotRow = 3,
    this.robotCol = 0,
    this.robotDir = 1,
    this.pose = RobotPose.idle,
    this.poseT = 1,
    this.idleT = 0.3,
    this.jump = false,
    this.activeTree,
    this.activeSheep,
    this.activePlank,
    this.activePlankMat = 0,
    this.chopped = const {},
    this.shorn = const {},
    this.placed = const [],
    this.frameLabel,
    super.key,
  });

  @override
  State<ArenaShowcase> createState() => _ArenaShowcaseState();
}

class _ArenaShowcaseState extends State<ArenaShowcase> {
  ui.Image? _karakter;
  ui.Image? _domba;
  ui.Image? _pohon;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final images = await Future.wait([
      loadUiImage('assets/images/karakter_depan.png'),
      loadUiImage('assets/images/domba.png'),
      loadUiImage('assets/images/pohon.png'),
    ]);
    if (!mounted) return;
    setState(() {
      _karakter = images[0];
      _domba = images[1];
      _pohon = images[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    final lv = widget.level;
    return Container(
      decoration: BoxDecoration(
        color: C.navyCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.navyLine),
      ),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      child: Column(
        children: [
          if (widget.frameLabel != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                widget.frameLabel!,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: C.cyanSoft,
                  letterSpacing: .4,
                ),
              ),
            ),
          Expanded(
            child: RepaintBoundary(
              child: CustomPaint(
                size: Size.infinite,
                painter: _ArenaPainter(
                  size: lv.boardSize,
                  rocks: lv.rocks,
                  bushes: lv.bushes,
                  trees: lv.trees,
                  treesChopped: [
                    for (var i = 0; i < lv.trees.length; i++)
                      widget.chopped.contains(i),
                  ],
                  sheep: lv.sheep,
                  sheepShorn: [
                    for (var i = 0; i < lv.sheep.length; i++)
                      widget.shorn.contains(i),
                  ],
                  walls: lv.walls,
                  placed: widget.placed,
                  robotRow: widget.robotRow,
                  robotCol: widget.robotCol,
                  robotDir: widget.robotDir,
                  goalRow: lv.goalRow,
                  goalCol: lv.goalCol,
                  karakter: _karakter,
                  domba: _domba,
                  pohon: _pohon,
                  theme: BoardTheme.of(lv.location),
                  pose: widget.pose,
                  poseT: widget.poseT,
                  idleT: widget.idleT,
                  jump: widget.jump,
                  activeTree: widget.activeTree,
                  activeSheep: widget.activeSheep,
                  activePlank: widget.activePlank,
                  activePlankMat: widget.activePlankMat,
                  hat: equippedCostume(CostumeCategory.topi),
                  shirt: equippedCostume(CostumeCategory.baju),
                  shoes: equippedCostume(CostumeCategory.sepatu),
                  scarf: equippedCostume(CostumeCategory.syal),
                  wings: equippedCostume(CostumeCategory.sayap),
                  accessory: equippedCostume(CostumeCategory.aksesoris),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PoseCardPainter extends CustomPainter {
  final RobotPose pose;
  final double t;
  final double idleT;
  final ui.Image? sprite;
  final CostumeItem? hat;
  final CostumeItem? shirt;
  final CostumeItem? shoes;
  final CostumeItem? scarf;
  final CostumeItem? wings;
  final CostumeItem? accessory;

  const _PoseCardPainter({
    required this.pose,
    required this.t,
    required this.idleT,
    required this.sprite,
    this.hat,
    this.shirt,
    this.shoes,
    this.scarf,
    this.wings,
    this.accessory,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width, size.height) * 0.92;
    final ground = Offset(size.width / 2, size.height * 0.78);
    paintKodi(
      canvas,
      ground: ground,
      scale: scale,
      pose: pose,
      poseT: t,
      idleT: idleT,
      dir: 2,
      sprite: sprite,
      hat: hat,
      shirt: shirt,
      shoes: shoes,
      scarf: scarf,
      wings: wings,
      accessory: accessory,
      showRing: true,
      showArrow: false,
    );
  }

  @override
  bool shouldRepaint(covariant _PoseCardPainter old) =>
      old.pose != pose ||
      old.t != t ||
      old.idleT != idleT ||
      old.sprite != sprite ||
      old.hat != hat ||
      old.shirt != shirt ||
      old.shoes != shoes ||
      old.scarf != scarf ||
      old.wings != wings ||
      old.accessory != accessory;
}
