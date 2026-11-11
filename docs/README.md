# Dokumentasi TypingMaster

Dokumentasi ini menjelaskan arsitektur implementasi teknis untuk game TypingMaster di Godot 4.7+.

## Daftar Isi Dokumentasi

1. [Player Mechanics & RigidBody Interaction](player.md)
   - Karakter berbasis `CharacterBody2D`
   - Sinkronisasi pergerakan otomatis ke kanan mengikuti kamera
   - Penanganan gravitasi, loncat, dan animasi
   - Interaksi fisik dengan seluruh node `RigidBody2D` (mendorong & bertengger)
2. [Dool Combat & Breaking Interaction](dool_combat.md)
   - Karakter target boneka (`Dool` / `AnimatedSprite2D`)
   - Deteksi otomatis saat Player mendekati Dool
   - Mekanisme 2x hit untuk breaking
   - Jeda 2 detik setelah animasi breaking selesai sebelum Dool hilang dan Player kembali jalan
3. [Autoscroll Camera Controller](camera.md)
   - Kamera berbasis `Camera2D` yang bergerak kontinu ke arah kanan
   - Pengaturan kecepatan scroll, pause saat pertarungan, dan framing tampilan
4. [Infinite Background & Looping Floor](background_loop.md)
   - Sistem loop background visual dan CollisionShape2D lantai tanpa jeda
   - Penggunaan segment-wrapping untuk performa optimal dan zero garbage collection
5. [RigidBody2D & Physics Props](rigid_bodies.md)
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
│   └── enemy/
│       ├── breaking-dool.png
│       └── dool-hit.png
├── docs/
│   ├── README.md
│   ├── player.md
│   ├── dool_combat.md
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
│   └── player.gd
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
