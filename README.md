# AHMAD QOMARUL ARIFIN
# Event Registration App (Flutter)
## Deskripsi Project

Event Registration App adalah sebuah aplikasi mobile sederhana yang dibuat menggunakan Flutter dengan bahasa pemrograman Dart. Aplikasi ini dirancang untuk mensimulasikan proses pendaftaran peserta pada suatu event secara digital melalui sebuah form registrasi yang interaktif dan mudah digunakan. Pada aplikasi ini, pengguna dapat mengisi berbagai data yang diperlukan untuk melakukan pendaftaran event seperti nama lengkap, email, password, jenis kelamin, program studi, serta tanggal lahir. Setelah proses registrasi selesai dilakukan, data tersebut akan disimpan di dalam aplikasi dan dapat ditampilkan pada halaman daftar peserta. Selain fitur pendaftaran, aplikasi ini juga menyediakan fitur tambahan seperti melihat daftar peserta, melihat detail peserta, mengedit data peserta, menghapus data peserta, melakukan pencarian data peserta, serta memfilter data peserta berdasarkan program studi. Project ini dibuat sebagai bagian dari tugas praktikum Flutter dengan tujuan untuk mempraktikkan berbagai konsep dasar dalam pengembangan aplikasi mobile menggunakan Flutter seperti:
penggunaan form input, validasi data, state management, navigasi antar halaman, pengelolaan data dalam aplikasi.

## Fitur Aplikasi

Berikut adalah fitur-fitur utama yang tersedia dalam aplikasi ini:
- Form registrasi peserta
- Validasi form secara real-time
- Multi-step form menggunakan Stepper
- Penyimpanan data menggunakan Provider
- Halaman daftar peserta
- Halaman detail peserta
- Edit data peserta
- Hapus data peserta
- Search peserta
- Filter peserta berdasarkan program studi
- Reset form setelah submit berhasil
- Error handling menggunakan try-catch

## Preview Aplikasi
### Halaman Form Registrasi

Halaman ini merupakan halaman utama yang digunakan pengguna untuk melakukan pendaftaran event. Pada halaman ini terdapat beberapa field input yang harus diisi oleh pengguna seperti nama lengkap, email, password, jenis kelamin, program studi, serta tanggal lahir.Form registrasi ini juga dilengkapi dengan sistem validasi sehingga pengguna tidak dapat melakukan submit jika data yang dimasukkan belum sesuai dengan ketentuan. di form ini juga bisa melakukan reset from jadi kalau direset semua data yang kita isi akan hilang.
contoh kalau ada yang nggak diisi

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/3463086c-fd78-497f-9d62-5a567925048b" />

jika sudah berhasil mendaftar maka tampilan seperti ini, akan ada dua pilihan tutup dan juga lihat daftar jadi kita bisa melihat daftar peserta yang sudah mendaftar

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/433214f0-0a87-4c21-a791-8cd9e61b89c9" />

### Multi-Step Form (Stepper)

Form registrasi dalam aplikasi ini dibagi menjadi dua langkah menggunakan widget Stepper.

Tujuan penggunaan Stepper adalah untuk membuat proses pengisian form menjadi lebih terstruktur dan tidak terlalu panjang dalam satu halaman.Langkah pertama digunakan untuk mengisi data akun.

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/5e31a2bc-40bf-4874-a873-472b2d30355b" />

sedangkan langkah kedua digunakan untuk mengisi data tambahan seperti program studi dan tanggal lahir.

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/8860da30-98c6-4a8b-9df6-f25c8bdd4bdc" />

### Halaman Daftar Peserta

Halaman ini menampilkan daftar semua peserta yang telah melakukan pendaftaran pada aplikasi.

Informasi yang ditampilkan pada halaman ini meliputi:
Nama peserta, Email peserta, Program studi peserta

Pada halaman ini pengguna juga dapat melakukan beberapa aksi seperti melihat detail peserta, mengedit data peserta, serta menghapus data peserta dari daftar.

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/3bd6e315-2296-4c4d-b37e-279d7387e2a6" />


### Halaman Detail Peserta

Halaman detail peserta digunakan untuk menampilkan informasi lengkap dari seorang peserta yang telah terdaftar.

Informasi yang ditampilkan antara lain:
Nama lengkap
Email
Jenis kelamin
Program studi
Tanggal lahir
Umur peserta
Waktu pendaftaran

Halaman ini juga menyediakan tombol untuk mengedit data peserta atau menghapus data peserta.

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/6356f049-be72-4a74-82a4-168342530c39" />

### Edit Data Peserta

Aplikasi ini menyediakan fitur untuk mengedit data peserta yang telah terdaftar sebelumnya. Ketika pengguna memilih menu edit, aplikasi akan membuka kembali halaman form registrasi dengan data yang sudah terisi sebelumnya sehingga pengguna dapat langsung melakukan perubahan data.

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/879354c4-89d7-479d-bb11-e77df47fda5b" />

### Search Peserta

Fitur search memungkinkan pengguna untuk mencari data peserta dengan cepat.

Pengguna dapat melakukan pencarian berdasarkan:
Nama peserta
Email peserta
Program studi peserta

Fitur ini sangat membantu ketika jumlah peserta yang terdaftar sudah cukup banyak.

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/4318192f-620a-486e-af7b-306b566c1dc3" />


### Filter Peserta Berdasarkan Program Studi

Selain fitur search, aplikasi ini juga memiliki fitur filter berdasarkan program studi. Dengan fitur ini pengguna dapat menampilkan hanya peserta dari program studi tertentu saja.

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/6bb1297a-d161-4fd0-9cd1-6e3fd5357625" />


### Teknologi yang Digunakan

Aplikasi ini dibangun menggunakan beberapa teknologi utama berikut:

Flutter

Flutter merupakan framework open-source yang dikembangkan oleh Google untuk membuat aplikasi mobile, web, dan desktop menggunakan satu codebase. Flutter digunakan dalam project ini karena memiliki performa yang tinggi serta menyediakan berbagai widget yang memudahkan proses pembuatan UI.

- Dart

Dart merupakan bahasa pemrograman yang digunakan oleh Flutter. Bahasa ini digunakan untuk menulis seluruh logic aplikasi seperti:
pembuatan model data, pengelolaan state, validasi form, navigasi antar halaman

- Provider

Provider digunakan sebagai state management dalam aplikasi ini. Provider memudahkan pengelolaan data peserta sehingga data dapat digunakan oleh berbagai halaman tanpa harus mengirim data secara manual. Fungsi Provider dalam aplikasi ini antara lain:
Menyimpan data peserta
Menambahkan peserta baru
Mengupdate data peserta
Menghapus peserta
Mengambil data peserta berdasarkan ID

- Material UI

Aplikasi ini menggunakan Material Design yang merupakan sistem desain dari Google. Material UI menyediakan berbagai komponen UI seperti:
AppBar
TextField
Button
Card
ListTile
Dialog
Icon

📂 Struktur Folder Project

Berikut adalah struktur folder utama dalam project ini:

lib/
│
├── main.dart
│
├── models/
│   └── registrant_model.dart
│
├── providers/
│   └── registration_provider.dart
│
├── pages/
│   ├── registration_page.dart
│   ├── registrant_list_page.dart
│   └── registrant_detail_page.dart

