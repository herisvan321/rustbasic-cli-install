# RustBasic Smart Installer for Windows (PowerShell)
# --------------------------------------------------

$ErrorActionPreference = "Stop"

Write-Host "`n--- RustBasic Installer for Windows ---" -ForegroundColor Cyan

# 1. Cek Cargo
if (!(Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Error: Rust/Cargo tidak ditemukan. Silakan install dari https://rustup.rs" -ForegroundColor Red
    exit
}

# --- LOGIKA MENU ---
if (Get-Command rustbasic-cli -ErrorAction SilentlyContinue) {
    Write-Host "`nRustBasic sudah terdeteksi di Windows Anda." -ForegroundColor Blue
    Write-Host "1) Reinstall"
    Write-Host "2) Uninstall"
    Write-Host "3) Exit"
    $choice = Read-Host "Pilihan (1-3)"

    if ($choice -eq "2" -or $choice -eq "1") {
        Write-Host "Menghapus instalasi lama..." -ForegroundColor Yellow
        cargo uninstall rustbasic
        if ($choice -eq "2") { exit }
    } else {
        exit
    }
}

# --- INSTALASI ---
$ProjectDir = ""
if (Test-Path "Cargo.toml" -PathType Leaf) {
    $content = Get-Content "Cargo.toml" -Raw
    if ($content -match "name = `"rustbasic`"") { $ProjectDir = "." }
}

if ($ProjectDir -eq "" -and (Test-Path "../rustbasic/rustbasic/Cargo.toml" -PathType Leaf)) {
    $content = Get-Content "../rustbasic/rustbasic/Cargo.toml" -Raw
    if ($content -match "name = `"rustbasic`"") { $ProjectDir = "../rustbasic/rustbasic" }
}

if ($ProjectDir -ne "") {
    Write-Host "`n⏳ Langkah 1/2: Membangun dari folder lokal ($ProjectDir)..." -ForegroundColor Blue
    cargo install --path "$ProjectDir" --bin rustbasic-cli --force
} else {
    Write-Host "`n⏳ Langkah 1/2: Membangun dari GitHub..." -ForegroundColor Blue
    cargo install --git https://github.com/herisvan321/rustbasic --bin rustbasic-cli --force
}

# --- ALIAS ---
Write-Host "⏳ Langkah 2/2: Mendaftarkan alias 'rustbasic'..." -ForegroundColor Blue
$ProfileDir = Split-Path -Parent $PROFILE
if (!(Test-Path $ProfileDir)) { New-Item -Type Directory -Path $ProfileDir -Force }
if (!(Test-Path $PROFILE)) { New-Item -Type File -Path $PROFILE -Force }

$AliasCode = "function rustbasic { rustbasic-cli `$args }"
if (!(Select-String -Path $PROFILE -Pattern "function rustbasic")) {
    Add-Content -Path $PROFILE -Value "`n$AliasCode"
    Write-Host "✅ Alias 'rustbasic' ditambahkan ke Profile PowerShell Anda." -ForegroundColor Green
}

Write-Host "`n✨ RUSTBASIC BERHASIL TERPASANG! ✨" -ForegroundColor Green
Write-Host "Silakan restart terminal PowerShell Anda atau jalankan: . `$PROFILE"
Write-Host "Cobalah perintah: rustbasic new myapp" -ForegroundColor Cyan
