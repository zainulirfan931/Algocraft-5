"""Membuat diagram pendukung laporan (use case, aktivitas, arsitektur)."""
import os
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, Ellipse, Polygon, FancyArrowPatch, Rectangle, Circle
from matplotlib.lines import Line2D

OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "docs", "laporan", "img")
os.makedirs(OUT, exist_ok=True)

NAVY = "#1F3864"
BLUE = "#2E75B6"
LIGHT = "#DEEAF6"
LIGHT2 = "#E2EFDA"
ORANGE = "#F4B183"
GREY = "#595959"


def box(ax, x, y, w, h, text, fc=LIGHT, ec=BLUE, fs=11, bold=False, rounded=True):
    if rounded:
        patch = FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0.012,rounding_size=0.02",
                               linewidth=1.4, edgecolor=ec, facecolor=fc)
    else:
        patch = Rectangle((x, y), w, h, linewidth=1.4, edgecolor=ec, facecolor=fc)
    ax.add_patch(patch)
    ax.text(x + w / 2, y + h / 2, text, ha="center", va="center", fontsize=fs,
            color="#1a1a1a", fontweight="bold" if bold else "normal", wrap=True)
    return patch


def arrow(ax, x1, y1, x2, y2, color=NAVY, style="-|>", lw=1.3, ls="-"):
    ax.add_patch(FancyArrowPatch((x1, y1), (x2, y2), arrowstyle=style, mutation_scale=14,
                                 linewidth=lw, color=color, linestyle=ls,
                                 shrinkA=2, shrinkB=2))


def use_case():
    fig, ax = plt.subplots(figsize=(11, 6.8), dpi=200)
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis("off")

    # Aktor
    ax.add_patch(Circle((0.085, 0.58), 0.022, fill=False, lw=1.8, color=NAVY))
    ax.add_line(Line2D([0.085, 0.085], [0.558, 0.47], color=NAVY, lw=1.8))
    ax.add_line(Line2D([0.055, 0.115], [0.53, 0.53], color=NAVY, lw=1.8))
    ax.add_line(Line2D([0.085, 0.058], [0.47, 0.40], color=NAVY, lw=1.8))
    ax.add_line(Line2D([0.085, 0.112], [0.47, 0.40], color=NAVY, lw=1.8))
    ax.text(0.085, 0.345, "Pemain", ha="center", va="center", fontsize=12, fontweight="bold", color=NAVY)

    # Batas sistem
    ax.add_patch(Rectangle((0.22, 0.10), 0.72, 0.82, fill=False, lw=1.6, color=NAVY))
    ax.text(0.58, 0.885, "Sistem Aplikasi AlgoCraft", ha="center", va="center", fontsize=12,
            fontweight="bold", color=NAVY)

    cases = [
        (0.28, 0.70, "Melihat beranda dan\nprogres belajar"),
        (0.60, 0.70, "Membuka peta level\ndan memilih misi"),
        (0.28, 0.49, "Menyusun blok\nperintah"),
        (0.60, 0.49, "Menjalankan misi\n(animasi eksekusi)"),
        (0.28, 0.28, "Membeli dan memakai\nkostum robot"),
        (0.60, 0.28, "Mengatur musik,\nefek suara, dan volume"),
    ]
    centers = []
    for x, y, text in cases:
        ax.add_patch(Ellipse((x + 0.14, y), 0.26, 0.145, facecolor=LIGHT, edgecolor=BLUE, lw=1.3))
        ax.text(x + 0.14, y, text, ha="center", va="center", fontsize=9.4, color="#1a1a1a")
        centers.append((x + 0.14, y))

    for cx, cy in centers:
        arrow(ax, 0.115, 0.53, cx - 0.13, cy, color=GREY, lw=1.0)

    # Relasi include
    arrow(ax, 0.44, 0.68, 0.47, 0.56, color=BLUE, ls="--", lw=1.0)
    arrow(ax, 0.72, 0.68, 0.69, 0.56, color=BLUE, ls="--", lw=1.0)
    ax.text(0.465, 0.625, "<<include>>", fontsize=7.5, color=BLUE, rotation=70)
    ax.text(0.705, 0.625, "<<include>>", fontsize=7.5, color=BLUE, rotation=-70)

    fig.tight_layout()
    path = os.path.join(OUT, "diagram-use-case.png")
    fig.savefig(path, bbox_inches="tight", facecolor="white")
    plt.close(fig)
    return path


def activity():
    fig, ax = plt.subplots(figsize=(7.4, 10.4), dpi=200)
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis("off")

    # mulai
    ax.add_patch(Ellipse((0.5, 0.965), 0.20, 0.035, facecolor=NAVY, edgecolor=NAVY))
    ax.text(0.5, 0.965, "Mulai", ha="center", va="center", fontsize=10.5, color="white", fontweight="bold")

    box(ax, 0.27, 0.885, 0.46, 0.050, "Pemain membuka aplikasi AlgoCraft", fs=9.6)
    box(ax, 0.27, 0.805, 0.46, 0.050, "Pilih level pada Peta Level", fs=9.6)
    box(ax, 0.27, 0.725, 0.46, 0.050, "Susun blok perintah pada palet", fs=9.6)
    box(ax, 0.27, 0.645, 0.46, 0.050, "Tekan tombol Jalankan", fs=9.6)
    box(ax, 0.27, 0.565, 0.46, 0.050, "Mesin mengeksekusi blok\nsecara berurutan", fs=9.4)

    # decision
    diamond = Polygon([[0.5, 0.505], [0.68, 0.445], [0.5, 0.385], [0.32, 0.445]],
                      closed=True, facecolor="#FFF2CC", edgecolor="#BF9000", lw=1.4)
    ax.add_patch(diamond)
    ax.text(0.5, 0.445, "Misi\nberhasil?", ha="center", va="center", fontsize=9.4, fontweight="bold")

    box(ax, 0.27, 0.295, 0.46, 0.050, "Hitung bintang berdasarkan\nefisiensi jumlah blok", fs=9.4)
    box(ax, 0.27, 0.215, 0.46, 0.050, "Simpan bintang, XP, dan koin\nke penyimpanan lokal", fs=9.4)
    box(ax, 0.27, 0.135, 0.46, 0.050, "Tampilkan layar hasil misi", fs=9.6)

    # selesai
    ax.add_patch(Ellipse((0.5, 0.055), 0.20, 0.035, facecolor=NAVY, edgecolor=NAVY))
    ax.text(0.5, 0.055, "Selesai", ha="center", va="center", fontsize=10.5, color="white", fontweight="bold")

    # alur utama
    for y1, y2 in [(0.948, 0.938), (0.885, 0.858), (0.805, 0.778), (0.725, 0.698),
                   (0.645, 0.618), (0.565, 0.508), (0.385, 0.348), (0.295, 0.268),
                   (0.215, 0.188), (0.135, 0.075)]:
        arrow(ax, 0.5, y1, 0.5, y2)

    ax.text(0.515, 0.525, "Ya", fontsize=9, color=GREY)
    # tidak -> atur ulang
    box(ax, 0.78, 0.410, 0.19, 0.070, "Atur ulang\ndan perbaiki\nprogram", fc="#FCE4D6", ec="#C55A11", fs=8.8)
    arrow(ax, 0.68, 0.445, 0.78, 0.445, color=GREY)
    ax.text(0.705, 0.458, "Tidak", fontsize=8.8, color=GREY)
    ax.add_patch(FancyArrowPatch((0.875, 0.480), (0.875, 0.750), arrowstyle="-", lw=1.1, color=GREY))
    ax.add_patch(FancyArrowPatch((0.875, 0.750), (0.735, 0.750), arrowstyle="-|>", mutation_scale=14,
                                 lw=1.1, color=GREY))

    fig.tight_layout()
    path = os.path.join(OUT, "diagram-aktivitas.png")
    fig.savefig(path, bbox_inches="tight", facecolor="white")
    plt.close(fig)
    return path


def architecture():
    fig, ax = plt.subplots(figsize=(11.4, 6.6), dpi=200)
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis("off")

    layers = [
        (0.795, "Lapisan Presentasi (UI)", "#DDEBF7",
         ["Beranda", "Peta Level", "Arena Misi", "Hasil Misi", "Toko Kostum"]),
        (0.575, "Lapisan Logika Permainan", "#E2EFDA",
         ["Model MissionLevel", "Mesin eksekusi blok", "Aturan menang & bintang", "Animasi CustomPaint"]),
        (0.355, "Lapisan Layanan", "#FFF2CC",
         ["GameProgress\n(bintang, XP, koin, kostum)", "GameAudio\n(BGM, SFX, preferensi)"]),
        (0.135, "Lapisan Platform & Penyimpanan", "#FCE4D6",
         ["SharedPreferences\n(JSON lokal)", "Aset gambar & audio", "Flutter Web / Android / Windows"]),
    ]

    for y, title, color, items in layers:
        ax.add_patch(FancyBboxPatch((0.04, y), 0.92, 0.145, boxstyle="round,pad=0.01,rounding_size=0.015",
                                    facecolor=color, edgecolor=NAVY, lw=1.2))
        ax.text(0.06, y + 0.118, title, fontsize=11, fontweight="bold", color=NAVY, va="center")
        n = len(items)
        for i, item in enumerate(items):
            x = 0.055 + i * (0.89 / n)
            w = (0.89 / n) - 0.015
            ax.add_patch(FancyBboxPatch((x, y + 0.018), w, 0.078,
                                        boxstyle="round,pad=0.008,rounding_size=0.012",
                                        facecolor="white", edgecolor=BLUE, lw=1.0))
            ax.text(x + w / 2, y + 0.057, item, ha="center", va="center", fontsize=8.4, color="#1a1a1a")

    # panah antar lapisan
    for y1, y2 in [(0.795, 0.727), (0.575, 0.507), (0.355, 0.287)]:
        arrow(ax, 0.5, y1, 0.5, y2, color=GREY, lw=1.4)
        arrow(ax, 0.56, y2, 0.56, y1, color=GREY, lw=1.1, ls="--")

    ax.text(0.505, 0.757, "memanggil", fontsize=7.5, color=GREY)
    ax.text(0.505, 0.537, "memakai", fontsize=7.5, color=GREY)
    ax.text(0.505, 0.317, "menyimpan / membaca", fontsize=7.5, color=GREY)
    ax.text(0.57, 0.757, "data & status", fontsize=7.2, color=GREY)
    ax.text(0.57, 0.537, "hasil", fontsize=7.2, color=GREY)
    ax.text(0.57, 0.317, "persisten", fontsize=7.2, color=GREY)

    fig.tight_layout()
    path = os.path.join(OUT, "diagram-arsitektur.png")
    fig.savefig(path, bbox_inches="tight", facecolor="white")
    plt.close(fig)
    return path


if __name__ == "__main__":
    for fn in (use_case, activity, architecture):
        print("Dibuat:", fn())
