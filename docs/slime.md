# Dokumentasi Musuh Slime (`AnimatedSprite2D`)

Script implementasi berada pada file [`scripts/slime.gd`](file:///home/yohanesokta/Dokumen/TypingMaster/scripts/slime.gd).

## 1. Konfigurasi Node

- Terpasang pada node `Slime` di scene [`main.tscn`](file:///home/yohanesokta/Dokumen/TypingMaster/main.tscn).
- Memiliki grup node `&"slime"`.
- Menggunakan spritesheet `res://assets/enemy/slime.png`:
  - `green_idle`: Animasi diam melompat kecil (8 frame, `speed: 10.0`, `loop: true`).
  - `green_attack`: Animasi menyerang (6 frame, `speed: 10.0`, `loop: false`).

## 2. Parameter & Respon

- `@export var max_hits: int = 2`: Membutuhkan 2 hit ketikan yang benar untuk dikalahkan.
- **`take_hit()`**:
  - Menambah hit, memicu kedipan merah impact.
  - Saat `hits >= max_hits`, Slime memicu efek kekalahan (squash vertikal dan fade out `modulate.a` ke 0.0), lalu memancarkan sinyal `vanished` dan memanggil `queue_free()`.
- **`attack_player()`**:
  - Dipanggil saat pemain salah menekan huruf di depan Slime.
  - Memutar animasi `green_attack`, lalu otomatis kembali ke `green_idle` saat animasi selesai.
