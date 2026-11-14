"""音とも！配布用アプリアイコン（1024px）を作るスクリプト。
Pillow でフラットデザインの音符（八分音符）を描く。生成物:
  - app/assets/icon/app_icon.png      （flutter_launcher_icons のソース）
"""
from PIL import Image, ImageDraw

SIZE = 1024
BG = (232, 236, 242)        # ライトグレー（シリーズ共通の落ち着いた背景色）
NOTE = (46, 58, 74)          # 音符本体（ダークネイビー）
ACCENT = (245, 158, 11)      # サブの音符（オレンジ。音楽のアクセント）
RIBBON = (70, 86, 105)       # 五線（スレート）


def rounded(im: Image.Image, radius: int) -> Image.Image:
    mask = Image.new("L", im.size, 0)
    d = ImageDraw.Draw(mask)
    d.rounded_rectangle([0, 0, SIZE - 1, SIZE - 1], radius=radius, fill=255)
    out = Image.new("RGBA", im.size, (0, 0, 0, 0))
    out.paste(im, (0, 0), mask)
    return out


def draw_note():
    im = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)

    # 背景（角丸ライトグレー）
    d.rounded_rectangle([0, 0, SIZE - 1, SIZE - 1], radius=192, fill=BG + (255,))

    # 五線（5本。中央だけ少しだけ太く）
    for i, y in enumerate((250, 330, 410, 490, 570)):
        d.line([(90, y), (SIZE - 90, y)], fill=RIBBON + (255,), width=10 if i != 2 else 14)

    # 主音符（八分音符）: 符頭（斜め楕円）+ 符幹 + 符尾
    # 符頭
    d.ellipse([180, 520, 420, 660], fill=NOTE + (255,))
    # 符幹（符頭の右端から上へ）
    d.line([(410, 560), (410, 180)], fill=NOTE + (255,), width=34)
    d.line([(378, 585), (378, 175)], fill=NOTE + (255,), width=34)
    # 符尾（右上にカーブ）
    d.arc([420, 180, 640, 380], start=90, end=250, fill=NOTE + (255,), width=34)

    # サブ音符（十六分小的な小さい音符・オレンジ）: 右下に小さく
    d.ellipse([560, 630, 720, 750], fill=ACCENT + (255,))
    d.line([(700, 650), (700, 420)], fill=ACCENT + (255,), width=22)
    d.arc([706, 420, 860, 560], start=90, end=250, fill=ACCENT + (255,), width=22)

    return im


if __name__ == "__main__":
    im = draw_note()
    im = rounded(im, 192)
    out = r"..\app\assets\icon\app_icon.png"
    im.save(out)
    print("saved:", out)
