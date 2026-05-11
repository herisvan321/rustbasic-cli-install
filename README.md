# 🚀 RustBasic Smart Installer

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Rust](https://img.shields.io/badge/rust-v1.70%2B-orange.svg)](https://www.rust-lang.org/)
[![CLI](https://img.shields.io/badge/UI-Elegant-purple.svg)](#)

Solusi instalasi satu baris yang cerdas untuk **RustBasic Framework**. Didesain untuk memberikan pengalaman developer yang mulus, cepat, dan elegan di berbagai platform.

---

## ✨ Kenapa Memilih Smart Installer?

*   **Zero Configuration**: Menangani semua proses kompilasi dan registrasi perintah global secara otomatis.
*   **Multi-Platform Support**: Skrip cerdas untuk macOS, Linux, dan Windows (PowerShell).
*   **Elegant UI**: Antarmuka CLI yang bersih dengan indikator langkah yang intuitif.
*   **Dependency Management**: Otomatis memastikan `cargo-watch` terpasang untuk fitur *realtime development*.
*   **Interactive Menu**: Kemudahan untuk melakukan *reinstall* atau *uninstall* hanya dengan satu perintah.
*   **Post-Install Workflow**: Opsi untuk langsung membuat project baru setelah instalasi selesai.

---

## 🛠️ Instalasi Cepat

Pilih sistem operasi Anda dan jalankan perintah di bawah ini di terminal:

### 🍎 macOS & 🐧 Linux
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/herisvan321/rustbasic-cli-install/main/rustbasic.sh)"
```

### 🪟 Windows (PowerShell)
```powershell
powershell -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/herisvan321/rustbasic-cli-install/main/rustbasic.ps1 | iex"
```

---

## 🚀 Memulai Project Pertama

Setelah instalasi sukses, Anda dapat langsung membuat aplikasi Rust pertama Anda:

```bash
# 1. Buat project baru (atau gunakan menu interaktif di installer)
rustbasic new my-app

# 2. Masuk ke direktori
cd my-app

# 3. Jalankan server dengan fitur hot-reload
rustbasic serve
```

---

## 🔧 Perintah Tersedia

| Perintah | Deskripsi |
| :--- | :--- |
| `rustbasic new <name>` | Membuat struktur project RustBasic baru |
| `rustbasic serve` | Menjalankan server development (realtime) |
| `rustbasic key:generate` | Menghasilkan APP_KEY baru di file .env |
| `rustbasic --help` | Melihat daftar perintah lengkap |

---

## 🗑️ Uninstall & Maintenance

Untuk memperbarui atau menghapus RustBasic, cukup jalankan kembali skrip instalasi di atas. Script akan mendeteksi instalasi yang ada dan menampilkan menu pilihan:
1. **Reinstall**: Memperbarui ke versi terbaru dari GitHub.
2. **Uninstall**: Menghapus binary dan alias dari sistem secara bersih.

---

## 📄 Lisensi
Didistribusikan di bawah **MIT License**. Lihat `LICENSE` untuk detail selengkapnya.

---
Crafted with ✨ by [herisvan321](https://github.com/herisvan321)
