# Dokumentasi Player (`CharacterBody2D`)

Script implementasi berada pada file [`scripts/player.gd`](file:///home/yohanesokta/Dokumen/TypingMaster/scripts/player.gd).

## 1. Pergerakan Sinkron dengan Kamera

Sesuai ketentuan, Player bergerak terus ke arah kanan mengikuti laju kamera:
- Property `speed` disinkronkan secara langsung dari `CameraController` yang aktif.
- Pada `_physics_process(delta: float)`, nilai `velocity.x` diatur sama dengan `speed`.
- Jika Player sempat terhambat oleh rintangan berat atau tertinggal mendekati batas kiri layar, Player melakukan akselerasi kompensasi tanpa memanipulasi nilai `position` secara manual. Hal ini mematuhi standar Godot Physics di mana `CharacterBody2D` hanya berpindah melalui `move_and_slide()`.

## 2. Gravitasi dan Loncat

- Gravitasi didapatkan dari engine melalui `get_gravity()` yang menghormati konfigurasi project maupun override `Area2D`.
- Ditambahkan ke vektor vertikal: `velocity += get_gravity() * delta` saat karakter sedang tidak berada di lantai (`!is_on_floor()`).
- Tombol loncat (`ui_accept` / Spasi) memberi impuls vertikal negatif `jump_velocity = -450.0` saat Player berada di atas lantai atau di atas objek RigidBody.

## 3. Interaksi dengan RigidBody2D ("Semua Rigid Body yang Ada")

Secara default, Godot menganggap `CharacterBody2D` sebagai benda kinematis dengan massa tak hingga dan tidak mentransfer gaya dorong ke `RigidBody2D`.

Untuk membuat Player berinteraksi realistis dengan semua benda fisika:
1. Setelah pemanggilan `move_and_slide()`, script mengiterasi seluruh kontak tumbukan pada frame tersebut menggunakan `get_slide_collision_count()`.
2. Setiap objek tumbukan diperiksa apakah merupakan turunan dari `RigidBody2D` menggunakan `collider is RigidBody2D`.
3. Jika ya, arah dorong dihitung dari `-collision.get_normal()` dan offset kontak dihitung dari `collision.get_position() - rigid_body.global_position`.
4. Gaya dorong diberikan ke RigidBody menggunakan `rigid_body.apply_force(push_direction * push_force, contact_offset)`.

Keunggulan metode ini:
- **Universal**: Bekerja otomatis untuk setiap node `RigidBody2D` yang diletakkan di dalam level tanpa perlu registrasi khusus.
- **Realistis**: Titik kontak kontak dihitung akurat sehingga jika Player menabrak bagian atas kotak, kotak akan berguling atau terdorong ke depan dengan torsi rotasi alami.
- **Pijakan**: Player dapat berdiri dan berlari di atas RigidBody2D dengan normal kontak ke bawah.

## 4. Animasi Karakter

Menggunakan node `PlayerSprites` (`AnimatedSprite2D`):
- Memutar animasi `&"Run"` saat Player bergerak di lantai.
- Memutar animasi `&"Idle"` jika karakter berhenti.
