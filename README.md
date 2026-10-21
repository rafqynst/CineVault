CineVault
Your Offline Cinema --- pemutar video lokal Android yang dirancang
untuk menikmati koleksi video langsung dari penyimpanan perangkat, tanpa
perlu koneksi internet untuk memutar video.
Tentang CineVault
CineVault adalah aplikasi pemutar video berbasis Flutter untuk Android.
Aplikasi memindai video yang tersedia di perangkat, menampilkan
informasi video, dan menyediakan kontrol pemutaran dengan tampilan
minimalis agar nyaman digunakan.
Fitur
- Pemindaian video lokal dari penyimpanan perangkat.
- Daftar video dengan thumbnail, durasi, ukuran file, dan resolusi
  jika tersedia.
- Filter durasi: video berdurasi kurang dari 5 menit tidak
  ditampilkan dalam daftar film.
- Pencarian video berdasarkan nama.
- Pemutar video layar penuh dengan kontrol pemutaran.
- Kontrol yang menghilang otomatis agar layar lebih bersih saat
  menonton.
- Gesture pemutar untuk navigasi waktu, serta pengaturan volume
  dan kecerahan.
- Lanjutkan pemutaran dari posisi terakhir video yang diputar.
- Terakhir diputar (Last Played) untuk membuka kembali video
  terbaru.
- Favorit untuk menyimpan video pilihan.
- Tarik untuk menyegarkan (pull to refresh) daftar video.
- Penyimpanan lokal untuk data fitur tertentu; tidak memerlukan
  akun.
Ketersediaan gesture tertentu dapat bergantung pada versi aplikasi
yang sedang dibangun. Lihat bagian penggunaan pemutar untuk ringkasan
kontrol yang disediakan aplikasi.

Cara Menggunakan
1. Menjalankan aplikasi pertama kali
1. Instal dan buka CineVault.
2. Berikan izin akses video/media ketika Android memintanya.
3. Tunggu proses pemindaian selesai.
4. Video yang memenuhi filter durasi akan muncul pada halaman utama.
Jika daftar video kosong, periksa apakah perangkat memiliki file video
lokal dan apakah izin media sudah diberikan. Setelah menambahkan video
baru ke perangkat, tarik daftar ke bawah untuk menyegarkan pemindaian.
2. Membuka dan memutar video
1. Pada halaman utama, cari video yang ingin ditonton.
2. Ketuk kartu video untuk membuka pemutar.
3. Ketuk layar untuk menampilkan kontrol pemutar jika kontrol sedang
   tersembunyi.
4. Gunakan tombol putar/jeda dan bilah progres untuk mengontrol
   pemutaran.
5. Keluar dari pemutar menggunakan tombol kembali perangkat setelah
   selesai.
3. Kontrol pemutar video
  Kontrol                             Cara menggunakan
  Putar / Jeda                        Ketuk tombol putar atau jeda pada
                                      kontrol pemutar.

  Tampilkan kontrol                   Ketuk layar ketika kontrol
                                      tersembunyi.

  Sembunyikan kontrol                 Tunggu sampai kontrol menghilang
                                      otomatis, atau ketuk layar sesuai
                                      perilaku versi aplikasi.

  Pindah posisi video                 Geser/ketuk bilah progres ke posisi
                                      yang diinginkan.

  Lewati sekitar 10 detik             Ketuk dua kali area sisi kiri atau
                                      kanan video untuk mundur atau maju.

  Atur volume                         Gunakan gesture geser vertikal pada
                                      area pemutar yang ditetapkan untuk
                                      volume.

  Atur kecerahan                      Gunakan gesture geser vertikal pada
                                      area pemutar yang ditetapkan untuk
                                      kecerahan.

  Layar penuh                         Pemutar menggunakan tampilan layar
                                      penuh; orientasi dapat berubah
                                  mengikuti perilaku pemutar.
Catatan gesture: arah dan area geser untuk volume/kecerahan, serta
dukungan gesture tambahan seperti pinch-to-zoom atau tekan lama untuk
mempercepat, mengikuti implementasi versi aplikasi yang terpasang. Jika
gesture tidak merespons, gunakan kontrol yang terlihat di layar.
4. Melanjutkan video terakhir
1. Kembali ke halaman utama setelah memutar video.
2. Temukan bagian Last Played / Terakhir Diputar.
3. Ketuk video tersebut untuk membukanya kembali.
4. Jika posisi terakhir tersimpan, pemutaran dapat dilanjutkan dari
   posisi sebelumnya.
5. Mengelola favorit
1. Buka video dari halaman utama.
2. Gunakan kontrol favorit/bookmark yang tersedia pada versi aplikasi.
3. Buka daftar favorit melalui tombol bookmark di bagian header halaman
   utama.
4. Pilih video favorit untuk memutarnya kembali.
6. Mencari dan memperbarui daftar video
- Gunakan kolom pencarian untuk menemukan video berdasarkan nama.
- Tarik daftar video ke bawah untuk menjalankan penyegaran.
- Video pendek di bawah 5 menit tidak ditampilkan pada daftar utama
  sesuai aturan filter aplikasi.
Teknologi yang Digunakan
- Flutter & Dart --- pengembangan aplikasi.
- Provider --- pengelolaan state.
- photo_manager --- akses dan pemindaian media lokal.
- video_player --- pemutaran video.
- video_thumbnail --- pembuatan thumbnail video.
- sqflite --- penyimpanan data lokal.
- permission_handler --- dukungan pengelolaan izin.
- path_provider dan path --- pengelolaan lokasi/path file.
- wakelock_plus --- menjaga layar tetap aktif saat diperlukan
  selama pemutaran.
- screen_brightness --- pengaturan kecerahan layar.
- google_fonts --- tipografi aplikasi.
- intl --- pemformatan data.