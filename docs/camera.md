# Dokumentasi Camera Controller (`Camera2D`)

Script implementasi berada pada file [`scripts/camera_controller.gd`](file:///home/yohanesokta/Dokumen/TypingMaster/scripts/camera_controller.gd).

## 1. Peran dan Fungsi

Node `CameraController` bertanggung jawab mengatur scroll horizontal dunia game secara konstan ke arah kanan.

## 2. Implementasi

- Diturunkan dari kelas `Camera2D`.
- Memiliki export variable:
  - `speed: float = 200.0`: Kecepatan scroll kamera dalam pixel per detik.
- Pada setiap tick fisika (`_physics_process(delta: float)`):
  ```gdscript
  global_position.x += speed * delta
  ```

## 3. Penataan Viewport

- Posisi awal kamera disetel pada `Vector2(576, 324)` yang merupakan titik tengah dari viewport default berukuran `1152 x 648`.
- Pengaturan anchor kamera menggunakan mode default drag center, sehingga area pandang vertikal mengcover dari `Y = 0` hingga `Y = 648`.
- Hal ini menempatkan lantai di `Y = 533..584` berada di bagian bawah layar secara presisi.
