# Dokumentasi TypingMaster

Dokumentasi ini menjelaskan arsitektur implementasi teknis untuk game TypingMaster di Godot 4.7+.

## Daftar Isi Dokumentasi

1. [Mekanisme Type Master](typing_mechanism.md)
   - Sistem deteksi huruf random A-Z
   - Hit per ketikan benar & kemunculan huruf berurutan
   - Konsekuensi salah ketik (damage pada Player & serangan balasan musuh)
2. [Desain UI & Font](ui_and_fonts.md)
   - Keycap button berbentuk kotak rounded di atas kepala Player menggunakan `TYPE_FONTS.ttf`
   - Banner dialog tutorial kotak hitam dengan teks putih menggunakan `DIALOG_FONTS.ttf`
3. [Musuh Slime](slime.md)
   - Karakter musuh Slime berbasis `AnimatedSprite2D`
   - Animasi `green_idle` dan respon `green_attack` saat pemain salah ketik
4. [Dool Combat & Breaking Interaction](dool_combat.md)
   - Karakter target boneka (`Dool` / `AnimatedSprite2D`)
   - Deteksi otomatis saat Player mendekati Dool
   - Mekanisme 2x hit untuk breaking
   - Jeda 2 detik setelah animasi breaking selesai sebelum Dool hilang dan Player kembali jalan
5. [Player Mechanics & RigidBody Interaction](player.md)
   - Karakter berbasis `CharacterBody2D`
   - Sinkronisasi pergerakan otomatis ke kanan mengikuti kamera
   - Penanganan gravitasi, loncat, dan animasi
   - Interaksi fisik dengan seluruh node `RigidBody2D` (mendorong & bertengger)
6. [Autoscroll Camera Controller](camera.md)
   - Kamera berbasis `Camera2D` yang bergerak kontinu ke arah kanan
   - Pengaturan kecepatan scroll, pause saat pertarungan, dan framing tampilan
7. [Infinite Background & Looping Floor](background_loop.md)
   - Sistem loop background visual dan CollisionShape2D lantai tanpa jeda
   - Penggunaan segment-wrapping untuk performa optimal dan zero garbage collection
8. [RigidBody2D & Physics Props](rigid_bodies.md)
   - Pembuatan dan integrasi objek `RigidBody2D`
   - Respon tumbukan dan transfer gaya dari Player

## Struktur Proyek

```text
TypingMaster/
├── assets/
│   ├── background/
│   │   ├── background_1.jpg
│   │   └── shop_1.png
│   ├── character/
│   │   ├── BLUE_SAMURAI/
│   │   └── RED_SAMURAI/
│   ├── enemy/
│   │   ├── breaking-dool.png
│   │   ├── dool-hit.png
│   │   └── slime.png
│   └── fonts/
│       ├── DIALOG_FONTS.ttf
│       └── TYPE_FONTS.ttf
├── docs/
│   ├── README.md
│   ├── typing_mechanism.md
│   ├── ui_and_fonts.md
│   ├── slime.md
│   ├── dool_combat.md
│   ├── player.md
│   ├── camera.md
│   ├── background_loop.md
│   └── rigid_bodies.md
├── scenes/
│   ├── background_segment.tscn
│   └── rigid_box.tscn
├── scripts/
│   ├── background_loop.gd
│   ├── camera_controller.gd
│   ├── dool.gd
│   ├── keycap_prompt.gd
│   ├── player.gd
│   ├── slime.gd
│   └── tutorial_banner.gd
├── main.tscn
├── project.godot
└── TUTOR.md
```

## Menjalankan Proyek

Buka proyek menggunakan Godot Engine versi 4.7 atau lebih baru:
```bash
godot --path .
```
Atau jalankan secara headless untuk validasi:
```bash
godot --headless --quit-after 60
```
