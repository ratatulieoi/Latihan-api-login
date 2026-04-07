# Laporan Singkat Implementasi Modul 6

## Judul
Implementasi Local Storage, Caching Sederhana, dan Offline Mode Dasar pada Aplikasi Login Flutter

## Ringkasan
Project ini merupakan kelanjutan dari tugas login API pada pertemuan sebelumnya. Pada Modul 6, aplikasi yang sama dilanjutkan dengan penyimpanan session ke local storage menggunakan `shared_preferences`.

Implementasi dibuat sederhana. Fokusnya adalah menyimpan hasil login secara lokal, memulihkan session saat aplikasi dibuka kembali, dan menampilkan indikator sumber data apakah berasal dari API atau dari local storage.

---

## Fitur Modul 6 yang Sudah Sesuai

- Menyimpan session login ke local storage
- Membaca session yang tersimpan saat aplikasi dibuka kembali
- Menghapus session dari local storage saat logout
- Menampilkan sumber data session pada UI
- Menerapkan offline mode dasar karena aplikasi masih bisa memulihkan status login tanpa request ulang saat dibuka kembali

---

## Penjelasan Struktur

### 1. Provider
`AuthProvider` mengatur state utama aplikasi.

Tugas yang sekarang ditangani provider:
- menyimpan session aktif
- menyimpan status loading
- menyimpan pesan error
- melakukan inisialisasi session dari local storage
- menentukan label sumber data session

**File terkait:**
- `lib/presentation/providers/auth_provider.dart`

### 2. Repository
`AuthRepository` menjadi penghubung antara service API dan penyimpanan lokal.

Tugas repository:
- melakukan login ke API
- menyimpan session hasil login ke storage
- mengambil session yang tersimpan
- menghapus session saat logout

**File terkait:**
- `lib/data/repositories/auth_repository.dart`

### 3. Storage
`SharedPrefsSessionStorage` menangani local storage berbasis `shared_preferences`.

Tugas storage:
- menyimpan session dalam bentuk JSON string
- membaca session yang sudah tersimpan
- menghapus session lokal
- membersihkan data rusak jika format session tidak valid

**File terkait:**
- `lib/data/storage/session_storage.dart`

### 4. Service
`DummyJsonAuthService` tetap dipakai untuk mengambil data login dari API.

**File terkait:**
- `lib/data/services/auth_service.dart`

---

## Alur Kerja Modul 6

1. User login menggunakan akun dari API DummyJSON.
2. Jika login berhasil, data session disimpan ke `shared_preferences`.
3. Saat aplikasi dibuka ulang, `AuthProvider.init()` mencoba membaca session lama.
4. Jika session ditemukan, user tetap masuk tanpa login ulang.
5. UI halaman utama menampilkan apakah session berasal dari API atau local storage.
6. Saat logout, data session dihapus dari penyimpanan lokal.

---

## Bentuk Caching dan Offline Mode

Caching pada project ini dibuat sederhana, yaitu cache untuk data session login. Jadi cache belum berupa daftar post atau data API kompleks.

Offline mode juga masih dasar. Maksudnya, saat aplikasi dibuka kembali, status login tetap bisa dipulihkan dari data lokal yang sudah tersimpan. Ini cukup untuk menunjukkan konsep local storage dan offline behavior sederhana sesuai kebutuhan tugas.

---

## Hasil Implementasi

Setelah penyesuaian Modul 6:
- aplikasi tetap bisa login seperti sebelumnya
- session tersimpan lokal
- session dapat dipulihkan saat app dibuka lagi
- logout menghapus session lokal
- halaman utama menampilkan indikator sumber data session

---

## Kesimpulan

Project ini sudah disesuaikan agar cocok dengan Modul 6 secara sederhana. Intinya, aplikasi login sebelumnya sekarang memiliki local storage, caching dasar untuk session, dan offline mode minimal melalui pemulihan session dari `shared_preferences`.

Pendekatan ini sengaja dibuat sesederhana mungkin agar mudah dipahami, mudah dijelaskan, dan tetap sesuai dengan konteks tugas praktikum.
