part of 'main.dart';

// ============================================================
// 5. TOKO KOSTUM SCREEN
// ============================================================

/// Kategori kostum yang dijual di Toko Kostum.
enum CostumeCategory {
  baju('Baju', Icons.checkroom_rounded),
  topi('Topi', Icons.school_rounded),
  sepatu('Sepatu', Icons.hiking_rounded),
  syal('Syal', Icons.waves_rounded),
  sayap('Sayap', Icons.flight_rounded),
  aksesoris('Aksesoris', Icons.diamond_rounded);

  final String label;
  final IconData icon;
  const CostumeCategory(this.label, this.icon);
}

/// Satu barang yang dijual di Toko Kostum.
class CostumeItem {
  final String id;
  final String name;
  final CostumeCategory category;
  final IconData icon;
  final int price;
  final Color baseColor;
  final Color accentColor;

  /// Varian bentuk untuk ilustrasi voxel (0–9).
  final int variant;

  /// Label kecil di kartu: "Populer" / "Eksklusif".
  final String? badge;

  const CostumeItem(
    this.id,
    this.name,
    this.category,
    this.icon,
    this.price,
    this.baseColor,
    this.accentColor, [
    this.variant = 0,
    this.badge,
  ]);
}

/// Katalog lengkap Toko Kostum.
/// 10 baju, 10 topi, 8 sepatu, 6 syal, 6 sayap, 6 aksesoris.
const kCostumeItems = <CostumeItem>[
  // ── Baju (10) ──────────────────────────────────────────────
  CostumeItem(
    'baju_kaos',
    'Kaos Kode',
    CostumeCategory.baju,
    Icons.code_rounded,
    80,
    Color(0xFF2563EB),
    Color(0xFF38E1F0),
    0,
    'Populer',
  ),
  CostumeItem(
    'baju_jaket',
    'Jaket Robot',
    CostumeCategory.baju,
    Icons.dry_cleaning_rounded,
    150,
    Color(0xFF1E3A8A),
    Color(0xFF38E1F0),
    1,
  ),
  CostumeItem(
    'baju_ninja',
    'Baju Ninja',
    CostumeCategory.baju,
    Icons.sports_martial_arts_rounded,
    220,
    Color(0xFF1F2937),
    Color(0xFFFF5A5F),
    2,
  ),
  CostumeItem(
    'baju_armor',
    'Armor Ksatria',
    CostumeCategory.baju,
    Icons.shield_rounded,
    320,
    Color(0xFFB8C7E6),
    Color(0xFF38E1F0),
    3,
    'Eksklusif',
  ),
  CostumeItem(
    'baju_hoodie',
    'Hoodie Cyber',
    CostumeCategory.baju,
    Icons.checkroom_rounded,
    180,
    Color(0xFF4C1D95),
    Color(0xFFFF4FD8),
    4,
  ),
  CostumeItem(
    'baju_vest',
    'Rompi Neon',
    CostumeCategory.baju,
    Icons.bolt_rounded,
    140,
    Color(0xFF0F766E),
    Color(0xFFB6F35A),
    5,
  ),
  CostumeItem(
    'baju_robe',
    'Jubah Sage',
    CostumeCategory.baju,
    Icons.auto_awesome_rounded,
    260,
    Color(0xFF6D28D9),
    Color(0xFFFFC857),
    6,
  ),
  CostumeItem(
    'baju_suit',
    'Setelan Galaksi',
    CostumeCategory.baju,
    Icons.work_rounded,
    350,
    Color(0xFF0F172A),
    Color(0xFF8B5CF6),
    7,
  ),
  CostumeItem(
    'baju_jersey',
    'Jersey Turbo',
    CostumeCategory.baju,
    Icons.sports_soccer_rounded,
    200,
    Color(0xFFDC2626),
    Color(0xFFFFC857),
    8,
  ),
  CostumeItem(
    'baju_cape',
    'Mantel Void',
    CostumeCategory.baju,
    Icons.dark_mode_rounded,
    450,
    Color(0xFF1E1B4B),
    Color(0xFF8B5CF6),
    9,
    'Eksklusif',
  ),

  // ── Topi (10) ──────────────────────────────────────────────
  CostumeItem(
    'topi_petualang',
    'Topi Petualang',
    CostumeCategory.topi,
    Icons.explore_rounded,
    90,
    Color(0xFF8B5A2B),
    Color(0xFFFFC857),
    0,
  ),
  CostumeItem(
    'topi_koki',
    'Topi Koki',
    CostumeCategory.topi,
    Icons.restaurant_rounded,
    130,
    Color(0xFFF2F6FF),
    Color(0xFFB8C7E6),
    1,
  ),
  CostumeItem(
    'topi_helm',
    'Helm Astronot',
    CostumeCategory.topi,
    Icons.rocket_launch_rounded,
    280,
    Color(0xFFB8C7E6),
    Color(0xFF38E1F0),
    2,
  ),
  CostumeItem(
    'topi_mahkota',
    'Mahkota Emas',
    CostumeCategory.topi,
    Icons.workspace_premium_rounded,
    420,
    Color(0xFFFFC857),
    Color(0xFFFF6B9A),
    3,
    'Eksklusif',
  ),
  CostumeItem(
    'topi_cap',
    'Cap Neon',
    CostumeCategory.topi,
    Icons.sports_baseball_rounded,
    100,
    Color(0xFF2563EB),
    Color(0xFF38E1F0),
    4,
    'Populer',
  ),
  CostumeItem(
    'topi_beanie',
    'Beanie Koding',
    CostumeCategory.topi,
    Icons.ac_unit_rounded,
    120,
    Color(0xFF7C3AED),
    Color(0xFFFF6B9A),
    5,
  ),
  CostumeItem(
    'topi_hacker',
    'Headset Hacker',
    CostumeCategory.topi,
    Icons.headset_mic_rounded,
    240,
    Color(0xFF1F2937),
    Color(0xFF4DE3A2),
    6,
  ),
  CostumeItem(
    'topi_dragon',
    'Mahkota Naga',
    CostumeCategory.topi,
    Icons.whatshot_rounded,
    380,
    Color(0xFF7F1D1D),
    Color(0xFFFF8A2B),
    7,
  ),
  CostumeItem(
    'topi_visor',
    'Visor Cyber',
    CostumeCategory.topi,
    Icons.remove_red_eye_rounded,
    260,
    Color(0xFF0F172A),
    Color(0xFF38E1F0),
    8,
  ),
  CostumeItem(
    'topi_tophat',
    'Topi Pesulap',
    CostumeCategory.topi,
    Icons.theater_comedy_rounded,
    300,
    Color(0xFF1F2937),
    Color(0xFF8B5CF6),
    9,
  ),

  // ── Sepatu (8) ─────────────────────────────────────────────
  CostumeItem(
    'sepatu_lari',
    'Sepatu Lari',
    CostumeCategory.sepatu,
    Icons.directions_run_rounded,
    70,
    Color(0xFF3D8BFF),
    Color(0xFF9BF0F7),
    0,
    'Populer',
  ),
  CostumeItem(
    'sepatu_boot',
    'Sepatu Boot',
    CostumeCategory.sepatu,
    Icons.hiking_rounded,
    140,
    Color(0xFF8B5A2B),
    Color(0xFFFFC857),
    1,
  ),
  CostumeItem(
    'sepatu_ninja',
    'Sepatu Ninja',
    CostumeCategory.sepatu,
    Icons.bolt_rounded,
    190,
    Color(0xFF1F2937),
    Color(0xFFFF5A5F),
    2,
  ),
  CostumeItem(
    'sepatu_roket',
    'Sepatu Roket',
    CostumeCategory.sepatu,
    Icons.rocket_rounded,
    300,
    Color(0xFFB8C7E6),
    Color(0xFFFF8A2B),
    3,
    'Eksklusif',
  ),
  CostumeItem(
    'sepatu_neon',
    'Sepatu Neon',
    CostumeCategory.sepatu,
    Icons.light_mode_rounded,
    160,
    Color(0xFF0F766E),
    Color(0xFFB6F35A),
    4,
  ),
  CostumeItem(
    'sepatu_gladiator',
    'Sepatu Gladiator',
    CostumeCategory.sepatu,
    Icons.shield_rounded,
    210,
    Color(0xFF7C2D12),
    Color(0xFFFFC857),
    5,
  ),
  CostumeItem(
    'sepatu_es',
    'Sepatu Es',
    CostumeCategory.sepatu,
    Icons.ac_unit_rounded,
    250,
    Color(0xFF67E8F9),
    Color(0xFFF2F6FF),
    6,
  ),
  CostumeItem(
    'sepatu_void',
    'Sepatu Void',
    CostumeCategory.sepatu,
    Icons.dark_mode_rounded,
    340,
    Color(0xFF1E1B4B),
    Color(0xFF8B5CF6),
    7,
  ),

  // ── Syal (6) ───────────────────────────────────────────────
  CostumeItem(
    'syal_biru',
    'Syal Biru',
    CostumeCategory.syal,
    Icons.waves_rounded,
    60,
    Color(0xFF3D8BFF),
    Color(0xFF9BF0F7),
    0,
    'Populer',
  ),
  CostumeItem(
    'syal_hangat',
    'Syal Hangat',
    CostumeCategory.syal,
    Icons.ac_unit_rounded,
    110,
    Color(0xFFFF6B9A),
    Color(0xFFF2F6FF),
    1,
  ),
  CostumeItem(
    'syal_super',
    'Syal Super',
    CostumeCategory.syal,
    Icons.auto_awesome_rounded,
    230,
    Color(0xFF8B5CF6),
    Color(0xFFFFC857),
    2,
  ),
  CostumeItem(
    'syal_neon',
    'Syal Neon',
    CostumeCategory.syal,
    Icons.bolt_rounded,
    140,
    Color(0xFF0F766E),
    Color(0xFFB6F35A),
    3,
  ),
  CostumeItem(
    'syal_naga',
    'Syal Naga',
    CostumeCategory.syal,
    Icons.whatshot_rounded,
    280,
    Color(0xFF7F1D1D),
    Color(0xFFFF8A2B),
    4,
  ),
  CostumeItem(
    'syal_bintang',
    'Syal Bintang',
    CostumeCategory.syal,
    Icons.star_rounded,
    200,
    Color(0xFF1E1B4B),
    Color(0xFFFFC857),
    5,
  ),

  // ── Sayap (6) ──────────────────────────────────────────────
  CostumeItem(
    'sayap_peri',
    'Sayap Peri',
    CostumeCategory.sayap,
    Icons.auto_fix_high_rounded,
    160,
    Color(0xFFFF6B9A),
    Color(0xFF9BF0F7),
    0,
  ),
  CostumeItem(
    'sayap_burung',
    'Sayap Burung',
    CostumeCategory.sayap,
    Icons.flight_rounded,
    240,
    Color(0xFFF2F6FF),
    Color(0xFFB8C7E6),
    1,
  ),
  CostumeItem(
    'sayap_naga',
    'Sayap Naga',
    CostumeCategory.sayap,
    Icons.whatshot_rounded,
    360,
    Color(0xFF7F1D1D),
    Color(0xFFFF8A2B),
    2,
  ),
  CostumeItem(
    'sayap_cahaya',
    'Sayap Cahaya',
    CostumeCategory.sayap,
    Icons.flare_rounded,
    460,
    Color(0xFFFFC857),
    Color(0xFFF2F6FF),
    3,
    'Eksklusif',
  ),
  CostumeItem(
    'sayap_robot',
    'Sayap Robot',
    CostumeCategory.sayap,
    Icons.smart_toy_rounded,
    300,
    Color(0xFFB8C7E6),
    Color(0xFF38E1F0),
    4,
  ),
  CostumeItem(
    'sayap_void',
    'Sayap Void',
    CostumeCategory.sayap,
    Icons.dark_mode_rounded,
    520,
    Color(0xFF1E1B4B),
    Color(0xFF8B5CF6),
    5,
  ),

  // ── Aksesoris (6) ──────────────────────────────────────────
  CostumeItem(
    'akses_kacamata',
    'Kacamata Kode',
    CostumeCategory.aksesoris,
    Icons.visibility_rounded,
    90,
    Color(0xFF1F2937),
    Color(0xFF38E1F0),
    0,
  ),
  CostumeItem(
    'akses_headphone',
    'Headphone Bass',
    CostumeCategory.aksesoris,
    Icons.headphones_rounded,
    160,
    Color(0xFF7C3AED),
    Color(0xFFFF6B9A),
    1,
    'Populer',
  ),
  CostumeItem(
    'akses_ransel',
    'Ransel Explorer',
    CostumeCategory.aksesoris,
    Icons.backpack_rounded,
    220,
    Color(0xFF8B5A2B),
    Color(0xFFFFC857),
    2,
  ),
  CostumeItem(
    'akses_jam',
    'Jam Waktu',
    CostumeCategory.aksesoris,
    Icons.watch_rounded,
    260,
    Color(0xFFB8C7E6),
    Color(0xFF38E1F0),
    3,
  ),
  CostumeItem(
    'akses_gem',
    'Kristal Energi',
    CostumeCategory.aksesoris,
    Icons.diamond_rounded,
    340,
    Color(0xFF8B5CF6),
    Color(0xFF9BF0F7),
    4,
    'Eksklusif',
  ),
  CostumeItem(
    'akses_masker',
    'Masker Cyber',
    CostumeCategory.aksesoris,
    Icons.health_and_safety_rounded,
    190,
    Color(0xFF0F172A),
    Color(0xFF4DE3A2),
    5,
  ),
];

/// Pencarian cepat item berdasarkan id.
final Map<String, CostumeItem> kCostumeById = {
  for (final item in kCostumeItems) item.id: item,
};

/// Item tab kategori. [category] null berarti tab "Semua".
class _ShopTab {
  final String label;
  final IconData icon;
  final CostumeCategory? category;
  const _ShopTab(this.label, this.icon, this.category);
}

const _kShopTabs = <_ShopTab>[
  _ShopTab('Semua', Icons.grid_view_rounded, null),
  _ShopTab('Baju', Icons.checkroom_rounded, CostumeCategory.baju),
  _ShopTab('Topi', Icons.school_rounded, CostumeCategory.topi),
  _ShopTab('Sepatu', Icons.hiking_rounded, CostumeCategory.sepatu),
  _ShopTab('Syal', Icons.waves_rounded, CostumeCategory.syal),
  _ShopTab('Sayap', Icons.flight_rounded, CostumeCategory.sayap),
  _ShopTab('Aksesoris', Icons.diamond_rounded, CostumeCategory.aksesoris),
];

/// Halaman Toko Kostum dengan layout portrait:
/// header → judul → preview karakter → tab kategori → katalog 2 kolom.
class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({super.key});
  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  CostumeCategory? _category;
  String _selectedId = kCostumeItems.first.id;

  CostumeItem get _selected => kCostumeById[_selectedId] ?? kCostumeItems.first;

  List<CostumeItem> _itemsFor(CostumeCategory? category) => category == null
      ? kCostumeItems
      : kCostumeItems.where((item) => item.category == category).toList();

  List<CostumeItem> get _visibleItems => _itemsFor(_category);

  void _selectCategory(CostumeCategory? category) {
    final items = _itemsFor(category);
    setState(() {
      _category = category;
      if (!items.any((item) => item.id == _selectedId)) {
        _selectedId = items.first.id;
      }
    });
    GameAudio.instance.playSfx('click');
  }

  /// Preview selalu menampilkan item yang sedang dipilih. Kategori lain
  /// mengikuti kostum yang benar-benar sedang dipakai.
  Map<CostumeCategory, CostumeItem> _previewSet(GameProgress progress) {
    final set = <CostumeCategory, CostumeItem>{};
    for (final category in CostumeCategory.values) {
      final id = progress.equippedId(category.name);
      final item = id == null ? null : kCostumeById[id];
      if (item != null) set[category] = item;
    }
    set[_selected.category] = _selected;
    return set;
  }

  Future<void> _onCardTap(CostumeItem item) async {
    setState(() => _selectedId = item.id);
    final progress = GameProgress.instance;
    if (progress.ownsItem(item.id)) {
      await progress.equipItem(item.category.name, item.id);
    }
  }

  void _snack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _buy(CostumeItem item) async {
    final progress = GameProgress.instance;
    if (progress.ownsItem(item.id)) {
      await _equip(item);
      return;
    }

    final ok = await progress.buyItem(item.id, item.price);
    if (!mounted) return;
    if (!ok) {
      _snack(
        progress.coins < item.price
            ? 'Koin belum cukup. Butuh ${_groupNum(item.price)} koin.'
            : 'Item ini sudah dimiliki.',
        C.red,
      );
      GameAudio.instance.playSfx('fail');
      return;
    }

    await progress.equipItem(item.category.name, item.id);
    if (!mounted) return;
    setState(() => _selectedId = item.id);
    GameAudio.instance.playSfx('win');
    _snack('${item.name} dibeli & langsung dipakai!', C.green);
  }

  Future<void> _equip(CostumeItem item) async {
    await GameProgress.instance.equipItem(item.category.name, item.id);
    if (!mounted) return;
    GameAudio.instance.playSfx('click');
    _snack('${item.name} dipakai!', C.cyan);
  }

  Future<void> _unequip(CostumeItem item) async {
    await GameProgress.instance.unequipItem(item.category.name);
    if (!mounted) return;
    _snack('${item.name} dilepas.', C.navyCard2);
  }

  void _showPreviewDialog() {
    final progress = GameProgress.instance;
    final previewSet = _previewSet(progress);
    final owned = progress.ownsItem(_selected.id);
    final worn = progress.isItemEquipped(_selected.category.name, _selected.id);

    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .72),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 380,
              maxHeight: MediaQuery.of(dialogContext).size.height * .86,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [C.navyCard, C.navyDeep],
                  ),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: C.navyLine),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .4),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [C.cyan, C.blue],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.visibility_rounded,
                            color: C.navyDeep,
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Preview Karakter',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_selected.name} • ${_selected.category.label}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: C.muted,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: C.muted,
                            size: 21,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 316,
                      decoration: BoxDecoration(
                        color: C.navyDeep,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: C.navyLine),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(19),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CustomPaint(painter: _PreviewBackdropPainter()),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: CustomPaint(
                                painter: _ShopAvatarPainter(
                                  equipped: previewSet,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final category in CostumeCategory.values)
                            if (previewSet[category] != null)
                              _miniPreviewChip(previewSet[category]!),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            worn
                                ? 'Kostum ini sedang dipakai.'
                                : owned
                                ? 'Kostum ini ada di inventaris.'
                                : 'Pratinjau item sebelum dibeli.',
                            style: const TextStyle(
                              color: C.muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 40,
                          child: BigButton(
                            'TUTUP',
                            C.navyCard2,
                            () => Navigator.pop(dialogContext),
                            icon: Icons.close_rounded,
                            height: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _miniPreviewChip(CostumeItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: item.baseColor.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: item.baseColor.withValues(alpha: .5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.category.icon, size: 11, color: item.accentColor),
          const SizedBox(width: 4),
          Text(
            item.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: GameProgress.instance.changes,
      builder: (_, _, _) {
        final progress = GameProgress.instance;
        final selected = _selected;
        final owned = progress.ownsItem(selected.id);
        final worn = progress.isItemEquipped(
          selected.category.name,
          selected.id,
        );
        final previewSet = _previewSet(progress);
        final visible = _visibleItems;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _header(progress)),
            SliverToBoxAdapter(child: _titleSection()),
            SliverToBoxAdapter(
              child: _previewPanel(
                progress: progress,
                selected: selected,
                previewSet: previewSet,
                owned: owned,
                worn: worn,
              ),
            ),
            SliverToBoxAdapter(child: _categoryTabs()),
            SliverToBoxAdapter(child: _catalogHeader(visible.length)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: .68,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, index) => _costumeCard(visible[index], progress),
                  childCount: visible.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── HEADER: saldo koin / diamond, suara, profil ─────────────
  Widget _header(GameProgress progress) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 350;
          return Row(
            children: [
              _currencyChip(
                Icons.monetization_on_rounded,
                C.gold,
                progress.coins,
                'KOIN',
                compact: compact,
              ),
              const SizedBox(width: 7),
              _currencyChip(
                Icons.diamond_rounded,
                C.cyan,
                progress.diamonds,
                'DIAMOND',
                compact: compact,
              ),
              const Spacer(),
              ValueListenableBuilder<int>(
                valueListenable: GameAudio.instance.changes,
                builder: (_, _, _) => _roundButton(
                  GameAudio.instance.soundOn
                      ? Icons.volume_up_rounded
                      : Icons.volume_off_rounded,
                  () => GameAudio.instance.setSoundOn(
                    !GameAudio.instance.soundOn,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              _profileButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _currencyChip(
    IconData icon,
    Color color,
    int value,
    String label, {
    required bool compact,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 9,
        vertical: compact ? 7 : 7,
      ),
      decoration: BoxDecoration(
        color: C.navyCard,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: C.navyLine),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 21 : 24,
            height: compact ? 21 : 24,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: compact ? 12 : 14, color: color),
          ),
          const SizedBox(width: 6),
          if (compact)
            Text(
              _groupNum(value),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            )
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: C.dim,
                    fontSize: 7.5,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _groupNum(value),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap) {
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
        child: Icon(icon, size: 18, color: C.cyanSoft),
      ),
    );
  }

  Widget _profileButton() {
    return GestureDetector(
      onTap: () => _snack('Halo, AlgoCoder! 👋', C.navyCard2),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(colors: [C.cyan, C.blue]),
          boxShadow: [
            BoxShadow(
              color: C.cyan.withValues(alpha: .3),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/karakter_kepala.png',
            fit: BoxFit.cover,
            width: 36,
            height: 36,
            errorBuilder: (_, _, _) =>
                const CustomPaint(painter: _KodiFacePainter()),
          ),
        ),
      ),
    );
  }

  // ── JUDUL TOKO ──────────────────────────────────────────────
  Widget _titleSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 0),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [C.cyan, C.blue],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: C.cyan.withValues(alpha: .3),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.shopping_cart_rounded,
              color: C.navyDeep,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toko Kostum',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.5,
                    height: 1.05,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kustomisasi karaktermu dengan gaya terbaik!',
                  maxLines: 2,
                  style: TextStyle(
                    color: C.muted,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── PREVIEW KARAKTER ────────────────────────────────────────
  Widget _previewPanel({
    required GameProgress progress,
    required CostumeItem selected,
    required Map<CostumeCategory, CostumeItem> previewSet,
    required bool owned,
    required bool worn,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
      child: Container(
        height: 296,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF111D40), C.navyDeep],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: C.navyLine),
          boxShadow: [
            BoxShadow(
              color: C.cyan.withValues(alpha: .08),
              blurRadius: 26,
              spreadRadius: -8,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: .28),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: _PreviewBackdropPainter()),
              Positioned(
                left: 12,
                right: 12,
                top: 12,
                child: Row(
                  children: [
                    _statusChip(owned: owned, worn: worn),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: C.navyCard.withValues(alpha: .82),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: C.navyLine),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            selected.category.icon,
                            size: 12,
                            color: C.cyanSoft,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            selected.category.label.toUpperCase(),
                            style: const TextStyle(
                              color: C.cyanSoft,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: .8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                top: 38,
                bottom: 58,
                left: 10,
                right: 10,
                child: CustomPaint(
                  painter: _ShopAvatarPainter(equipped: previewSet),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 12,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selected.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            owned
                                ? (worn
                                      ? 'Sedang dipakai'
                                      : 'Ada di inventaris')
                                : 'Pratinjau sebelum membeli',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: owned ? C.cyan : C.muted,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (worn) ...[
                      Tooltip(
                        message: 'Lepas kostum',
                        child: GestureDetector(
                          onTap: () => _unequip(selected),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: C.red.withValues(alpha: .12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: C.red.withValues(alpha: .45),
                              ),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 17,
                              color: C.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                    ],
                    _previewButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip({required bool owned, required bool worn}) {
    final color = worn ? C.cyan : (owned ? C.cyanSoft : C.gold);
    final icon = worn
        ? Icons.check_circle_rounded
        : (owned ? Icons.inventory_2_rounded : Icons.auto_awesome_rounded);
    final label = worn ? 'DIPAKAI' : (owned ? 'DIMILIKI' : 'PREVIEW');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: .55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
              letterSpacing: .8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewButton() {
    return GestureDetector(
      onTap: _showPreviewDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: C.cyan.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: C.cyan.withValues(alpha: .6)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.visibility_rounded, size: 15, color: C.cyan),
            SizedBox(width: 5),
            Text(
              'Preview',
              style: TextStyle(
                color: C.cyan,
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── TAB KATEGORI ────────────────────────────────────────────
  Widget _categoryTabs() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _kShopTabs.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, index) {
            final tab = _kShopTabs[index];
            final active = _category == tab.category;
            return GestureDetector(
              onTap: () => _selectCategory(tab.category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  gradient: active
                      ? const LinearGradient(colors: [C.cyan, C.blue])
                      : null,
                  color: active ? null : C.navyCard,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: active ? Colors.transparent : C.navyLine,
                  ),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: C.cyan.withValues(alpha: .28),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab.icon,
                      size: 14,
                      color: active ? C.navyDeep : C.dim,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      tab.label,
                      style: TextStyle(
                        color: active ? C.navyDeep : C.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── JUDUL KATALOG ───────────────────────────────────────────
  Widget _catalogHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 10),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Katalog Kostum',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: C.cyan.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: C.cyan.withValues(alpha: .3)),
            ),
            child: Text(
              '$count ITEM',
              style: const TextStyle(
                color: C.cyan,
                fontSize: 8.5,
                fontWeight: FontWeight.w900,
                letterSpacing: .6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── KARTU KOSTUM ────────────────────────────────────────────
  Widget _costumeCard(CostumeItem item, GameProgress progress) {
    final selected = item.id == _selectedId;
    final owned = progress.ownsItem(item.id);
    final worn = progress.isItemEquipped(item.category.name, item.id);

    return GestureDetector(
      onTap: () => _onCardTap(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: selected
                ? const [C.navyCard2, C.navyCard]
                : const [C.navyCard, Color(0xFF111B3B)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? C.cyan : C.navyLine,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: C.cyan.withValues(alpha: .18),
                    blurRadius: 18,
                    spreadRadius: -4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(painter: _CostumeArtPainter(item)),
                    if (item.badge != null)
                      Positioned(top: 8, left: 8, child: _badge(item.badge!)),
                    if (worn)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: C.cyan.withValues(alpha: .18),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: C.cyan.withValues(alpha: .7),
                            ),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: C.cyan,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                decoration: BoxDecoration(
                  color: C.navyDeep.withValues(alpha: .72),
                  border: Border(
                    top: BorderSide(color: C.navyLine.withValues(alpha: .8)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 28,
                      child: Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          height: 1.18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.category.label.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: C.dim,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .7,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          owned
                              ? (worn
                                    ? Icons.check_circle_rounded
                                    : Icons.inventory_2_rounded)
                              : Icons.monetization_on_rounded,
                          size: 13,
                          color: owned ? C.cyan : C.gold,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            owned
                                ? (worn ? 'Dipakai' : 'Dimiliki')
                                : _groupNum(item.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: owned ? C.cyan : C.gold,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        _cardAction(item, owned, worn),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String badge) {
    final exclusive = badge.toLowerCase() == 'eksklusif';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: exclusive
              ? const [C.purple, C.cyan]
              : const [C.gold, C.orange],
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: (exclusive ? C.purple : C.gold).withValues(alpha: .3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        badge.toUpperCase(),
        style: TextStyle(
          color: exclusive ? Colors.white : C.navyDeep,
          fontSize: 7,
          fontWeight: FontWeight.w900,
          letterSpacing: .4,
        ),
      ),
    );
  }

  Widget _cardAction(CostumeItem item, bool owned, bool worn) {
    final label = owned ? (worn ? 'Dipakai' : 'Pakai') : 'Beli';
    final active = !owned || !worn;
    return GestureDetector(
      onTap: active
          ? () {
              if (owned) {
                _equip(item);
              } else {
                _buy(item);
              }
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: !owned
              ? const LinearGradient(colors: [C.gold, C.orange])
              : owned && !worn
              ? const LinearGradient(colors: [C.cyan, C.blue])
              : null,
          color: owned && worn ? C.cyan.withValues(alpha: .1) : null,
          borderRadius: BorderRadius.circular(8),
          border: owned && worn
              ? Border.all(color: C.cyan.withValues(alpha: .35))
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: owned && worn ? C.cyan : C.navyDeep,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ILUSTRASI VOXEL — helper bersama
// ============================================================

Color _lighten(Color color, [double amount = .18]) =>
    Color.lerp(color, Colors.white, amount)!;

Color _darken(Color color, [double amount = .22]) =>
    Color.lerp(color, Colors.black, amount)!;

void _paintGlow(
  Canvas canvas,
  Offset center,
  double radius,
  Color color, {
  double opacity = .25,
}) {
  final paint = Paint()
    ..color = color.withValues(alpha: opacity)
    ..maskFilter = ui.MaskFilter.blur(
      ui.BlurStyle.normal,
      math.max(2, radius * .55),
    );
  canvas.drawCircle(center, radius, paint);
}

void _drawBlock(
  Canvas canvas,
  Rect rect,
  Color base, {
  double radius = 2,
  double depth = 2.5,
}) {
  if (rect.width <= 0 || rect.height <= 0) return;
  final rr = RRect.fromRectAndRadius(rect, Radius.circular(radius));
  final dark = _darken(base, .38);
  if (depth > 0) {
    canvas.drawRRect(rr.shift(Offset(depth, depth)), Paint()..color = dark);
  }
  canvas.drawRRect(rr, Paint()..color = base);
  canvas.save();
  canvas.clipRRect(rr);
  canvas.drawRect(
    Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height * .16),
    Paint()..color = _lighten(base, .16),
  );
  canvas.drawRect(
    Rect.fromLTWH(
      rect.left,
      rect.bottom - rect.height * .14,
      rect.width,
      rect.height * .14,
    ),
    Paint()..color = _darken(base, .16),
  );
  canvas.drawRect(
    Rect.fromLTWH(rect.left, rect.top, rect.width * .1, rect.height),
    Paint()..color = _lighten(base, .08),
  );
  canvas.restore();
  canvas.drawRRect(
    rr,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = _darken(base, .35),
  );
}

void _drawVoxelPath(
  Canvas canvas,
  Path path,
  Color base, {
  double depth = 5,
  bool outline = true,
}) {
  final dark = _darken(base, .38);
  for (var i = depth.ceil(); i >= 1; i--) {
    canvas.drawPath(
      path.shift(Offset(i * .55, -i * .55)),
      Paint()..color = dark,
    );
  }
  canvas.drawPath(path, Paint()..color = base);
  final bounds = path.getBounds();
  if (!bounds.isEmpty) {
    canvas.save();
    canvas.clipPath(path);
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_lighten(base, .2), base, _darken(base, .18)],
        ).createShader(bounds),
    );
    canvas.drawRect(
      Rect.fromLTWH(
        bounds.left,
        bounds.top,
        bounds.width,
        math.max(1, bounds.height * .04),
      ),
      Paint()..color = _lighten(base, .28),
    );
    canvas.restore();
  }
  if (outline) {
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = dark,
    );
  }
}

void _drawSparkle(
  Canvas canvas,
  Offset center,
  double radius,
  Color color, {
  double opacity = .85,
}) {
  final path = Path()
    ..moveTo(center.dx, center.dy - radius)
    ..lineTo(center.dx + radius * .34, center.dy - radius * .34)
    ..lineTo(center.dx + radius, center.dy)
    ..lineTo(center.dx + radius * .34, center.dy + radius * .34)
    ..lineTo(center.dx, center.dy + radius)
    ..lineTo(center.dx - radius * .34, center.dy + radius * .34)
    ..lineTo(center.dx - radius, center.dy)
    ..lineTo(center.dx - radius * .34, center.dy - radius * .34)
    ..close();
  canvas.drawPath(path, Paint()..color = color.withValues(alpha: opacity));
}

// ============================================================
// LATAR PREVIEW
// ============================================================

class _PreviewBackdropPainter extends CustomPainter {
  const _PreviewBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * .55);
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          C.cyan.withValues(alpha: .16),
          C.blue.withValues(alpha: .06),
          Colors.transparent,
        ],
        stops: const [0, .42, 1],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * .56));
    canvas.drawRect(Offset.zero & size, glow);

    final line = Paint()
      ..color = C.cyan.withValues(alpha: .055)
      ..strokeWidth = 1;
    final step = math.max(22.0, size.width / 14);
    for (double x = -size.height; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), line);
    }
    for (double y = size.height * .55; y < size.height; y += step * .55) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * .84),
        width: size.width * .82,
        height: size.height * .19,
      ),
      Paint()..color = C.cyan.withValues(alpha: .06),
    );

    final star = Paint()..color = C.cyanSoft.withValues(alpha: .45);
    const fractions = <Offset>[
      Offset(.12, .2),
      Offset(.22, .74),
      Offset(.82, .18),
      Offset(.9, .62),
      Offset(.16, .52),
      Offset(.76, .42),
    ];
    for (final fraction in fractions) {
      canvas.drawCircle(
        Offset(size.width * fraction.dx, size.height * fraction.dy),
        1.2,
        star,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PreviewBackdropPainter oldDelegate) => false;
}

// ============================================================
// ILUSTRASI KARTU KOSTUM
// ============================================================

class _CostumeArtPainter extends CustomPainter {
  final CostumeItem item;
  const _CostumeArtPainter(this.item);

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackdrop(canvas, size);
    final scale = math.min(size.width, size.height) / 120;
    canvas.save();
    canvas.translate(
      (size.width - 110 * scale) / 2,
      (size.height - 110 * scale) / 2,
    );
    canvas.scale(scale);
    _paintPedestal(canvas);
    switch (item.category) {
      case CostumeCategory.baju:
        _paintBaju(canvas);
      case CostumeCategory.topi:
        _paintTopi(canvas);
      case CostumeCategory.sepatu:
        _paintSepatu(canvas);
      case CostumeCategory.syal:
        _paintSyal(canvas);
      case CostumeCategory.sayap:
        _paintSayap(canvas);
      case CostumeCategory.aksesoris:
        _paintAksesoris(canvas);
    }
    canvas.restore();
  }

  void _paintBackdrop(Canvas canvas, Size size) {
    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              item.accentColor.withValues(alpha: .2),
              item.baseColor.withValues(alpha: .05),
              Colors.transparent,
            ],
            stops: const [0, .48, 1],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width / 2, size.height * .5),
              radius: size.width * .62,
            ),
          );
    canvas.drawRect(Offset.zero & size, glow);

    final grid = Paint()
      ..color = C.cyan.withValues(alpha: .045)
      ..strokeWidth = 1;
    final step = math.max(16.0, size.width / 8);
    for (double x = -size.height; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), grid);
    }
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * .84),
        width: size.width * .7,
        height: size.height * .17,
      ),
      Paint()..color = Colors.black.withValues(alpha: .24),
    );
  }

  void _paintPedestal(Canvas canvas) {
    final accent = item.accentColor;
    _paintGlow(canvas, const Offset(55, 94), 30, accent, opacity: .22);

    final top = Path()
      ..moveTo(55, 87)
      ..lineTo(80, 96)
      ..lineTo(55, 106)
      ..lineTo(30, 96)
      ..close();
    final left = Path()
      ..moveTo(30, 96)
      ..lineTo(55, 106)
      ..lineTo(55, 111)
      ..lineTo(30, 101)
      ..close();
    final right = Path()
      ..moveTo(55, 106)
      ..lineTo(80, 96)
      ..lineTo(80, 101)
      ..lineTo(55, 111)
      ..close();

    canvas.drawPath(left, Paint()..color = C.navyCard2);
    canvas.drawPath(right, Paint()..color = C.navyDeep);
    canvas.drawPath(top, Paint()..color = C.navyCard);
    canvas.drawPath(
      top,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = accent.withValues(alpha: .7),
    );
    final inner = Path()
      ..moveTo(55, 91)
      ..lineTo(70, 96)
      ..lineTo(55, 102)
      ..lineTo(40, 96)
      ..close();
    canvas.drawPath(inner, Paint()..color = accent.withValues(alpha: .16));
    canvas.drawPath(
      inner,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = accent.withValues(alpha: .45),
    );
  }

  // ── BAJU ──────────────────────────────────────────────────
  void _paintBaju(Canvas canvas) {
    final base = item.baseColor;
    final accent = item.accentColor;
    final v = item.variant;

    if (v == 9) {
      final cape = Path()
        ..moveTo(34, 22)
        ..lineTo(76, 22)
        ..lineTo(93, 84)
        ..lineTo(66, 76)
        ..lineTo(55, 89)
        ..lineTo(44, 76)
        ..lineTo(17, 84)
        ..close();
      _drawVoxelPath(canvas, cape, _darken(base, .08), depth: 5);
      canvas.drawPath(
        Path()
          ..moveTo(22, 82)
          ..lineTo(44, 74)
          ..lineTo(55, 86)
          ..lineTo(66, 74)
          ..lineTo(88, 82),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = accent.withValues(alpha: .55),
      );
    }

    if (v == 4) {
      final hood = Path()
        ..moveTo(39, 17)
        ..lineTo(71, 17)
        ..lineTo(77, 35)
        ..lineTo(33, 35)
        ..close();
      _drawVoxelPath(canvas, hood, _darken(base, .06), depth: 4);
    }

    Path shirt;
    if (v == 5) {
      shirt = Path()
        ..moveTo(38, 24)
        ..lineTo(46, 18)
        ..lineTo(50, 26)
        ..lineTo(60, 26)
        ..lineTo(64, 18)
        ..lineTo(72, 24)
        ..lineTo(70, 44)
        ..lineTo(66, 44)
        ..lineTo(66, 82)
        ..lineTo(44, 82)
        ..lineTo(44, 44)
        ..lineTo(40, 44)
        ..close();
    } else if (v == 6) {
      shirt = Path()
        ..moveTo(30, 24)
        ..lineTo(42, 18)
        ..lineTo(46, 26)
        ..lineTo(64, 26)
        ..lineTo(68, 18)
        ..lineTo(80, 24)
        ..lineTo(84, 42)
        ..lineTo(72, 46)
        ..lineTo(72, 90)
        ..lineTo(38, 90)
        ..lineTo(38, 46)
        ..lineTo(26, 42)
        ..close();
    } else {
      shirt = Path()
        ..moveTo(30, 24)
        ..lineTo(42, 18)
        ..lineTo(46, 26)
        ..lineTo(64, 26)
        ..lineTo(68, 18)
        ..lineTo(80, 24)
        ..lineTo(84, 42)
        ..lineTo(72, 46)
        ..lineTo(70, 84)
        ..lineTo(40, 84)
        ..lineTo(38, 46)
        ..lineTo(26, 42)
        ..close();
    }

    _drawVoxelPath(canvas, shirt, base, depth: 6);
    canvas.drawPath(
      Path()
        ..moveTo(46, 26)
        ..lineTo(55, 35)
        ..lineTo(64, 26)
        ..lineTo(58, 23)
        ..lineTo(55, 27)
        ..lineTo(52, 23)
        ..close(),
      Paint()..color = _darken(base, .28),
    );

    canvas.save();
    canvas.clipPath(shirt);
    switch (v) {
      case 0:
        _chestEmblem(canvas, accent);
      case 1:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(53, 28, 57, 80),
          _darken(base, .34),
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(40, 62, 50, 65),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(60, 62, 70, 65),
          accent,
          radius: 1,
          depth: 0,
        );
        canvas.drawCircle(
          const Offset(55, 44),
          3,
          Paint()..color = _lighten(accent, .15),
        );
      case 2:
        canvas.drawPath(
          Path()
            ..moveTo(28, 66)
            ..lineTo(82, 46)
            ..lineTo(82, 54)
            ..lineTo(28, 74)
            ..close(),
          Paint()..color = accent.withValues(alpha: .85),
        );
        canvas.drawCircle(
          const Offset(70, 57),
          3.5,
          Paint()..color = _lighten(accent, .25),
        );
      case 3:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(43, 37, 67, 69),
          _lighten(base, .1),
          radius: 4,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(47, 41, 63, 65),
          _darken(base, .2),
          radius: 2,
          depth: 1,
        );
        _paintGlow(canvas, const Offset(55, 53), 9, accent, opacity: .6);
        canvas.drawCircle(const Offset(55, 53), 4, Paint()..color = accent);
      case 4:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(40, 58, 70, 74),
          _darken(base, .26),
          radius: 4,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(47, 31, 49, 50),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(61, 31, 63, 50),
          accent,
          radius: 1,
          depth: 0,
        );
        canvas.drawCircle(const Offset(48, 51), 2, Paint()..color = accent);
        canvas.drawCircle(const Offset(62, 51), 2, Paint()..color = accent);
      case 5:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(46, 30, 64, 78),
          _darken(base, .42),
          radius: 2,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(45, 28, 48, 80),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(62, 28, 65, 80),
          accent,
          radius: 1,
          depth: 0,
        );
      case 6:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(38, 64, 72, 71),
          _darken(base, .35),
          radius: 2,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(51, 64, 59, 71),
          accent,
          radius: 1,
          depth: 0,
        );
        canvas.drawPath(
          Path()
            ..moveTo(38, 86)
            ..lineTo(72, 86)
            ..lineTo(72, 90)
            ..lineTo(38, 90)
            ..close(),
          Paint()..color = accent.withValues(alpha: .5),
        );
      case 7:
        canvas.drawPath(
          Path()
            ..moveTo(45, 27)
            ..lineTo(55, 49)
            ..lineTo(42, 38)
            ..close(),
          Paint()..color = _darken(base, .3),
        );
        canvas.drawPath(
          Path()
            ..moveTo(65, 27)
            ..lineTo(55, 49)
            ..lineTo(68, 38)
            ..close(),
          Paint()..color = _darken(base, .3),
        );
        canvas.drawPath(
          Path()
            ..moveTo(55, 34)
            ..lineTo(60, 44)
            ..lineTo(55, 57)
            ..lineTo(50, 44)
            ..close(),
          Paint()..color = accent,
        );
        for (var y = 62.0; y < 80; y += 9) {
          canvas.drawCircle(
            Offset(55, y),
            1.6,
            Paint()..color = _lighten(base, .35),
          );
        }
      case 8:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(30, 38, 80, 44),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(30, 70, 80, 76),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(49, 46, 61, 50),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(57, 50, 61, 62),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(49, 58, 61, 62),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(49, 50, 53, 56),
          accent,
          radius: 1,
          depth: 0,
        );
      case 9:
        _paintGlow(canvas, const Offset(55, 32), 13, accent, opacity: .5);
        canvas.drawCircle(const Offset(55, 32), 4, Paint()..color = accent);
        canvas.drawPath(
          Path()
            ..moveTo(40, 26)
            ..lineTo(55, 50)
            ..lineTo(70, 26),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = accent.withValues(alpha: .65),
        );
    }
    canvas.restore();

    if (v == 3) {
      _drawBlock(
        canvas,
        const Rect.fromLTRB(24, 21, 43, 37),
        _lighten(base, .06),
        radius: 4,
        depth: 3,
      );
      _drawBlock(
        canvas,
        const Rect.fromLTRB(67, 21, 86, 37),
        _lighten(base, .06),
        radius: 4,
        depth: 3,
      );
      canvas.drawLine(
        const Offset(28, 29),
        const Offset(39, 29),
        Paint()
          ..color = accent
          ..strokeWidth = 2,
      );
      canvas.drawLine(
        const Offset(71, 29),
        const Offset(82, 29),
        Paint()
          ..color = accent
          ..strokeWidth = 2,
      );
    }

    canvas.drawLine(
      const Offset(34, 30),
      const Offset(42, 28),
      Paint()
        ..color = _lighten(base, .35).withValues(alpha: .8)
        ..strokeWidth = 1.5,
    );
    _drawSparkle(canvas, const Offset(20, 36), 3.5, accent, opacity: .55);
  }

  void _chestEmblem(Canvas canvas, Color accent) {
    _drawBlock(
      canvas,
      const Rect.fromLTRB(47, 42, 63, 58),
      _darken(accent, .28),
      radius: 4,
      depth: 1,
    );
    canvas.drawCircle(const Offset(55, 50), 4.5, Paint()..color = accent);
    canvas.drawLine(
      const Offset(50, 50),
      const Offset(60, 50),
      Paint()
        ..color = Colors.white.withValues(alpha: .85)
        ..strokeWidth = 1.4,
    );
  }

  // ── TOPI ──────────────────────────────────────────────────
  void _paintTopi(Canvas canvas) {
    final base = item.baseColor;
    final accent = item.accentColor;
    final v = item.variant;

    switch (v) {
      case 0:
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(20, 72)
            ..lineTo(90, 72)
            ..lineTo(95, 82)
            ..lineTo(15, 82)
            ..close(),
          _darken(base, .18),
          depth: 4,
        );
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(34, 38)
            ..lineTo(76, 38)
            ..lineTo(72, 72)
            ..lineTo(38, 72)
            ..close(),
          base,
          depth: 5,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(38, 62, 72, 70),
          accent,
          radius: 1,
          depth: 1,
        );
        canvas.drawCircle(
          const Offset(55, 52),
          5,
          Paint()..color = _lighten(accent, .12),
        );
        canvas.drawCircle(
          const Offset(55, 52),
          2.5,
          Paint()..color = _darken(base, .3),
        );
      case 1:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(34, 34, 54, 58),
          base,
          radius: 10,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(46, 26, 68, 58),
          base,
          radius: 12,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(58, 34, 78, 58),
          base,
          radius: 10,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(34, 54, 78, 68),
          _lighten(base, .04),
          radius: 3,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(34, 58, 78, 64),
          accent,
          radius: 1,
          depth: 1,
        );
      case 2:
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(30, 68)
            ..quadraticBezierTo(30, 28, 55, 27)
            ..quadraticBezierTo(80, 28, 80, 68)
            ..close(),
          base,
          depth: 5,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(28, 58, 82, 72),
          accent.withValues(alpha: .72),
          radius: 8,
          depth: 2,
        );
        canvas.drawLine(
          const Offset(33, 62),
          const Offset(57, 62),
          Paint()
            ..color = Colors.white.withValues(alpha: .75)
            ..strokeWidth = 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(22, 56, 30, 70),
          _darken(base, .2),
          radius: 2,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(80, 56, 88, 70),
          _darken(base, .2),
          radius: 2,
          depth: 1,
        );
      case 3:
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(32, 58)
            ..lineTo(78, 58)
            ..lineTo(78, 70)
            ..lineTo(32, 70)
            ..close(),
          base,
          depth: 4,
        );
        for (final prong in <Path>[
          Path()
            ..moveTo(32, 60)
            ..lineTo(38, 28)
            ..lineTo(46, 60)
            ..close(),
          Path()
            ..moveTo(48, 58)
            ..lineTo(55, 22)
            ..lineTo(62, 58)
            ..close(),
          Path()
            ..moveTo(64, 60)
            ..lineTo(72, 28)
            ..lineTo(78, 60)
            ..close(),
        ]) {
          _drawVoxelPath(canvas, prong, base, depth: 3);
          canvas.drawCircle(
            Offset(prong.getBounds().center.dx, prong.getBounds().top + 5),
            2.5,
            Paint()..color = accent,
          );
        }
        _drawBlock(
          canvas,
          const Rect.fromLTRB(36, 62, 74, 67),
          accent,
          radius: 1,
          depth: 1,
        );
      case 4:
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(26, 68)
            ..lineTo(86, 68)
            ..lineTo(92, 78)
            ..lineTo(20, 78)
            ..close(),
          _darken(base, .22),
          depth: 4,
        );
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(34, 38)
            ..lineTo(76, 38)
            ..lineTo(74, 68)
            ..lineTo(36, 68)
            ..close(),
          base,
          depth: 5,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(34, 56, 76, 64),
          accent,
          radius: 1,
          depth: 1,
        );
        canvas.drawCircle(
          const Offset(55, 37),
          4,
          Paint()..color = _lighten(base, .22),
        );
        canvas.drawPath(
          Path()
            ..moveTo(45, 52)
            ..lineTo(55, 46)
            ..lineTo(65, 52),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = accent,
        );
      case 5:
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(32, 68)
            ..quadraticBezierTo(30, 30, 55, 26)
            ..quadraticBezierTo(80, 30, 78, 68)
            ..close(),
          base,
          depth: 5,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(30, 58, 80, 72),
          accent,
          radius: 3,
          depth: 2,
        );
        _paintGlow(canvas, const Offset(55, 24), 10, accent, opacity: .5);
        canvas.drawCircle(const Offset(55, 23), 6, Paint()..color = accent);
        canvas.drawCircle(
          const Offset(55, 23),
          3,
          Paint()..color = _lighten(accent, .35),
        );
        for (var x = 40.0; x < 75; x += 9) {
          canvas.drawLine(
            Offset(x, 44),
            Offset(x, 58),
            Paint()
              ..color = _lighten(base, .25).withValues(alpha: .5)
              ..strokeWidth = 1.4,
          );
        }
      case 6:
        final band = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round
          ..color = base;
        canvas.drawArc(
          const Rect.fromLTRB(25, 25, 85, 78),
          math.pi * 1.05,
          math.pi * .9,
          false,
          band,
        );
        canvas.drawArc(
          const Rect.fromLTRB(25, 25, 85, 78),
          math.pi * 1.08,
          math.pi * .84,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round
            ..color = _lighten(base, .22),
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(20, 54, 34, 76),
          base,
          radius: 5,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(76, 54, 90, 76),
          base,
          radius: 5,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(22, 58, 32, 72),
          accent,
          radius: 4,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(78, 58, 88, 72),
          accent,
          radius: 4,
          depth: 1,
        );
        canvas.drawLine(
          const Offset(80, 72),
          const Offset(62, 82),
          Paint()
            ..color = _lighten(base, .2)
            ..strokeWidth = 3,
        );
        canvas.drawCircle(const Offset(61, 83), 3.5, Paint()..color = accent);
      case 7:
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(30, 60)
            ..lineTo(80, 60)
            ..lineTo(80, 72)
            ..lineTo(30, 72)
            ..close(),
          base,
          depth: 4,
        );
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(30, 62)
            ..lineTo(15, 30)
            ..lineTo(40, 51)
            ..close(),
          _darken(base, .05),
          depth: 3,
        );
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(80, 62)
            ..lineTo(95, 30)
            ..lineTo(70, 51)
            ..close(),
          _darken(base, .05),
          depth: 3,
        );
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(46, 58)
            ..lineTo(55, 25)
            ..lineTo(64, 58)
            ..close(),
          base,
          depth: 3,
        );
        _paintGlow(canvas, const Offset(55, 58), 15, accent, opacity: .5);
        canvas.drawCircle(const Offset(55, 58), 5, Paint()..color = accent);
        canvas.drawCircle(const Offset(20, 34), 2.5, Paint()..color = accent);
        canvas.drawCircle(const Offset(90, 34), 2.5, Paint()..color = accent);
      case 8:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(24, 50, 86, 66),
          _darken(base, .12),
          radius: 5,
          depth: 3,
        );
        _paintGlow(canvas, const Offset(55, 58), 22, accent, opacity: .55);
        _drawBlock(
          canvas,
          const Rect.fromLTRB(28, 53, 82, 62),
          accent,
          radius: 4,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(22, 50, 28, 66),
          _darken(base, .2),
          radius: 2,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(82, 50, 88, 66),
          _darken(base, .2),
          radius: 2,
          depth: 1,
        );
        canvas.drawLine(
          const Offset(34, 56),
          const Offset(76, 56),
          Paint()
            ..color = Colors.white.withValues(alpha: .75)
            ..strokeWidth = 2,
        );
      case 9:
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(22, 74)
            ..lineTo(88, 74)
            ..lineTo(88, 84)
            ..lineTo(22, 84)
            ..close(),
          _darken(base, .2),
          depth: 4,
        );
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(38, 28)
            ..lineTo(72, 28)
            ..lineTo(72, 74)
            ..lineTo(38, 74)
            ..close(),
          base,
          depth: 6,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(38, 64, 72, 72),
          accent,
          radius: 1,
          depth: 1,
        );
        canvas.drawLine(
          const Offset(42, 32),
          const Offset(42, 62),
          Paint()
            ..color = _lighten(base, .3).withValues(alpha: .6)
            ..strokeWidth = 1.5,
        );
        _drawSparkle(canvas, const Offset(80, 36), 4, accent, opacity: .8);
    }

    _drawSparkle(canvas, const Offset(18, 44), 3.5, accent, opacity: .5);
    _drawSparkle(canvas, const Offset(92, 48), 2.8, accent, opacity: .45);
  }

  // ── SEPATU ────────────────────────────────────────────────
  void _paintSepatu(Canvas canvas) {
    final base = item.baseColor;
    final accent = item.accentColor;
    final v = item.variant;

    _paintGlow(
      canvas,
      const Offset(55, 84),
      28,
      accent,
      opacity: v == 3 || v == 4 || v == 7 ? .32 : .15,
    );

    Path shoe;
    if (v == 0) {
      shoe = Path()
        ..moveTo(38, 44)
        ..lineTo(64, 44)
        ..lineTo(64, 64)
        ..lineTo(82, 70)
        ..lineTo(84, 80)
        ..lineTo(78, 86)
        ..lineTo(32, 86)
        ..lineTo(26, 77)
        ..lineTo(38, 68)
        ..close();
    } else {
      shoe = Path()
        ..moveTo(38, 28)
        ..lineTo(64, 28)
        ..lineTo(64, 58)
        ..lineTo(82, 66)
        ..lineTo(84, 78)
        ..lineTo(78, 86)
        ..lineTo(32, 86)
        ..lineTo(26, 76)
        ..lineTo(36, 66)
        ..close();
    }

    _drawVoxelPath(canvas, shoe, base, depth: 6);
    _drawBlock(
      canvas,
      const Rect.fromLTRB(26, 78, 86, 87),
      _darken(base, .38),
      radius: 4,
      depth: 2,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(30, 78, 52, 83),
      _lighten(base, .12),
      radius: 2,
      depth: 1,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(54, 78, 82, 83),
      _lighten(base, .08),
      radius: 2,
      depth: 1,
    );

    if (v == 1) {
      _drawBlock(
        canvas,
        const Rect.fromLTRB(36, 24, 66, 33),
        _darken(base, .1),
        radius: 3,
        depth: 2,
      );
      for (var i = 0; i < 3; i++) {
        canvas.drawLine(
          Offset(46, 36.0 + i * 7),
          Offset(58, 32.0 + i * 7),
          Paint()
            ..color = accent.withValues(alpha: .85)
            ..strokeWidth = 2,
        );
      }
      _drawBlock(
        canvas,
        const Rect.fromLTRB(36, 54, 44, 62),
        accent,
        radius: 2,
        depth: 1,
      );
    } else if (v == 2) {
      canvas.drawPath(
        Path()
          ..moveTo(38, 46)
          ..lineTo(64, 52)
          ..lineTo(64, 58)
          ..lineTo(38, 52)
          ..close(),
        Paint()..color = accent.withValues(alpha: .7),
      );
      canvas.drawPath(
        Path()
          ..moveTo(38, 60)
          ..lineTo(64, 66)
          ..lineTo(64, 72)
          ..lineTo(38, 66)
          ..close(),
        Paint()..color = accent.withValues(alpha: .45),
      );
    } else if (v == 3) {
      _drawBlock(
        canvas,
        const Rect.fromLTRB(30, 54, 38, 74),
        _darken(base, .15),
        radius: 2,
        depth: 2,
      );
      canvas.drawPath(
        Path()
          ..moveTo(30, 56)
          ..lineTo(16, 64)
          ..lineTo(30, 72)
          ..close(),
        Paint()..color = _darken(base, .05),
      );
      _paintGlow(canvas, const Offset(55, 88), 13, C.orange, opacity: .7);
      canvas.drawPath(
        Path()
          ..moveTo(48, 84)
          ..lineTo(55, 98)
          ..lineTo(62, 84)
          ..close(),
        Paint()..color = C.orange,
      );
      canvas.drawPath(
        Path()
          ..moveTo(51, 84)
          ..lineTo(55, 93)
          ..lineTo(59, 84)
          ..close(),
        Paint()..color = C.gold,
      );
    } else if (v == 4) {
      _paintGlow(canvas, const Offset(55, 62), 30, accent, opacity: .3);
      _drawBlock(
        canvas,
        const Rect.fromLTRB(40, 62, 62, 66),
        accent,
        radius: 1,
        depth: 0,
      );
      _drawBlock(
        canvas,
        const Rect.fromLTRB(48, 70, 74, 74),
        accent,
        radius: 1,
        depth: 0,
      );
    } else if (v == 5) {
      for (var i = 0; i < 3; i++) {
        _drawBlock(
          canvas,
          Rect.fromLTRB(38, 38.0 + i * 11, 64, 42.0 + i * 11),
          accent,
          radius: 1,
          depth: 0,
        );
      }
      _drawBlock(
        canvas,
        const Rect.fromLTRB(60, 42, 68, 50),
        accent,
        radius: 2,
        depth: 1,
      );
    } else if (v == 6) {
      final spike = Paint()..color = _lighten(base, .25);
      for (final points in <List<Offset>>[
        [const Offset(38, 30), const Offset(32, 14), const Offset(46, 28)],
        [const Offset(56, 28), const Offset(58, 10), const Offset(66, 30)],
        [const Offset(72, 40), const Offset(88, 30), const Offset(80, 52)],
      ]) {
        canvas.drawPath(
          Path()
            ..moveTo(points[0].dx, points[0].dy)
            ..lineTo(points[1].dx, points[1].dy)
            ..lineTo(points[2].dx, points[2].dy)
            ..close(),
          spike,
        );
      }
    } else if (v == 7) {
      _paintGlow(canvas, const Offset(55, 62), 32, accent, opacity: .35);
      _drawBlock(
        canvas,
        const Rect.fromLTRB(42, 44, 60, 48),
        accent,
        radius: 1,
        depth: 0,
      );
      _drawBlock(
        canvas,
        const Rect.fromLTRB(48, 56, 70, 60),
        accent,
        radius: 1,
        depth: 0,
      );
      _drawSparkle(canvas, const Offset(78, 52), 3, accent);
    } else {
      canvas.drawPath(
        Path()
          ..moveTo(38, 60)
          ..quadraticBezierTo(50, 54, 64, 62)
          ..lineTo(64, 67)
          ..quadraticBezierTo(50, 60, 38, 66)
          ..close(),
        Paint()..color = accent,
      );
    }

    canvas.drawLine(
      const Offset(44, 34),
      const Offset(44, 56),
      Paint()
        ..color = _lighten(base, .3).withValues(alpha: .55)
        ..strokeWidth = 1.5,
    );
    _drawSparkle(canvas, const Offset(18, 68), 3, accent, opacity: .45);
  }

  // ── SYAL ──────────────────────────────────────────────────
  void _paintSyal(Canvas canvas) {
    final base = item.baseColor;
    final accent = item.accentColor;
    final v = item.variant;

    final outer = Path()
      ..addRRect(RRect.fromLTRBR(28, 24, 82, 56, const Radius.circular(16)));
    final inner = Path()
      ..addRRect(RRect.fromLTRBR(40, 34, 70, 48, const Radius.circular(9)));
    final ring = Path.combine(ui.PathOperation.difference, outer, inner);
    _drawVoxelPath(canvas, ring, base, depth: 5);

    _drawVoxelPath(
      canvas,
      Path()
        ..moveTo(36, 48)
        ..lineTo(52, 48)
        ..lineTo(47, 86)
        ..lineTo(33, 86)
        ..close(),
      _darken(base, .1),
      depth: 4,
    );
    _drawVoxelPath(
      canvas,
      Path()
        ..moveTo(64, 48)
        ..lineTo(80, 48)
        ..lineTo(86, 82)
        ..lineTo(76, 88)
        ..lineTo(68, 82)
        ..close(),
      base,
      depth: 4,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(66, 42, 82, 56),
      base,
      radius: 3,
      depth: 2,
    );

    final stripe = Paint()..color = accent.withValues(alpha: .9);
    canvas.drawPath(
      Path()
        ..moveTo(30, 32)
        ..lineTo(80, 32)
        ..lineTo(80, 37)
        ..lineTo(30, 37)
        ..close(),
      stripe,
    );
    canvas.drawPath(
      Path()
        ..moveTo(30, 45)
        ..lineTo(80, 45)
        ..lineTo(80, 50)
        ..lineTo(30, 50)
        ..close(),
      Paint()..color = accent.withValues(alpha: .55),
    );
    if (v == 1) {
      final dot = Paint()..color = Colors.white.withValues(alpha: .75);
      for (var y = 60.0; y < 82; y += 9) {
        canvas.drawCircle(Offset(42, y), 2, dot);
        canvas.drawCircle(Offset(74, y), 2, dot);
      }
    } else if (v == 2) {
      _paintGlow(canvas, const Offset(55, 44), 32, accent, opacity: .3);
      _drawSparkle(canvas, const Offset(30, 64), 4, accent);
      _drawSparkle(canvas, const Offset(82, 60), 3, accent);
    } else if (v == 3) {
      _paintGlow(canvas, const Offset(55, 56), 34, accent, opacity: .35);
      canvas.drawPath(
        ring,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2
          ..color = accent,
      );
      canvas.drawLine(
        const Offset(38, 52),
        const Offset(34, 84),
        Paint()
          ..color = accent
          ..strokeWidth = 2,
      );
    } else if (v == 4) {
      final scale = Paint()..color = accent.withValues(alpha: .8);
      for (var y = 56.0; y < 80; y += 8) {
        for (var x = 38.0; x < 82; x += 10) {
          canvas.drawCircle(Offset(x, y), 2.2, scale);
        }
      }
    } else if (v == 5) {
      _drawSparkle(canvas, const Offset(44, 28), 4, accent);
      _drawSparkle(canvas, const Offset(68, 62), 3.2, accent);
      _drawSparkle(canvas, const Offset(78, 76), 2.4, accent);
    }

    for (var i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(36.0 + i * 4, 84),
        Offset(34.0 + i * 4, 90),
        Paint()
          ..color = accent.withValues(alpha: .7)
          ..strokeWidth = 1.5,
      );
      canvas.drawLine(
        Offset(72.0 + i * 4, 84),
        Offset(70.0 + i * 4, 90),
        Paint()
          ..color = accent.withValues(alpha: .7)
          ..strokeWidth = 1.5,
      );
    }

    _drawSparkle(canvas, const Offset(18, 42), 3, accent, opacity: .45);
  }

  // ── SAYAP ─────────────────────────────────────────────────
  void _paintSayap(Canvas canvas) {
    final base = item.baseColor;
    final accent = item.accentColor;
    final v = item.variant;

    _paintGlow(
      canvas,
      const Offset(55, 54),
      44,
      accent,
      opacity: v == 3 || v == 0 || v == 5 ? .3 : .16,
    );

    Path wing;
    if (v == 0) {
      wing = Path()
        ..moveTo(50, 46)
        ..quadraticBezierTo(18, 22, 9, 44)
        ..quadraticBezierTo(22, 48, 14, 62)
        ..quadraticBezierTo(28, 62, 22, 78)
        ..quadraticBezierTo(40, 68, 50, 76)
        ..close();
    } else if (v == 2) {
      wing = Path()
        ..moveTo(50, 42)
        ..lineTo(16, 26)
        ..lineTo(8, 38)
        ..lineTo(22, 44)
        ..lineTo(6, 54)
        ..lineTo(24, 62)
        ..lineTo(10, 78)
        ..lineTo(38, 66)
        ..lineTo(50, 78)
        ..close();
    } else if (v == 4) {
      wing = Path()
        ..moveTo(50, 44)
        ..lineTo(20, 28)
        ..lineTo(14, 42)
        ..lineTo(30, 50)
        ..lineTo(16, 60)
        ..lineTo(28, 70)
        ..lineTo(18, 82)
        ..lineTo(42, 70)
        ..lineTo(50, 78)
        ..close();
    } else {
      wing = Path()
        ..moveTo(50, 44)
        ..lineTo(16, 28)
        ..lineTo(8, 42)
        ..lineTo(24, 50)
        ..lineTo(6, 58)
        ..lineTo(20, 68)
        ..lineTo(10, 80)
        ..lineTo(40, 68)
        ..lineTo(50, 76)
        ..close();
    }

    for (final side in const [-1, 1]) {
      canvas.save();
      canvas.translate(55, 0);
      if (side == 1) canvas.scale(-1, 1);
      canvas.translate(-55, 0);
      _drawVoxelPath(canvas, wing, base, depth: 5);

      final line = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = accent.withValues(alpha: .8);
      canvas.drawLine(const Offset(48, 48), const Offset(16, 34), line);
      canvas.drawLine(const Offset(46, 58), const Offset(14, 50), line);
      canvas.drawLine(const Offset(44, 66), const Offset(20, 66), line);
      canvas.drawCircle(const Offset(12, 36), 2.2, Paint()..color = accent);

      if (v == 4) {
        for (var i = 0; i < 3; i++) {
          canvas.drawCircle(
            Offset(22.0 + i * 7, 46.0 + i * 8),
            2,
            Paint()..color = accent,
          );
        }
      } else if (v == 5) {
        _drawSparkle(canvas, const Offset(26, 44), 2.5, accent);
        _drawSparkle(canvas, const Offset(18, 62), 2, accent);
      }
      canvas.restore();
    }

    _drawBlock(
      canvas,
      const Rect.fromLTRB(44, 46, 66, 72),
      C.navyCard2,
      radius: 4,
      depth: 3,
    );
    _paintGlow(canvas, const Offset(55, 58), 12, accent, opacity: .55);
    final gem = Path()
      ..moveTo(55, 50)
      ..lineTo(63, 58)
      ..lineTo(55, 68)
      ..lineTo(47, 58)
      ..close();
    _drawVoxelPath(canvas, gem, accent, depth: 3);
    canvas.drawCircle(
      const Offset(55, 57),
      2,
      Paint()..color = Colors.white.withValues(alpha: .85),
    );

    if (v == 3) {
      _drawSparkle(canvas, const Offset(18, 48), 4, accent);
      _drawSparkle(canvas, const Offset(92, 44), 3, accent);
      _drawSparkle(canvas, const Offset(86, 74), 2.4, accent);
    }
  }

  // ── AKSESORIS ─────────────────────────────────────────────
  void _paintAksesoris(Canvas canvas) {
    final base = item.baseColor;
    final accent = item.accentColor;
    final v = item.variant;

    switch (v) {
      case 0:
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(22, 42)
            ..lineTo(48, 42)
            ..lineTo(48, 66)
            ..lineTo(22, 66)
            ..close(),
          base,
          depth: 4,
        );
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(62, 42)
            ..lineTo(88, 42)
            ..lineTo(88, 66)
            ..lineTo(62, 66)
            ..close(),
          base,
          depth: 4,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(48, 51, 62, 55),
          base,
          radius: 1,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(26, 46, 44, 62),
          accent.withValues(alpha: .3),
          radius: 3,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(66, 46, 84, 62),
          accent.withValues(alpha: .3),
          radius: 3,
          depth: 0,
        );
        canvas.drawLine(
          const Offset(30, 48),
          const Offset(40, 48),
          Paint()
            ..color = Colors.white.withValues(alpha: .72)
            ..strokeWidth = 1.5,
        );
        canvas.drawLine(
          const Offset(70, 48),
          const Offset(80, 48),
          Paint()
            ..color = Colors.white.withValues(alpha: .72)
            ..strokeWidth = 1.5,
        );
        canvas.drawLine(
          const Offset(22, 52),
          const Offset(16, 48),
          Paint()
            ..color = accent
            ..strokeWidth = 2,
        );
        canvas.drawLine(
          const Offset(88, 52),
          const Offset(94, 48),
          Paint()
            ..color = accent
            ..strokeWidth = 2,
        );
      case 1:
        final band = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round
          ..color = base;
        canvas.drawArc(
          const Rect.fromLTRB(24, 24, 86, 78),
          math.pi * 1.05,
          math.pi * .9,
          false,
          band,
        );
        canvas.drawArc(
          const Rect.fromLTRB(24, 24, 86, 78),
          math.pi * 1.08,
          math.pi * .84,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round
            ..color = _lighten(base, .25),
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(18, 54, 34, 78),
          base,
          radius: 6,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(76, 54, 92, 78),
          base,
          radius: 6,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(20, 58, 32, 74),
          accent,
          radius: 5,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(78, 58, 90, 74),
          accent,
          radius: 5,
          depth: 1,
        );
        _paintGlow(canvas, const Offset(55, 60), 20, accent, opacity: .16);
      case 2:
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(34, 32)
            ..lineTo(76, 32)
            ..lineTo(76, 80)
            ..lineTo(34, 80)
            ..close(),
          base,
          depth: 5,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(42, 52, 68, 72),
          _darken(base, .18),
          radius: 4,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(46, 56, 64, 60),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(24, 46, 34, 70),
          _darken(base, .1),
          radius: 3,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(76, 46, 86, 70),
          _darken(base, .1),
          radius: 3,
          depth: 2,
        );
        final handle = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..color = _darken(base, .15);
        canvas.drawArc(
          const Rect.fromLTRB(46, 22, 64, 40),
          math.pi,
          math.pi,
          false,
          handle,
        );
        canvas.drawLine(
          const Offset(42, 42),
          const Offset(36, 76),
          Paint()
            ..color = accent.withValues(alpha: .8)
            ..strokeWidth = 3,
        );
        canvas.drawLine(
          const Offset(68, 42),
          const Offset(74, 76),
          Paint()
            ..color = accent.withValues(alpha: .8)
            ..strokeWidth = 3,
        );
      case 3:
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(46, 26)
            ..lineTo(64, 26)
            ..lineTo(64, 82)
            ..lineTo(46, 82)
            ..close(),
          _darken(base, .18),
          depth: 4,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(40, 38, 70, 70),
          base,
          radius: 15,
          depth: 4,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(44, 42, 66, 66),
          C.navyDeep,
          radius: 11,
          depth: 1,
        );
        canvas.drawCircle(
          const Offset(55, 54),
          7,
          Paint()..color = accent.withValues(alpha: .22),
        );
        canvas.drawLine(
          const Offset(55, 54),
          const Offset(55, 46),
          Paint()
            ..color = accent
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round,
        );
        canvas.drawLine(
          const Offset(55, 54),
          const Offset(61, 58),
          Paint()
            ..color = accent
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(70, 46, 75, 53),
          accent,
          radius: 2,
          depth: 1,
        );
        _drawSparkle(canvas, const Offset(86, 44), 3, accent, opacity: .5);
      case 4:
        _paintGlow(canvas, const Offset(55, 56), 34, accent, opacity: .35);
        final crystal = Path()
          ..moveTo(55, 18)
          ..lineTo(79, 42)
          ..lineTo(69, 76)
          ..lineTo(55, 89)
          ..lineTo(41, 76)
          ..lineTo(31, 42)
          ..close();
        _drawVoxelPath(canvas, crystal, base, depth: 5);
        canvas.drawPath(
          Path()
            ..moveTo(55, 18)
            ..lineTo(55, 89)
            ..lineTo(31, 42)
            ..close(),
          Paint()..color = _lighten(base, .2).withValues(alpha: .55),
        );
        canvas.drawPath(
          Path()
            ..moveTo(55, 18)
            ..lineTo(79, 42)
            ..lineTo(55, 68)
            ..close(),
          Paint()..color = _darken(base, .12).withValues(alpha: .5),
        );
        canvas.drawLine(
          const Offset(55, 26),
          const Offset(55, 58),
          Paint()
            ..color = Colors.white.withValues(alpha: .8)
            ..strokeWidth = 1.5,
        );
        _drawSparkle(canvas, const Offset(22, 34), 4, accent);
        _drawSparkle(canvas, const Offset(88, 66), 3, accent);
      case 5:
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(30, 40)
            ..lineTo(80, 40)
            ..lineTo(74, 74)
            ..lineTo(55, 86)
            ..lineTo(36, 74)
            ..close(),
          base,
          depth: 5,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(38, 54, 72, 62),
          accent,
          radius: 2,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(41, 58, 53, 74),
          _darken(base, .2),
          radius: 5,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(57, 58, 69, 74),
          _darken(base, .2),
          radius: 5,
          depth: 2,
        );
        canvas.drawCircle(const Offset(47, 66), 3.5, Paint()..color = accent);
        canvas.drawCircle(const Offset(63, 66), 3.5, Paint()..color = accent);
        canvas.drawLine(
          const Offset(30, 46),
          const Offset(18, 40),
          Paint()
            ..color = accent.withValues(alpha: .75)
            ..strokeWidth = 2,
        );
        canvas.drawLine(
          const Offset(80, 46),
          const Offset(92, 40),
          Paint()
            ..color = accent.withValues(alpha: .75)
            ..strokeWidth = 2,
        );
        _paintGlow(canvas, const Offset(55, 66), 22, accent, opacity: .14);
    }

    _drawSparkle(canvas, const Offset(18, 62), 3, accent, opacity: .45);
    _drawSparkle(canvas, const Offset(92, 58), 2.5, accent, opacity: .4);
  }

  @override
  bool shouldRepaint(covariant _CostumeArtPainter oldDelegate) =>
      oldDelegate.item.id != item.id;
}

// ============================================================
// AVATAR VOXEL UNTUK PREVIEW
// ============================================================

class _ShopAvatarPainter extends CustomPainter {
  final Map<CostumeCategory, CostumeItem> equipped;
  const _ShopAvatarPainter({required this.equipped});

  CostumeItem? get _baju => equipped[CostumeCategory.baju];
  CostumeItem? get _topi => equipped[CostumeCategory.topi];
  CostumeItem? get _sepatu => equipped[CostumeCategory.sepatu];
  CostumeItem? get _syal => equipped[CostumeCategory.syal];
  CostumeItem? get _sayap => equipped[CostumeCategory.sayap];
  CostumeItem? get _aksesoris => equipped[CostumeCategory.aksesoris];

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final scale = math.min(size.width / 340, size.height / 270);
    canvas.save();
    canvas.translate(size.width / 2, size.height * .95);
    canvas.scale(scale);
    _paintAvatar(canvas);
    canvas.restore();
  }

  void _paintAvatar(Canvas canvas) {
    final baju = _baju;
    final topi = _topi;
    final sepatu = _sepatu;
    final syal = _syal;
    final sayap = _sayap;
    final akses = _aksesoris;

    final shirt = baju?.baseColor ?? C.navyCard2;
    final accent = baju?.accentColor ?? C.cyan;

    _paintGlow(canvas, const Offset(0, -44), 72, C.cyan, opacity: .1);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, -3), width: 104, height: 18),
      Paint()..color = Colors.black.withValues(alpha: .4),
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, -4), width: 74, height: 10),
      Paint()..color = C.cyan.withValues(alpha: .16),
    );

    if (sayap != null) _paintWings(canvas, sayap);
    if (baju?.variant == 9) _paintCape(canvas, shirt, accent);
    if (akses?.variant == 2) _paintBackpackBack(canvas, akses!);

    _paintLegs(canvas);
    _paintShoes(canvas, sepatu);
    _paintArms(canvas, baju, akses);

    _drawBlock(
      canvas,
      const Rect.fromLTRB(-38, -150, 38, -64),
      C.navyCard2,
      radius: 4,
      depth: 3,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-34, -146, 34, -70),
      C.navyDeep,
      radius: 4,
      depth: 2,
    );

    _paintShirt(canvas, shirt, accent, baju?.variant ?? -1);
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-34, -80, 34, -71),
      C.navyDeep,
      radius: 2,
      depth: 2,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-6, -79, 6, -72),
      accent,
      radius: 2,
      depth: 1,
    );

    _drawBlock(
      canvas,
      const Rect.fromLTRB(-13, -162, 13, -148),
      C.navyCard2,
      radius: 2,
      depth: 2,
    );
    if (syal != null) _paintScarf(canvas, syal);

    _paintHead(canvas, akses);
    if (akses?.variant == 1) _paintHeadphones(canvas, akses!);
    if (topi != null) _paintHat(canvas, topi);
    if (akses != null) _paintAccessoryFront(canvas, akses);

    if (topi == null) {
      _drawSparkle(
        canvas,
        const Offset(-86, -186),
        4.2,
        C.cyanSoft,
        opacity: .6,
      );
      _drawSparkle(canvas, const Offset(88, -108), 3.2, C.gold, opacity: .6);
    }
    _drawSparkle(canvas, const Offset(92, -176), 2.6, accent, opacity: .5);
  }

  // ── KAKI & SEPATU ─────────────────────────────────────────
  void _paintLegs(Canvas canvas) {
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-28, -72, -8, -16),
      C.navyCard2,
      radius: 3,
      depth: 3,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(8, -72, 28, -16),
      C.navyCard2,
      radius: 3,
      depth: 3,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-27, -54, -9, -48),
      C.cyan.withValues(alpha: .5),
      radius: 1,
      depth: 0,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(9, -54, 27, -48),
      C.cyan.withValues(alpha: .5),
      radius: 1,
      depth: 0,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-27, -34, -9, -29),
      C.navyLine,
      radius: 1,
      depth: 0,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(9, -34, 27, -29),
      C.navyLine,
      radius: 1,
      depth: 0,
    );
  }

  void _paintShoes(Canvas canvas, CostumeItem? item) {
    final base = item?.baseColor ?? C.navyCard2;
    final accent = item?.accentColor ?? C.cyan;
    final v = item?.variant ?? -1;

    if (v == 3 || v == 4 || v == 7) {
      _paintGlow(
        canvas,
        const Offset(0, -8),
        44,
        accent,
        opacity: v == 3 ? .35 : .18,
      );
    }

    _paintShoeSide(canvas, -36, -4, base, accent, v, true);
    _paintShoeSide(canvas, 4, 36, base, accent, v, false);

    if (v == 3) {
      canvas.drawPath(
        Path()
          ..moveTo(-36, -14)
          ..lineTo(-51, -8)
          ..lineTo(-36, -2)
          ..close(),
        Paint()..color = _darken(base, .1),
      );
      canvas.drawPath(
        Path()
          ..moveTo(36, -14)
          ..lineTo(51, -8)
          ..lineTo(36, -2)
          ..close(),
        Paint()..color = _darken(base, .1),
      );
      _paintGlow(canvas, const Offset(-20, 3), 12, C.orange, opacity: .7);
      _paintGlow(canvas, const Offset(20, 3), 12, C.orange, opacity: .7);
      canvas.drawPath(
        Path()
          ..moveTo(-27, -1)
          ..lineTo(-20, 12)
          ..lineTo(-13, -1)
          ..close(),
        Paint()..color = C.orange,
      );
      canvas.drawPath(
        Path()
          ..moveTo(13, -1)
          ..lineTo(20, 12)
          ..lineTo(27, -1)
          ..close(),
        Paint()..color = C.orange,
      );
      canvas.drawPath(
        Path()
          ..moveTo(-24, -1)
          ..lineTo(-20, 7)
          ..lineTo(-16, -1)
          ..close(),
        Paint()..color = C.gold,
      );
      canvas.drawPath(
        Path()
          ..moveTo(16, -1)
          ..lineTo(20, 7)
          ..lineTo(24, -1)
          ..close(),
        Paint()..color = C.gold,
      );
    }

    if (v == 6) {
      final spike = Paint()..color = _lighten(base, .25);
      for (final x in <double>[-31, -17, 17, 31]) {
        canvas.drawPath(
          Path()
            ..moveTo(x, -18)
            ..lineTo(x + (x < 0 ? -5 : 5), -32)
            ..lineTo(x + (x < 0 ? 8 : -8), -18)
            ..close(),
          spike,
        );
      }
    }
  }

  void _paintShoeSide(
    Canvas canvas,
    double left,
    double right,
    Color base,
    Color accent,
    int v,
    bool leftFoot,
  ) {
    _drawBlock(
      canvas,
      Rect.fromLTRB(left, -18, right, 0),
      base,
      radius: 4,
      depth: 3,
    );
    _drawBlock(
      canvas,
      Rect.fromLTRB(left, -5, right, 0),
      _darken(base, .4),
      radius: 2,
      depth: 1,
    );
    final toeLeft = leftFoot ? left + 2 : right - 15;
    _drawBlock(
      canvas,
      Rect.fromLTRB(toeLeft, -14, toeLeft + 13, -5),
      _lighten(base, .1),
      radius: 3,
      depth: 1,
    );

    if (v == 1) {
      _drawBlock(
        canvas,
        Rect.fromLTRB(left + 2, -31, right - 2, -16),
        _darken(base, .08),
        radius: 3,
        depth: 2,
      );
      for (var i = 0; i < 3; i++) {
        canvas.drawLine(
          Offset(left + 5, -28.0 + i * 5),
          Offset(right - 5, -31.0 + i * 5),
          Paint()
            ..color = accent.withValues(alpha: .75)
            ..strokeWidth = 1.4,
        );
      }
    } else if (v == 2) {
      for (var i = 0; i < 2; i++) {
        canvas.drawLine(
          Offset(left + 2, -15.0 + i * 6),
          Offset(right - 2, -11.0 + i * 6),
          Paint()
            ..color = accent.withValues(alpha: .7)
            ..strokeWidth = 2,
        );
      }
    } else if (v == 4) {
      _drawBlock(
        canvas,
        Rect.fromLTRB(left + 3, -12, right - 3, -9),
        accent,
        radius: 1,
        depth: 0,
      );
      _paintGlow(
        canvas,
        Offset((left + right) / 2, -10),
        16,
        accent,
        opacity: .25,
      );
    } else if (v == 5) {
      for (var i = 0; i < 2; i++) {
        _drawBlock(
          canvas,
          Rect.fromLTRB(left + 2, -16.0 + i * 6, right - 2, -13.0 + i * 6),
          accent,
          radius: 1,
          depth: 0,
        );
      }
      _drawBlock(
        canvas,
        Rect.fromLTRB(left + 4, -18, left + 10, -12),
        accent,
        radius: 1,
        depth: 1,
      );
    } else if (v == 7) {
      _drawBlock(
        canvas,
        Rect.fromLTRB(left + 3, -12, right - 3, -9),
        accent,
        radius: 1,
        depth: 0,
      );
      _drawSparkle(canvas, Offset((left + right) / 2, -13), 2.4, accent);
    } else {
      _drawBlock(
        canvas,
        Rect.fromLTRB(left + 2, -12, right - 2, -9),
        accent,
        radius: 1,
        depth: 0,
      );
      _drawBlock(
        canvas,
        Rect.fromLTRB(left + 2, -16, left + 12, -13),
        _lighten(base, .22),
        radius: 1,
        depth: 0,
      );
    }
  }

  // ── LENGAN & TORSO ────────────────────────────────────────
  void _paintArms(Canvas canvas, CostumeItem? baju, CostumeItem? akses) {
    final sleeve = baju?.baseColor ?? C.navyCard2;
    final vest = baju?.variant == 5;
    _paintArm(canvas, -58, -38, sleeve, vest);
    _paintArm(canvas, 38, 58, sleeve, vest);

    if (akses?.variant == 3) {
      _drawBlock(
        canvas,
        const Rect.fromLTRB(-61, -98, -39, -86),
        akses!.baseColor,
        radius: 3,
        depth: 2,
      );
      _drawBlock(
        canvas,
        const Rect.fromLTRB(-59, -96, -41, -88),
        C.navyDeep,
        radius: 2,
        depth: 1,
      );
      _paintGlow(
        canvas,
        const Offset(-50, -92),
        7,
        akses.accentColor,
        opacity: .55,
      );
      canvas.drawCircle(
        const Offset(-50, -92),
        3.2,
        Paint()..color = akses.accentColor,
      );
      canvas.drawLine(
        const Offset(-50, -92),
        const Offset(-50, -96),
        Paint()
          ..color = Colors.white.withValues(alpha: .8)
          ..strokeWidth = 1,
      );
    }
  }

  void _paintArm(
    Canvas canvas,
    double left,
    double right,
    Color sleeve,
    bool vest,
  ) {
    _drawBlock(
      canvas,
      Rect.fromLTRB(left, -112, right, -80),
      C.navyCard2,
      radius: 2,
      depth: 2,
    );
    _drawBlock(
      canvas,
      Rect.fromLTRB(left, -146, right, -112),
      vest ? C.navyCard2 : sleeve,
      radius: 2,
      depth: 2.5,
    );
    _drawBlock(
      canvas,
      Rect.fromLTRB(left, -146, right, -136),
      vest ? C.navyCard2 : _lighten(sleeve, .08),
      radius: 3,
      depth: 2,
    );
    _drawBlock(
      canvas,
      Rect.fromLTRB(left + 2, -80, right - 2, -70),
      C.navyCard2,
      radius: 3,
      depth: 2,
    );
    _drawBlock(
      canvas,
      Rect.fromLTRB(left + 3, -86, right - 3, -82),
      C.navyLine,
      radius: 1,
      depth: 0,
    );
  }

  void _paintShirt(Canvas canvas, Color base, Color accent, int v) {
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-34, -146, 34, -70),
      base,
      radius: 3,
      depth: 3,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-34, -146, 34, -138),
      _lighten(base, .07),
      radius: 3,
      depth: 2,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-17, -151, 17, -141),
      _darken(base, .2),
      radius: 3,
      depth: 2,
    );
    if (v < 0) {
      _drawBlock(
        canvas,
        const Rect.fromLTRB(-20, -132, 20, -98),
        C.navyDeep,
        radius: 5,
        depth: 2,
      );
      _paintGlow(canvas, const Offset(0, -115), 14, C.cyan, opacity: .4);
      canvas.drawCircle(const Offset(0, -115), 5, Paint()..color = C.cyan);
      _drawBlock(
        canvas,
        const Rect.fromLTRB(-4, -127, 4, -123),
        C.cyan,
        radius: 1,
        depth: 0,
      );
      _drawBlock(
        canvas,
        const Rect.fromLTRB(-4, -119, 4, -115),
        C.cyan,
        radius: 1,
        depth: 0,
      );
      return;
    }

    switch (v) {
      case 0:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-12, -132, 12, -108),
          accent,
          radius: 5,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-8, -128, 8, -112),
          _darken(base, .28),
          radius: 3,
          depth: 1,
        );
        canvas.drawLine(
          const Offset(-4, -120),
          const Offset(4, -120),
          Paint()
            ..color = Colors.white.withValues(alpha: .85)
            ..strokeWidth = 1.8,
        );
      case 1:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-2, -140, 2, -74),
          _darken(base, .35),
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-28, -98, -16, -94),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(16, -98, 28, -94),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-6, -127, 6, -121),
          _lighten(accent, .18),
          radius: 2,
          depth: 1,
        );
        canvas.drawCircle(const Offset(0, -110), 2.5, Paint()..color = accent);
      case 2:
        canvas.drawPath(
          Path()
            ..moveTo(-34, -116)
            ..lineTo(34, -132)
            ..lineTo(34, -122)
            ..lineTo(-34, -106)
            ..close(),
          Paint()..color = accent.withValues(alpha: .88),
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-34, -84, 34, -76),
          C.navyDeep,
          radius: 2,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-7, -83, 7, -77),
          accent,
          radius: 1,
          depth: 1,
        );
        canvas.drawCircle(
          const Offset(-20, -110),
          3,
          Paint()..color = _lighten(accent, .25),
        );
      case 3:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-23, -138, 23, -98),
          _lighten(base, .12),
          radius: 4,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-18, -134, 18, -102),
          _darken(base, .2),
          radius: 3,
          depth: 2,
        );
        _paintGlow(canvas, const Offset(0, -118), 12, accent, opacity: .55);
        canvas.drawCircle(const Offset(0, -118), 5, Paint()..color = accent);
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-56, -151, -34, -136),
          _lighten(base, .06),
          radius: 4,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(34, -151, 56, -136),
          _lighten(base, .06),
          radius: 4,
          depth: 3,
        );
        canvas.drawLine(
          const Offset(-50, -144),
          const Offset(-40, -144),
          Paint()
            ..color = accent
            ..strokeWidth = 2,
        );
        canvas.drawLine(
          const Offset(40, -144),
          const Offset(50, -144),
          Paint()
            ..color = accent
            ..strokeWidth = 2,
        );
      case 4:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-31, -164, 31, -142),
          base,
          radius: 6,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-18, -98, 18, -78),
          _darken(base, .24),
          radius: 4,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-8, -140, -6, -116),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(6, -140, 8, -116),
          accent,
          radius: 1,
          depth: 0,
        );
        canvas.drawCircle(const Offset(-7, -114), 2, Paint()..color = accent);
        canvas.drawCircle(const Offset(7, -114), 2, Paint()..color = accent);
      case 5:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-24, -142, 24, -74),
          _darken(base, .45),
          radius: 3,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-30, -146, -23, -72),
          accent,
          radius: 2,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(23, -146, 30, -72),
          accent,
          radius: 2,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-12, -134, 12, -118),
          _lighten(accent, .12),
          radius: 3,
          depth: 1,
        );
      case 6:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-34, -74, 34, -52),
          base,
          radius: 3,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-34, -84, 34, -75),
          _darken(base, .35),
          radius: 2,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-7, -83, 7, -76),
          accent,
          radius: 1,
          depth: 1,
        );
        canvas.drawLine(
          const Offset(-28, -142),
          const Offset(-10, -88),
          Paint()
            ..color = accent.withValues(alpha: .45)
            ..strokeWidth = 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-34, -56, 34, -52),
          accent.withValues(alpha: .45),
          radius: 1,
          depth: 0,
        );
      case 7:
        canvas.drawPath(
          Path()
            ..moveTo(-30, -146)
            ..lineTo(-4, -112)
            ..lineTo(-20, -92)
            ..close(),
          Paint()..color = _darken(base, .28),
        );
        canvas.drawPath(
          Path()
            ..moveTo(30, -146)
            ..lineTo(4, -112)
            ..lineTo(20, -92)
            ..close(),
          Paint()..color = _darken(base, .28),
        );
        canvas.drawPath(
          Path()
            ..moveTo(-12, -141)
            ..lineTo(0, -124)
            ..lineTo(12, -141)
            ..close(),
          Paint()..color = _lighten(base, .45),
        );
        canvas.drawPath(
          Path()
            ..moveTo(0, -132)
            ..lineTo(5, -122)
            ..lineTo(0, -110)
            ..lineTo(-5, -122)
            ..close(),
          Paint()..color = accent,
        );
        for (var y = -104.0; y < -82; y += 8) {
          canvas.drawCircle(
            Offset(0, y),
            1.5,
            Paint()..color = _lighten(base, .4),
          );
        }
      case 8:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-34, -132, 34, -126),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-34, -104, 34, -98),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-7, -122, 5, -118),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(1, -118, 5, -108),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-7, -112, 5, -108),
          accent,
          radius: 1,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-7, -118, -3, -112),
          accent,
          radius: 1,
          depth: 0,
        );
      case 9:
        _paintGlow(canvas, const Offset(0, -145), 14, accent, opacity: .5);
        canvas.drawCircle(const Offset(0, -145), 4, Paint()..color = accent);
        canvas.drawPath(
          Path()
            ..moveTo(-20, -140)
            ..lineTo(0, -116)
            ..lineTo(20, -140),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = accent.withValues(alpha: .6),
        );
    }

    _drawBlock(
      canvas,
      const Rect.fromLTRB(-34, -73, 34, -70),
      accent.withValues(alpha: .65),
      radius: 1,
      depth: 0,
    );
  }

  // ── CAPE, WINGS, BACKPACK ─────────────────────────────────
  void _paintCape(Canvas canvas, Color base, Color accent) {
    final cape = Path()
      ..moveTo(-28, -148)
      ..lineTo(28, -148)
      ..lineTo(55, -38)
      ..lineTo(18, -52)
      ..lineTo(0, -32)
      ..lineTo(-18, -52)
      ..lineTo(-55, -38)
      ..close();
    _drawVoxelPath(canvas, cape, _darken(base, .08), depth: 4);
    canvas.drawPath(
      Path()
        ..moveTo(-52, -40)
        ..lineTo(-18, -52)
        ..lineTo(0, -34)
        ..lineTo(18, -52)
        ..lineTo(52, -40),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = accent.withValues(alpha: .55),
    );
  }

  void _paintWings(Canvas canvas, CostumeItem item) {
    final base = item.baseColor;
    final accent = item.accentColor;
    final v = item.variant;

    _paintGlow(
      canvas,
      const Offset(0, -128),
      72,
      accent,
      opacity: v == 3 || v == 0 || v == 5 ? .3 : .15,
    );

    Path wing;
    if (v == 0) {
      wing = Path()
        ..moveTo(-28, 2)
        ..quadraticBezierTo(-72, -30, -102, -6)
        ..quadraticBezierTo(-88, 8, -100, 24)
        ..quadraticBezierTo(-76, 22, -82, 44)
        ..quadraticBezierTo(-54, 32, -36, 40)
        ..close();
    } else if (v == 2) {
      wing = Path()
        ..moveTo(-28, 2)
        ..lineTo(-104, -34)
        ..lineTo(-112, -18)
        ..lineTo(-90, 0)
        ..lineTo(-108, 16)
        ..lineTo(-84, 26)
        ..lineTo(-94, 44)
        ..lineTo(-60, 32)
        ..lineTo(-36, 42)
        ..close();
    } else if (v == 4) {
      wing = Path()
        ..moveTo(-28, 2)
        ..lineTo(-92, -26)
        ..lineTo(-98, -8)
        ..lineTo(-78, 2)
        ..lineTo(-94, 20)
        ..lineTo(-72, 30)
        ..lineTo(-80, 44)
        ..lineTo(-48, 32)
        ..lineTo(-36, 40)
        ..close();
    } else {
      wing = Path()
        ..moveTo(-28, 2)
        ..lineTo(-100, -30)
        ..lineTo(-108, -14)
        ..lineTo(-88, 0)
        ..lineTo(-106, 14)
        ..lineTo(-84, 28)
        ..lineTo(-92, 46)
        ..lineTo(-60, 34)
        ..lineTo(-36, 42)
        ..close();
    }

    for (final side in const [-1, 1]) {
      canvas.save();
      canvas.translate(0, -128);
      if (side == 1) canvas.scale(-1, 1);
      _drawVoxelPath(canvas, wing, base, depth: 4);

      final line = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = accent.withValues(alpha: .82);
      canvas.drawLine(const Offset(-34, 4), const Offset(-96, -22), line);
      canvas.drawLine(const Offset(-33, 14), const Offset(-90, 2), line);
      canvas.drawLine(const Offset(-34, 24), const Offset(-76, 20), line);
      canvas.drawCircle(const Offset(-100, -24), 2.2, Paint()..color = accent);

      if (v == 4) {
        for (var i = 0; i < 3; i++) {
          canvas.drawCircle(
            Offset(-68.0 + i * 10, -6.0 + i * 12),
            2,
            Paint()..color = accent,
          );
        }
      } else if (v == 5) {
        _drawSparkle(canvas, const Offset(-70, -4), 2.4, accent);
        _drawSparkle(canvas, const Offset(-82, 24), 2, accent);
      }
      canvas.restore();
    }

    _drawBlock(
      canvas,
      const Rect.fromLTRB(-13, -142, 13, -112),
      C.navyCard2,
      radius: 4,
      depth: 3,
    );
    _paintGlow(canvas, const Offset(0, -127), 12, accent, opacity: .55);
    final gem = Path()
      ..moveTo(0, -136)
      ..lineTo(8, -127)
      ..lineTo(0, -116)
      ..lineTo(-8, -127)
      ..close();
    _drawVoxelPath(canvas, gem, accent, depth: 3);
  }

  void _paintBackpackBack(Canvas canvas, CostumeItem item) {
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-45, -142, 45, -76),
      item.baseColor,
      radius: 5,
      depth: 3,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-50, -122, -39, -84),
      _darken(item.baseColor, .12),
      radius: 3,
      depth: 2,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(39, -122, 50, -84),
      _darken(item.baseColor, .12),
      radius: 3,
      depth: 2,
    );
    final handle = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = _darken(item.baseColor, .2);
    canvas.drawArc(
      const Rect.fromLTRB(-18, -154, 18, -136),
      math.pi,
      math.pi,
      false,
      handle,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-46, -104, -39, -98),
      item.accentColor,
      radius: 1,
      depth: 1,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(39, -104, 46, -98),
      item.accentColor,
      radius: 1,
      depth: 1,
    );
  }

  // ── SYAL ──────────────────────────────────────────────────
  void _paintScarf(Canvas canvas, CostumeItem item) {
    final base = item.baseColor;
    final accent = item.accentColor;
    final v = item.variant;

    _drawBlock(
      canvas,
      const Rect.fromLTRB(-30, -160, 30, -146),
      base,
      radius: 4,
      depth: 2,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(17, -158, 32, -142),
      base,
      radius: 3,
      depth: 2,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(16, -146, 28, -106),
      base,
      radius: 3,
      depth: 2,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(27, -146, 39, -112),
      _darken(base, .12),
      radius: 3,
      depth: 2,
    );

    final stripe = Paint()..color = accent.withValues(alpha: .9);
    canvas.drawRect(const Rect.fromLTRB(-30, -154, 30, -150), stripe);
    canvas.drawRect(const Rect.fromLTRB(16, -136, 28, -132), stripe);
    canvas.drawRect(const Rect.fromLTRB(27, -128, 39, -124), stripe);

    if (v == 1) {
      final dot = Paint()..color = Colors.white.withValues(alpha: .7);
      canvas.drawCircle(const Offset(-18, -154), 2, dot);
      canvas.drawCircle(const Offset(4, -154), 2, dot);
      canvas.drawCircle(const Offset(22, -136), 2, dot);
      canvas.drawCircle(const Offset(33, -120), 2, dot);
    } else if (v == 2 || v == 5) {
      _paintGlow(canvas, const Offset(0, -150), 30, accent, opacity: .28);
      _drawSparkle(canvas, const Offset(-24, -152), 3, accent);
      _drawSparkle(canvas, const Offset(32, -120), 2.5, accent);
    } else if (v == 3) {
      _paintGlow(canvas, const Offset(0, -150), 28, accent, opacity: .3);
      canvas.drawLine(
        const Offset(16, -144),
        const Offset(16, -108),
        Paint()
          ..color = accent
          ..strokeWidth = 2,
      );
    } else if (v == 4) {
      final scale = Paint()..color = accent.withValues(alpha: .8);
      for (var y = -146.0; y < -112; y += 8) {
        canvas.drawCircle(Offset(22, y), 2, scale);
        canvas.drawCircle(Offset(33, y), 2, scale);
      }
    }

    for (var i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(17.0 + i * 4, -106),
        Offset(16.0 + i * 4, -100),
        Paint()
          ..color = accent.withValues(alpha: .7)
          ..strokeWidth = 1.4,
      );
      canvas.drawLine(
        Offset(29.0 + i * 4, -112),
        Offset(28.0 + i * 4, -106),
        Paint()
          ..color = accent.withValues(alpha: .7)
          ..strokeWidth = 1.4,
      );
    }

    _drawBlock(
      canvas,
      const Rect.fromLTRB(22, -148, 28, -142),
      accent,
      radius: 1,
      depth: 1,
    );
  }

  // ── KEPALA & WAJAH ────────────────────────────────────────
  void _paintHead(Canvas canvas, CostumeItem? akses) {
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-32, -208, 32, -154),
      C.navyCard2,
      radius: 5,
      depth: 4,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-28, -204, 28, -196),
      _lighten(C.navyCard2, .12),
      radius: 3,
      depth: 1,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-24, -198, 24, -170),
      C.navyDeep,
      radius: 5,
      depth: 1,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-22, -196, 22, -172),
      const Color(0xFF07142C),
      radius: 4,
      depth: 0,
    );

    _paintGlow(canvas, const Offset(-12, -188), 7, C.cyan, opacity: .5);
    _paintGlow(canvas, const Offset(12, -188), 7, C.cyan, opacity: .5);
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-15, -193, -9, -183),
      C.cyan,
      radius: 2,
      depth: 0,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(9, -193, 15, -183),
      C.cyan,
      radius: 2,
      depth: 0,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-6, -178, -2, -175),
      C.cyanSoft,
      radius: 1,
      depth: 0,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(2, -178, 6, -175),
      C.cyanSoft,
      radius: 1,
      depth: 0,
    );

    _drawBlock(
      canvas,
      const Rect.fromLTRB(-37, -192, -32, -172),
      C.navyCard2,
      radius: 2,
      depth: 1,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(32, -192, 37, -172),
      C.navyCard2,
      radius: 2,
      depth: 1,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(16, -224, 20, -208),
      C.navyCard2,
      radius: 1,
      depth: 1,
    );
    _paintGlow(canvas, const Offset(18, -226), 6, C.cyan, opacity: .6);
    canvas.drawCircle(const Offset(18, -226), 3, Paint()..color = C.cyan);

    if (akses?.variant == 5) {
      _drawBlock(
        canvas,
        const Rect.fromLTRB(-24, -184, 24, -164),
        akses!.baseColor,
        radius: 5,
        depth: 2,
      );
      _drawBlock(
        canvas,
        const Rect.fromLTRB(-18, -178, -4, -170),
        _darken(akses.baseColor, .22),
        radius: 4,
        depth: 1,
      );
      _drawBlock(
        canvas,
        const Rect.fromLTRB(4, -178, 18, -170),
        _darken(akses.baseColor, .22),
        radius: 4,
        depth: 1,
      );
      canvas.drawCircle(
        const Offset(-11, -174),
        3,
        Paint()..color = akses.accentColor,
      );
      canvas.drawCircle(
        const Offset(11, -174),
        3,
        Paint()..color = akses.accentColor,
      );
      canvas.drawLine(
        const Offset(-24, -176),
        const Offset(-36, -180),
        Paint()
          ..color = akses.accentColor.withValues(alpha: .75)
          ..strokeWidth = 2,
      );
      canvas.drawLine(
        const Offset(24, -176),
        const Offset(36, -180),
        Paint()
          ..color = akses.accentColor.withValues(alpha: .75)
          ..strokeWidth = 2,
      );
    }
  }

  void _paintHeadphones(Canvas canvas, CostumeItem item) {
    final band = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..color = item.baseColor;
    canvas.drawArc(
      const Rect.fromLTRB(-38, -226, 38, -172),
      math.pi * 1.05,
      math.pi * .9,
      false,
      band,
    );
    canvas.drawArc(
      const Rect.fromLTRB(-38, -226, 38, -172),
      math.pi * 1.08,
      math.pi * .84,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = _lighten(item.baseColor, .3),
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-45, -196, -32, -170),
      item.baseColor,
      radius: 5,
      depth: 3,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(32, -196, 45, -170),
      item.baseColor,
      radius: 5,
      depth: 3,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(-43, -192, -34, -174),
      item.accentColor,
      radius: 4,
      depth: 1,
    );
    _drawBlock(
      canvas,
      const Rect.fromLTRB(34, -192, 43, -174),
      item.accentColor,
      radius: 4,
      depth: 1,
    );
    _paintGlow(
      canvas,
      const Offset(0, -206),
      28,
      item.accentColor,
      opacity: .16,
    );
  }

  // ── TOPI ──────────────────────────────────────────────────
  void _paintHat(Canvas canvas, CostumeItem item) {
    final base = item.baseColor;
    final accent = item.accentColor;
    final v = item.variant;

    switch (v) {
      case 0:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-42, -204, 42, -196),
          _darken(base, .2),
          radius: 3,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-30, -230, 30, -202),
          base,
          radius: 4,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-30, -212, 30, -204),
          accent,
          radius: 1,
          depth: 1,
        );
        canvas.drawCircle(
          const Offset(0, -219),
          5,
          Paint()..color = _lighten(accent, .1),
        );
        canvas.drawCircle(
          const Offset(0, -219),
          2.4,
          Paint()..color = _darken(base, .25),
        );
      case 1:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-30, -238, -10, -212),
          base,
          radius: 10,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-18, -242, 6, -212),
          base,
          radius: 12,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-2, -238, 20, -212),
          base,
          radius: 10,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-30, -216, 30, -204),
          _lighten(base, .05),
          radius: 3,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-30, -212, 30, -207),
          accent,
          radius: 1,
          depth: 1,
        );
      case 2:
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(-36, -204)
            ..quadraticBezierTo(-36, -244, 0, -244)
            ..quadraticBezierTo(36, -244, 36, -204)
            ..close(),
          base,
          depth: 4,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-38, -212, 38, -194),
          accent.withValues(alpha: .68),
          radius: 9,
          depth: 2,
        );
        canvas.drawLine(
          const Offset(-30, -206),
          const Offset(-2, -206),
          Paint()
            ..color = Colors.white.withValues(alpha: .75)
            ..strokeWidth = 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-42, -208, -34, -194),
          _darken(base, .16),
          radius: 2,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(34, -208, 42, -194),
          _darken(base, .16),
          radius: 2,
          depth: 1,
        );
      case 3:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-30, -222, 30, -208),
          base,
          radius: 3,
          depth: 3,
        );
        for (final prong in <Path>[
          Path()
            ..moveTo(-30, -220)
            ..lineTo(-24, -246)
            ..lineTo(-16, -220)
            ..close(),
          Path()
            ..moveTo(-16, -220)
            ..lineTo(0, -250)
            ..lineTo(16, -220)
            ..close(),
          Path()
            ..moveTo(16, -220)
            ..lineTo(24, -246)
            ..lineTo(30, -220)
            ..close(),
        ]) {
          _drawVoxelPath(canvas, prong, base, depth: 3);
          canvas.drawCircle(
            Offset(prong.getBounds().center.dx, prong.getBounds().top + 5),
            2.5,
            Paint()..color = accent,
          );
        }
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-27, -215, 27, -210),
          accent,
          radius: 1,
          depth: 1,
        );
      case 4:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-40, -208, 38, -200),
          _darken(base, .24),
          radius: 3,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-30, -230, 30, -206),
          base,
          radius: 4,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-30, -218, 30, -210),
          accent,
          radius: 1,
          depth: 1,
        );
        canvas.drawCircle(
          const Offset(0, -231),
          4,
          Paint()..color = _lighten(base, .25),
        );
        canvas.drawPath(
          Path()
            ..moveTo(-18, -216)
            ..lineTo(0, -208)
            ..lineTo(18, -216),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = accent,
        );
      case 5:
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(-32, -204)
            ..quadraticBezierTo(-34, -238, 0, -240)
            ..quadraticBezierTo(34, -238, 32, -204)
            ..close(),
          base,
          depth: 4,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-34, -214, 34, -202),
          accent,
          radius: 3,
          depth: 2,
        );
        _paintGlow(canvas, const Offset(0, -242), 10, accent, opacity: .5);
        canvas.drawCircle(const Offset(0, -242), 6, Paint()..color = accent);
        canvas.drawCircle(
          const Offset(0, -242),
          3,
          Paint()..color = _lighten(accent, .35),
        );
        for (var x = -22.0; x < 24; x += 11) {
          canvas.drawLine(
            Offset(x, -226),
            Offset(x, -214),
            Paint()
              ..color = _lighten(base, .25).withValues(alpha: .55)
              ..strokeWidth = 1.4,
          );
        }
      case 6:
        final band = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round
          ..color = base;
        canvas.drawArc(
          const Rect.fromLTRB(-38, -242, 38, -192),
          math.pi * 1.05,
          math.pi * .9,
          false,
          band,
        );
        canvas.drawArc(
          const Rect.fromLTRB(-38, -242, 38, -192),
          math.pi * 1.08,
          math.pi * .84,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5
            ..strokeCap = StrokeCap.round
            ..color = _lighten(base, .25),
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-46, -204, -33, -176),
          base,
          radius: 5,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(33, -204, 46, -176),
          base,
          radius: 5,
          depth: 3,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-44, -200, -35, -180),
          accent,
          radius: 4,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(35, -200, 44, -180),
          accent,
          radius: 4,
          depth: 1,
        );
        canvas.drawLine(
          const Offset(42, -184),
          const Offset(22, -168),
          Paint()
            ..color = _lighten(base, .22)
            ..strokeWidth = 3,
        );
        canvas.drawCircle(const Offset(21, -167), 3.5, Paint()..color = accent);
      case 7:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-30, -222, 30, -208),
          _darken(base, .1),
          radius: 3,
          depth: 3,
        );
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(-30, -220)
            ..lineTo(-48, -246)
            ..lineTo(-16, -224)
            ..close(),
          base,
          depth: 3,
        );
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(30, -220)
            ..lineTo(48, -246)
            ..lineTo(16, -224)
            ..close(),
          base,
          depth: 3,
        );
        _drawVoxelPath(
          canvas,
          Path()
            ..moveTo(-12, -220)
            ..lineTo(0, -248)
            ..lineTo(12, -220)
            ..close(),
          base,
          depth: 3,
        );
        _paintGlow(canvas, const Offset(0, -218), 18, accent, opacity: .5);
        canvas.drawCircle(const Offset(0, -218), 5, Paint()..color = accent);
        canvas.drawCircle(
          const Offset(-39, -242),
          2.5,
          Paint()..color = accent,
        );
        canvas.drawCircle(const Offset(39, -242), 2.5, Paint()..color = accent);
      case 8:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-34, -222, 34, -204),
          _darken(base, .12),
          radius: 4,
          depth: 3,
        );
        _paintGlow(canvas, const Offset(0, -213), 28, accent, opacity: .55);
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-29, -218, 29, -208),
          accent,
          radius: 3,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-38, -222, -31, -204),
          _darken(base, .2),
          radius: 2,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(31, -222, 38, -204),
          _darken(base, .2),
          radius: 2,
          depth: 1,
        );
        canvas.drawLine(
          const Offset(-20, -214),
          const Offset(20, -214),
          Paint()
            ..color = Colors.white.withValues(alpha: .7)
            ..strokeWidth = 1.5,
        );
      case 9:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-40, -208, 40, -198),
          _darken(base, .22),
          radius: 3,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-30, -248, 30, -206),
          base,
          radius: 3,
          depth: 4,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-30, -220, 30, -211),
          accent,
          radius: 1,
          depth: 1,
        );
        canvas.drawLine(
          const Offset(-26, -244),
          const Offset(-26, -212),
          Paint()
            ..color = _lighten(base, .3).withValues(alpha: .55)
            ..strokeWidth = 1.5,
        );
        _drawSparkle(canvas, const Offset(36, -236), 3.5, accent);
    }
  }

  // ── AKSESORIS DEPAN ──────────────────────────────────────
  void _paintAccessoryFront(Canvas canvas, CostumeItem item) {
    switch (item.variant) {
      case 0:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-22, -198, -4, -182),
          _darken(item.baseColor, .05),
          radius: 4,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(4, -198, 22, -182),
          _darken(item.baseColor, .05),
          radius: 4,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-20, -196, -6, -184),
          item.accentColor.withValues(alpha: .28),
          radius: 3,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(6, -196, 20, -184),
          item.accentColor.withValues(alpha: .28),
          radius: 3,
          depth: 0,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-4, -192, 4, -188),
          item.accentColor,
          radius: 1,
          depth: 1,
        );
        canvas.drawLine(
          const Offset(-22, -190),
          const Offset(-36, -194),
          Paint()
            ..color = item.accentColor
            ..strokeWidth = 2,
        );
        canvas.drawLine(
          const Offset(22, -190),
          const Offset(36, -194),
          Paint()
            ..color = item.accentColor
            ..strokeWidth = 2,
        );
      case 2:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-24, -146, -14, -82),
          item.baseColor,
          radius: 3,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(14, -146, 24, -82),
          item.baseColor,
          radius: 3,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-24, -120, -14, -114),
          item.accentColor,
          radius: 1,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(14, -120, 24, -114),
          item.accentColor,
          radius: 1,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-22, -98, -16, -92),
          item.accentColor,
          radius: 1,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(16, -98, 22, -92),
          item.accentColor,
          radius: 1,
          depth: 1,
        );
      case 4:
        _paintGlow(
          canvas,
          const Offset(0, -119),
          15,
          item.accentColor,
          opacity: .45,
        );
        final gem = Path()
          ..moveTo(0, -132)
          ..lineTo(9, -121)
          ..lineTo(0, -108)
          ..lineTo(-9, -121)
          ..close();
        _drawVoxelPath(canvas, gem, item.baseColor, depth: 3);
        canvas.drawPath(
          Path()
            ..moveTo(0, -132)
            ..lineTo(0, -108)
            ..lineTo(-9, -121)
            ..close(),
          Paint()..color = _lighten(item.baseColor, .22).withValues(alpha: .6),
        );
        canvas.drawLine(
          const Offset(0, -128),
          const Offset(0, -114),
          Paint()
            ..color = Colors.white.withValues(alpha: .75)
            ..strokeWidth = 1.2,
        );
      case 5:
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-25, -184, 25, -164),
          item.baseColor,
          radius: 5,
          depth: 2,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(-19, -178, -5, -170),
          _darken(item.baseColor, .2),
          radius: 4,
          depth: 1,
        );
        _drawBlock(
          canvas,
          const Rect.fromLTRB(5, -178, 19, -170),
          _darken(item.baseColor, .2),
          radius: 4,
          depth: 1,
        );
        canvas.drawCircle(
          const Offset(-12, -174),
          3,
          Paint()..color = item.accentColor,
        );
        canvas.drawCircle(
          const Offset(12, -174),
          3,
          Paint()..color = item.accentColor,
        );
        canvas.drawLine(
          const Offset(-25, -176),
          const Offset(-37, -180),
          Paint()
            ..color = item.accentColor.withValues(alpha: .75)
            ..strokeWidth = 2,
        );
        canvas.drawLine(
          const Offset(25, -176),
          const Offset(37, -180),
          Paint()
            ..color = item.accentColor.withValues(alpha: .75)
            ..strokeWidth = 2,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _ShopAvatarPainter oldDelegate) {
    if (oldDelegate.equipped.length != equipped.length) return true;
    for (final category in CostumeCategory.values) {
      if (oldDelegate.equipped[category]?.id != equipped[category]?.id) {
        return true;
      }
    }
    return false;
  }
}
