# Dokumentasi Dool Combat & Breaking

Script implementasi berada pada file [`scripts/dool.gd`](file:///home/yohanesokta/Dokumen/TypingMaster/scripts/dool.gd) dan berinteraksi langsung dengan [`scripts/player.gd`](file:///home/yohanesokta/Dokumen/TypingMaster/scripts/player.gd).

## 1. Konfigurasi Node Dool

- Node: `dool` (`AnimatedSprite2D`) berada di dalam level ([`main.tscn`](file:///home/yohanesokta/Dokumen/TypingMaster/main.tscn)).
- Berada di dalam grup `&"dool"` agar dapat dideteksi secara dinamis oleh Player.
- Memiliki 3 animasi:
  1. `idle`: Animasi berdiri diam (frame awal dool).
  2. `hit`: Animasi ketika dool terkena pukulan (7 frame dari `assets/enemy/dool-hit.png`, `loop: false`, `speed: 10.0`).
  3. `breaking`: Animasi kehancuran dool (9 frame dari `assets/enemy/breaking-dool.png`, `loop: false`, `speed: 8.0`).

## 2. Alur Mekanisme Pertarungan

1. **Deteksi Kedekatan**:
   - Player mendeteksi keberadaan dool saat jarak horizontal `<= 85.0 px`.
   - Player otomatis berhenti bergerak (`velocity.x = 0.0`), mengunci status tempur (`is_combat_locked = true`), dan menghentikan laju kamera sementara (`camera_controller.is_paused = true`).

2. **Hit Pertama (Hit 1)**:
   - Player memutar animasi `Attack`.
   - Pada saat tebasan mendarat, fungsi `dool.take_hit()` dipanggil.
   - Variabel `hits` bertambah menjadi 1.
   - Dool memutar animasi `hit`. Setelah selesai, dool kembali ke animasi `idle`.

3. **Hit Kedua (Hit 2 - Breaking)**:
   - Player melakukan tebasan kedua dengan animasi `Attack`.
   - `dool.take_hit()` dipanggil kembali sehingga `hits` menjadi 2 (`max_hits`).
   - Karena mencapai 2 hit, status `is_breaking` menjadi `true`.
   - Dool memutar animasi `breaking`.

4. **Jeda 2 Detik & Menghilang**:
   - Dool membiarkan animasi `breaking` berjalan sampai frame terakhir (`await animation_finished`).
   - Timer 2 detik dijalankan (`await get_tree().create_timer(2.0).timeout`).
   - Setelah 2 detik, sinyal `vanished` dipancarkan dan dool menghapus dirinya dari scene (`queue_free()`).

5. **Player & Kamera Melanjutkan Perjalanan**:
   - Player yang menunggu sinyal `vanished` langsung membuka kunci tempur (`is_combat_locked = false`).
   - Kamera melanjutkan autoscroll ke kanan (`camera_controller.is_paused = false`).
   - Player kembali berlari ke arah kanan (`velocity.x = speed`, animasi `Run`).
