# Dokumentasi Infinite Background & Floor Looping

Script implementasi berada pada file [`scripts/background_loop.gd`](file:///home/yohanesokta/Dokumen/TypingMaster/scripts/background_loop.gd).

## 1. Konsep & Kebutuhan

Dalam game endless side-scroller:
1. Gambar visual background harus terus berulang tanpa jeda atau celah visual (seamless).
2. Collision lantai di bawahnya (`CollisionShape2D` pada `StaticBody2D`) juga harus terus ada sepanjang perjalanan Player dan Camera agar Player tidak jatuh ke jurang.

## 2. Struktur Segment

Setiap segment (`Segment_0`, `Segment_1`, `Segment_2`) dibangun menggunakan struktur:
- `StaticBody2D` (induk segment).
  - `CollisionShape2D`: Berukuran `1196 x 102` pada posisi tengah `(598, 584)`.
  - `default_background` (`Sprite2D`): Gambar `background_1.jpg` diskalakan ke lebar `1196` pixel dan tinggi `634` pixel pada posisi tengah `(598, 318)`.
  - Dekorasi latar (seperti `ShopSprites` pada segment pertama).

Lebar satu segment (`segment_width`) adalah `1196.0` pixel.

## 3. Algoritma Looping (Segment Wrapping)

Node `Background` bertindak sebagai koordinator segment:
1. Memuat daftar semua segment anak yang bertipe `StaticBody2D`.
2. Segment awal ditata berurutan:
   - Segment 0: `X = 0` (cakupan `[0, 1196]`)
   - Segment 1: `X = 1196` (cakupan `[1196, 2392]`)
   - Segment 2: `X = 2392` (cakupan `[2392, 3588]`)
3. Menghitung tepi kiri viewport kamera pada setiap tick:
   `left_threshold = camera.global_position.x - (viewport_width * 0.5)`
4. Ketika sebuah segment sudah lewat sepenuhnya di sebelah kiri layar:
   `segment.global_position.x + segment_width < left_threshold`
   Segment tersebut langsung dipindahkan ke ujung rantai paling kanan:
   `segment.global_position.x = _get_farthest_x() + segment_width`

## 4. Keuntungan Teknis

- **Tanpa Alokasi Memori Dinamis**: Tidak ada `instantiate()` atau `queue_free()` setiap frame, mencegah lonjakan garbage collector / frame stutter.
- **Aman untuk Fisika**: Segment hanya berpindah ketika sudah 100% berada di luar pandangan kamera sebelah kiri. Karakter Player tidak pernah berdiri di atas segment yang sedang berpindah posisi.
- **Seamless**: Karena lebar collider dan lebar gambar identik (`1196.0` pixel), pertemuan antar segmen tidak memiliki celah retak (zero-gap).
