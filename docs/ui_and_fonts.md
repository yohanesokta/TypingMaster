# Dokumentasi UI & Font

Komponen UI dibangun sesuai instruksi visual pada [`TUTOR.md`](file:///home/yohanesokta/Dokumen/TypingMaster/TUTOR.md).

## 1. Keycap Prompt (`KeycapPrompt`)

Script: [`scripts/keycap_prompt.gd`](file:///home/yohanesokta/Dokumen/TypingMaster/scripts/keycap_prompt.gd)

- **Desain**:
  - Berbentuk kotak rounded menyerupai tombol keyboard mechanical (`StyleBoxFlat` dengan `corner_radius_all = 10`).
  - Efek bevel 3D dengan border bawah setebal 6px yang lebih gelap (`border_width_bottom = 6`) dan drop shadow (`shadow_size = 4`).
- **Posisi**:
  - Melayang di atas kepala Player pada koordinat lokal `Vector2(-28, -195)` (dapat diatur lewat `@export var keycap_offset`) sehingga tidak menutupi wajah atau helm karakter.
- **Font**:
  - Menggunakan font resmi **`res://assets/fonts/TYPE_FONTS.ttf`** dengan ukuran 28pt berwarna putih.
- **Efek Interaktif**:
  - `play_success()`: Animasi zoom cepat dengan warna hijau saat tombol benar ditekan.
  - `play_error()`: Animasi getar ke kiri-kanan dan warna merah saat tombol salah ditekan.

## 2. Tutorial Banner (`TutorialBanner`)

Script: [`scripts/tutorial_banner.gd`](file:///home/yohanesokta/Dokumen/TypingMaster/scripts/tutorial_banner.gd)

- **Desain**:
  - Kotak hitam dengan sudut melengkung dan garis tepi putih halus (`bg_color = Color(0.05, 0.05, 0.08, 0.92)`).
  - Berada di layer UI teratas (`CanvasLayer` layer 10) dengan anchor di bagian atas tengah layar.
- **Font**:
  - Menggunakan font resmi **`res://assets/fonts/DIALOG_FONTS.ttf`** dengan ukuran 20pt berwarna putih.
- **Teks Tutorial**:
  - Memberikan petunjuk bertahap saat Player menghadapi boneka tutorial `Dool`.
  - Otomatis melakukan fade out halus setelah boneka berhasil dihancurkan.
