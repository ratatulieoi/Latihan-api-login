# Laporan Singkat Arsitektur Aplikasi

## Judul
Form Login Flutter Menggunakan Token dari API dengan Arsitektur Provider, Repository, dan Service

## Ringkasan
Aplikasi ini dibuat untuk memenuhi tugas **membuat form login menggunakan token dari API**. Aplikasi menggunakan Flutter dan menerapkan pemisahan tanggung jawab agar kode lebih rapi, mudah dipahami, dan mudah dikembangkan. Arsitektur yang digunakan adalah **provider + repository + service**.

Aplikasi melakukan login ke API `https://dummyjson.com/auth/login`, mengambil token dari response, lalu menyimpan session secara lokal agar user tetap dalam keadaan login sampai melakukan logout.

---

## Penjelasan Arsitektur

### 1. Provider
Provider bertugas mengatur **state** atau kondisi aplikasi yang berhubungan dengan tampilan.

Pada project ini, provider yang digunakan adalah:
- `AuthProvider`

Tugas utama `AuthProvider`:
- Menyimpan status loading
- Menyimpan data session user yang sedang login
- Menyimpan pesan error ketika login gagal
- Menjalankan proses login melalui repository
- Menjalankan proses logout
- Mengatur apakah user sudah login atau belum

Dengan adanya provider, widget tidak perlu langsung mengelola logika login yang rumit. UI cukup membaca state dari provider menggunakan `context.watch()` atau memanggil aksi menggunakan `context.read()`.

**File terkait:**
- `lib/presentation/providers/auth_provider.dart`

---

### 2. Repository
Repository bertugas menjadi **penghubung antara provider dengan sumber data**.

Pada project ini, repository yang digunakan adalah:
- `AuthRepository`
- `AuthRepositoryImpl`

Tugas utama repository:
- Menerima permintaan login dari provider
- Memanggil service untuk menghubungi API
- Menyimpan hasil session ke local storage
- Mengambil session yang sudah tersimpan saat aplikasi dibuka kembali
- Menghapus session saat logout

Repository membuat provider tidak perlu tahu detail bagaimana API dipanggil atau bagaimana data disimpan. Dengan begitu, struktur kode menjadi lebih bersih dan mudah diuji.

**File terkait:**
- `lib/data/repositories/auth_repository.dart`

---

### 3. Service
Service bertugas menangani **komunikasi langsung dengan API**.

Pada project ini, service yang digunakan adalah:
- `AuthService`
- `DummyJsonAuthService`

Tugas utama service:
- Mengirim request HTTP `POST` ke endpoint login
- Mengirim data `username` dan `password` dalam format JSON
- Membaca response dari server
- Mengubah response menjadi model `AuthSession`
- Menangani error dari server atau masalah koneksi

Service dibuat terpisah agar detail request API tidak bercampur dengan logika tampilan maupun state management.

**File terkait:**
- `lib/data/services/auth_service.dart`

---

## Alur Login Aplikasi

Berikut alur kerja login pada aplikasi:

1. User mengisi username dan password pada halaman login.
2. Tombol login memanggil fungsi login di `AuthProvider`.
3. `AuthProvider` memvalidasi input dan mengubah state menjadi loading.
4. `AuthProvider` memanggil `AuthRepository`.
5. `AuthRepository` memanggil `AuthService` untuk mengirim request ke API.
6. API mengembalikan token login.
7. `AuthService` mengubah response menjadi model `AuthSession`.
8. `AuthRepository` menyimpan session ke local storage.
9. `AuthProvider` memperbarui state menjadi authenticated.
10. UI menampilkan halaman session aktif beserta token yang diterima.

---

## Penyimpanan Session

Aplikasi menggunakan `shared_preferences` untuk menyimpan session secara lokal. Data yang disimpan meliputi:
- access token
- refresh token
- username
- informasi user lain jika tersedia

Saat aplikasi dibuka kembali, provider akan memeriksa apakah session masih tersimpan. Jika ada, user langsung masuk ke halaman session aktif tanpa perlu login ulang.

**File terkait:**
- `lib/data/storage/session_storage.dart`

---

## Keuntungan Menggunakan Arsitektur Ini

Beberapa keuntungan dari penggunaan provider + repository + service:

1. **Kode lebih rapi**
   - Setiap layer memiliki tugas masing-masing.

2. **Mudah dipahami**
   - Logika UI, penyimpanan data, dan komunikasi API dipisahkan dengan jelas.

3. **Mudah dikembangkan**
   - Jika nanti API diganti, perubahan cukup dilakukan di service atau repository.

4. **Mudah diuji**
   - Provider, repository, dan service bisa diuji secara terpisah.

5. **Sesuai untuk project skala kecil sampai menengah**
   - Arsitektur ini cukup sederhana untuk tugas kuliah, tetapi tetap baik secara struktur.

---

## Kesimpulan

Aplikasi ini berhasil menerapkan login menggunakan token dari API nyata dengan struktur **provider + repository + service**. Provider digunakan untuk mengatur state tampilan, repository sebagai penghubung data, dan service untuk komunikasi dengan API.

Dengan pemisahan ini, aplikasi menjadi lebih terstruktur, mudah dijelaskan, dan sesuai dengan kebutuhan penilaian tugas yang menekankan fitur berjalan, arsitektur, UI, dan kualitas kode.
