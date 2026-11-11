# Dokumentasi Mekanisme Type Master

Implementasi typing mechanism berada di [`scripts/player.gd`](file:///home/yohanesokta/Dokumen/TypingMaster/scripts/player.gd) dengan komponen visual [`scripts/keycap_prompt.gd`](file:///home/yohanesokta/Dokumen/TypingMaster/scripts/keycap_prompt.gd) dan [`scripts/tutorial_banner.gd`](file:///home/yohanesokta/Dokumen/TypingMaster/scripts/tutorial_banner.gd).

## 1. Alur Interaksi Typing

1. **Pemberhentian Karakter**:
   - Saat mendekati musuh (`Dool` atau `Slime`) dalam radius $\le 90\text{ px}$, Player otomatis berhenti (`velocity.x = 0.0`) dan kamera berhenti bergerak (`is_paused = true`).
2. **Kemunculan Huruf Acak**:
   - Sistem memilih 1 huruf acak dari alfabet `A-Z`.
   - Huruf ditampilkan di atas kepala Player menggunakan komponen **KeycapPrompt** bergaya mechanical keycap rounded.
   - Menggunakan font resmi `res://assets/fonts/TYPE_FONTS.ttf`.
3. **Tutorial Info Box**:
   - Jika musuh yang dihadapi adalah boneka tutorial (`Dool`), banner dialog hitam dengan teks putih muncul di bagian atas layar menggunakan font `res://assets/fonts/DIALOG_FONTS.ttf`.
4. **Respon Input Pemain**:
   - **Tekan Benar**:
     - Keycap membesar sesaat dan menyala hijau (`play_success()`).
     - Player melancarkan serangan pedang (`Attack`).
     - Musuh menerima 1 hit (`take_hit()`).
     - Jika musuh masih memiliki sisa hit (seperti `Dool` yang butuh 2 hit): huruf baru yang berbeda segera muncul untuk serangan berikutnya.
     - Jika musuh telah kalah:
       - Untuk `Dool`: masuk fase `breaking`, jeda 2 detik pasca animasi, menghilang, lalu Player dan kamera kembali jalan.
       - Untuk `Slime`: memutar efek kalah squish & fade out, menghilang, lalu Player dan kamera kembali jalan.
   - **Tekan Salah (Error Penalty)**:
     - Keycap bergetar horizontal dan menyala merah (`play_error()`).
     - Player menerima damage (pengurangan `health = -10`) dan berkedip merah.
     - Jika musuh adalah `Slime`, Slime membalas menyerang Player dengan animasi `green_attack`.
     - Huruf tetap aktif sehingga pemain dapat langsung mencoba menekan kembali.
