# Klinik APP

Aplikasi Flutter sederhana untuk melihat dan mengelola data poli, pegawai, dan pasien klinik. Proyek ini dibuat sebagai latihan navigasi halaman, widget daftar, serta form tambah dan ubah.

## Fitur

- Menu utama untuk membuka Data Poli, Data Pegawai, dan Data Pasien.
- Daftar item membuka halaman detail masing-masing.
- Form tambah dan ubah untuk Poli, Pegawai, dan Pasien.
- Field password Pegawai disamarkan saat diisi dan tidak ditampilkan pada halaman detail.

## Teknologi

- Flutter dan Dart
- Material Design
- Tidak menggunakan backend atau database.

## Menjalankan aplikasi

Pastikan Flutter terpasang dengan Dart SDK yang memenuhi batas di `pubspec.yaml` (`^3.13.4`). Dari folder proyek, jalankan:

```bash
flutter pub get
flutter run
```

Untuk menjalankan pada perangkat atau target tertentu, misalnya:

```bash
flutter run -d windows
flutter run -d chrome
```

## Pemeriksaan

```bash
flutter analyze
flutter test
```

## Struktur folder

```text
lib/
├── main.dart
├── model/       # Model Poli, Pegawai, dan Pasien
└── ui/          # Halaman daftar, item, detail, serta form
test/            # Widget test
```

## Catatan

Data contoh pada daftar masih ditulis langsung di aplikasi. Data yang ditambahkan atau diubah belum disimpan ke database, sehingga belum permanen dan data baru belum masuk ke daftar setelah kembali dari halaman detail.
