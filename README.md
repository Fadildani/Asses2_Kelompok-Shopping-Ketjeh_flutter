# shoppinglistcs

A new Flutter project.

| Nama                  | NIM       | Tugas                                 |
| --------------------- | --------- | ------------------------------------- |
| Fadillah Dani Prawoto | (2310130004) | Login, SharedPreferences, Dokumentasi |
| Fathi Fathan Fathurrahman | (2310130005) | Light/Dark Mode, SQLite (CRUD)  |
| Muhamad Hafidz Hazhar | (2310130014) | UI Homepage, Add Item Page            |


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

**Login Page**

![WhatsApp Image 2025-11-23 at 23 09 10_31fb53c9](https://github.com/user-attachments/assets/580416c9-5153-40b6-9f81-0752512cfe1a)


**Home Page**

![WhatsApp Image 2025-11-23 at 23 10 55_eb76c6d9](https://github.com/user-attachments/assets/ee81c3a6-2848-4aaf-a801-dcb944f99a18)


**Add Item Page**

![WhatsApp Image 2025-11-23 at 23 10 24_52e7f158](https://github.com/user-attachments/assets/943e7864-0521-4760-ad63-3cfdf696c8b6)


**Setelah add item**

![WhatsApp Image 2025-11-23 at 23 10 24_52e7f158](https://github.com/user-attachments/assets/c127ddc3-8e67-4ddd-9505-d78c81e40ed9)


**Light Dark Mode**

![WhatsApp Image 2025-11-23 at 23 12 09_48a9eb5c](https://github.com/user-attachments/assets/7faa63f3-d214-4d05-a53d-b353529d518d)


**💾 Penjelasan Bagaimana Aplikasi Menyimpan Data
SharedPreferences**

- Menyimpan data sederhana seperti status login dan tema.

- Data disimpan sebagai key-value.

- Tidak hilang meskipun aplikasi ditutup.

Contoh:
_
isLoggedIn = true
isDarkMode = false_

**SQLite**

Menyimpan data item secara permanen dalam bentuk database.

Digunakan untuk data tabel seperti nama barang dan jumlah.

Mendukung operasi CRUD (Create, Read, Update, Delete).

