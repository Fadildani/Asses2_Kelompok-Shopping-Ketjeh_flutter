# shoppinglistcs

A new Flutter project.

| Nama                  | NIM       | Tugas                                 |
| --------------------- | --------- | ------------------------------------- |
| Fadillah Dani Prawoto | (2310130004) | Login, SharedPreferences, Dokumentasi |
| Fathi Fathan Fathurrahman | (2310130005) | Light/Dark Mode, SQLite (CRUD)  |
| Muhamad Hafidz Hazhar | (23101300) | UI Homepage, Add Item Page            |


📌 Pembagian Tugas

**Fadillah Dani Prawoto**

- Implementasi fitur login

- Implementasi SharedPreferences

- Dokumentasi proyek & README
  

**Fathi Fathan Fathurrahman**

- Desain dan implementasi tampilan Home Page

- Implementasi fitur Light/Dark Mode
  

**Muhamad Hafidz Hazhar**

Implementasi database SQLite

CRUD untuk data item di Add Item Page


🔐 Penjelasan Fitur Login

Fitur login digunakan untuk memverifikasi pengguna sebelum mengakses halaman utama aplikasi.
Alur proses login:

Pengguna memasukkan username dan password.

Sistem memeriksa kecocokan data (validasi lokal).

Jika benar → aplikasi menyimpan status login dengan SharedPreferences.

Pengguna diarahkan ke Home Page.

Jika salah → ditampilkan pesan error.

**SharedPreferences menyimpan:**

isLoggedIn = true/false
username = "nama_pengguna"


**🌗 Penjelasan Fitur Light/Dark Mode**

Aplikasi menyediakan dua tema:

Light Mode → tampilan terang

Dark Mode → tampilan gelap

Pengguna dapat mengubah mode melalui toggle switch.
Pilihan tema disimpan menggunakan SharedPreferences, sehingga tema tetap sama meskipun aplikasi ditutup dan dibuka kembali.

Data yang disimpan:

isDarkMode = true/false


  **🗄️ Implementasi SQLite & SharedPreferences
SQLite**

SQLite digunakan untuk menyimpan data item secara lokal.
Fitur yang diterapkan:

- Membuat tabel items

- Menambahkan data item

- Menampilkan list item

- Mengubah data

- Menghapus data


**SharedPreferences**

Digunakan untuk menyimpan data ringan (key-value), seperti:

- Status login

- Tema aplikasi

SharedPreferences memastikan pengalaman pengguna tetap konsisten.
