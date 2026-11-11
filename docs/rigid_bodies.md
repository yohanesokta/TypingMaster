# Dokumentasi RigidBody2D & Physics Props

Scene template berada pada file [`scenes/rigid_box.tscn`](file:///home/yohanesokta/Dokumen/TypingMaster/scenes/rigid_box.tscn).

## 1. Konfigurasi Objek RigidBody2D

Contoh objek fisika yang disediakan menggunakan struktur standar Godot:
- `RigidBody2D`:
  - `mass`: `1.0`
  - `physics_material_override`: `PhysicsMaterial` dengan `friction = 0.5` dan `bounce = 0.2`
  - `contact_monitor`: `true`
  - `max_contacts_reported`: `4`
- `CollisionShape2D`:
  - `shape`: `RectangleShape2D` ukuran `50 x 50`
- `Sprite2D`:
  - Visual prop (menggunakan `icon.svg` berskala pas dengan ukuran collider)

## 2. Cara Kerja Interaksi dengan Player

Ketika Player menabrak objek `RigidBody2D`:
1. Player (`CharacterBody2D`) mendeteksi tumbukan pada `get_slide_collision()`.
2. Vektor normal tumbukan dibalik (`-collision.get_normal()`) untuk menentukan arah dorongan.
3. Gaya dorong diterapkan pada posisi kontak (`contact_offset`) melalui fungsi bawaan Godot:
   `rigid_body.apply_force(push_direction * push_force, contact_offset)`
4. Objek fisika menerima gaya tersebut dan bergerak menggelinding, bergeser, atau terdorong ke depan sesuai hukum fisika 2D engine Godot.

## 3. Menambahkan Objek RigidBody2D Baru

Setiap node `RigidBody2D` baru yang ditambahkan ke level (atau di-spawn saat runtime) akan langsung bekerja secara otomatis dengan Player:
1. Pastikan objek memiliki node induk bertipe `RigidBody2D` (atau turunannya).
2. Berikan `CollisionShape2D` dengan bentuk yang sesuai.
3. Masukkan ke dalam pohon scene. Player akan otomatis mendeteksi dan dapat mendorong serta memanjat objek tersebut.
