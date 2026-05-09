# RustBasic CLI Installer

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Rust](https://img.shields.io/badge/rust-v1.70%2B-orange.svg)](https://www.rust-lang.org/)

Repository ini berisi skrip instalasi otomatis untuk **RustBasic CLI**, sebuah framework pengembangan aplikasi berbasis Rust yang dirancang untuk kemudahan dan kecepatan.

## 🚀 Fitur Script
- **Smart Installer**: Mendeteksi secara otomatis apakah Anda berada di direktori source code `rustbasic`. Jika iya, ia akan menginstal versi lokal; jika tidak, ia akan menginstal versi terbaru dari GitHub.
- **Deteksi OS Otomatis**: Mendeteksi sistem operasi (Windows, macOS, Linux) dan menyesuaikan langkah instalasi.
- **Global Alias**: Mendaftarkan perintah `rustbasic` secara global sehingga Anda dapat langsung menggunakannya tanpa mengetik nama executable aslinya.
- **Dependency Check**: Memastikan tools pendukung seperti `cargo-watch` terinstall.
- **Management**: Menu interaktif untuk Reinstall atau Uninstall dengan mudah.

---

## 🛠️ Cara Instalasi

### macOS & Linux
Gunakan `curl` untuk menjalankan script langsung dari terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/herisvan321/rustbasic-cli-install/main/rustbasic.sh)"
```

*Atau unduh dan jalankan secara manual:*
1. Download `rustbasic.sh`.
2. Beri izin eksekusi: `chmod +x rustbasic.sh`.
3. Jalankan: `./rustbasic.sh`.

### Windows (PowerShell)
Buka PowerShell sebagai Administrator dan jalankan perintah berikut:

```powershell
powershell -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/herisvan321/rustbasic-cli-install/main/rustbasic.ps1 | iex"
```

*Atau unduh dan jalankan secara manual:*
1. Download `rustbasic.ps1`.
2. Jalankan di PowerShell: `.\rustbasic.ps1`.

---

## 📖 Penggunaan Awal

Setelah instalasi selesai, Anda dapat mulai menggunakan perintah `rustbasic`:

```bash
# Membuat project baru
rustbasic new my-awesome-app

# Menjalankan server development
rustbasic serve

# Melihat bantuan/daftar perintah
rustbasic
```

> [!TIP]
> Jika perintah `rustbasic` tidak ditemukan setelah instalasi, silakan restart terminal Anda atau jalankan `source ~/.zshrc` atau `source ~/.bashrc` (macOS/Linux) atau `. $PROFILE` (Windows).

---

## 🗑️ Uninstall
Untuk menghapus RustBasic dari sistem Anda, cukup jalankan kembali script instalasi dan pilih opsi **Uninstall (2)** saat menu muncul.

---

## 📄 Lisensi
Project ini dilisensikan di bawah MIT License. Lihat file [LICENSE](LICENSE) untuk informasi lebih lanjut.

---
Created with ❤️ by [herisvan321](https://github.com/herisvan321)
