# RustBasic Smart Installer for Windows (PowerShell)
# --------------------------------------------------

$ErrorActionPreference = "Stop"

# --- KONFIGURASI WARNA & SIMBOL ---
$CYAN = "`e[36m"
$BLUE = "`e[34m"
$GREEN = "`e[32m"
$RED = "`e[31m"
$PURPLE = "`e[35m"
$YELLOW = "`e[33m"
$BOLD = "`e[1m"
$DIM = "`e[2m"
$ITALIC = "`e[3m"
$NC = "`e[0m"

$CHECK = "✔"
$INFO = "ℹ"
$STEP = "➜"
$ROCKET = "🚀"

# --- FUNGSI HELPER ---
function Print-Line {
    Write-Host ("${DIM}" + ("─" * 65) + "${NC}")
}

function Print-Header {
    Write-Host ""
    Write-Host "${CYAN}╭───────────────────────────────────────────────────────────────╮${NC}"
    Write-Host "${CYAN}│${NC}    ${BOLD}${PURPLE}RUSTBASIC${NC} ${DIM}- Smart Installer (Windows)${NC}                 ${CYAN}│${NC}"
    Write-Host "${CYAN}╰───────────────────────────────────────────────────────────────╯${NC}"
}

function Print-Step {
    param($num, $msg)
    Write-Host "${BLUE}${BOLD}[$num/4]${NC} ${STEP} $msg"
}

# --- UNINSTALL LOGIC ---
function Uninstall-RustBasic {
    Write-Host "${RED}${BOLD}🗑  Menghapus instalasi RustBasic...${NC}"
    cargo uninstall rustbasic 2>$null
    # Hapus alias dari profile jika ada (ini cukup kompleks di PS, kita lewati untuk simplisitas atau biarkan saja)
    Write-Host "${GREEN}$CHECK Berhasil dihapus.${NC}"
}

Print-Header
Write-Host "${ITALIC}${DIM}Menyiapkan instalasi untuk Windows...${NC}`n"

# 1. Cek Cargo
if (!(Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Host "   ${RED}❌ Error: Rust/Cargo tidak ditemukan. Silakan install dari https://rustup.rs${NC}"
    exit
}

# --- LOGIKA MENU ---
if (Get-Command rustbasic-cli -ErrorAction SilentlyContinue) {
    Write-Host "${BLUE}${BOLD}$INFO RustBasic terdeteksi.${NC} Pilih opsi:"
    Write-Host "   ${CYAN}1)${NC} Reinstall"
    Write-Host "   ${CYAN}2)${NC} Uninstall"
    Write-Host "   ${CYAN}3)${NC} Exit"
    Print-Line
    $choice = Read-Host "   Pilihan [1-3]"
    
    switch ($choice) {
        "1" { Uninstall-RustBasic }
        "2" { Uninstall-RustBasic; exit }
        "3" { exit }
        Default { exit }
    }
    Write-Host ""
}

# --- INSTALASI ---
Print-Step "1" "Membangun dari GitHub..."
cargo install --git https://github.com/herisvan321/rustbasic --bin rustbasic-cli --force

Print-Step "2" "Mendaftarkan perintah global..."
$ProfileDir = Split-Path -Parent $PROFILE
if (!(Test-Path $ProfileDir)) { New-Item -Type Directory -Path $ProfileDir -Force }
if (!(Test-Path $PROFILE)) { New-Item -Type File -Path $PROFILE -Force }

$AliasCode = "function rustbasic { rustbasic-cli `$args }"
if (!(Select-String -Path $PROFILE -Pattern "function rustbasic")) {
    Add-Content -Path $PROFILE -Value "`n$AliasCode"
}

Print-Step "3" "Memeriksa dependensi (cargo-watch)..."
if (!(Get-Command cargo-watch -ErrorAction SilentlyContinue)) {
    cargo install cargo-watch
}

Write-Host "`n${GREEN}${BOLD}╭───────────────────────────────────────────────────────────────╮${NC}"
Write-Host "${GREEN}${BOLD}│${NC}    ${ROCKET}  ${BOLD}RUSTBASIC BERHASIL TERPASANG!${NC}                       ${GREEN}${BOLD}│${NC}"
Write-Host "${GREEN}${BOLD}╰───────────────────────────────────────────────────────────────╯${NC}"
Write-Host "${DIM}Konfigurasi disimpan di: $PROFILE${NC}"

# --- BUAT PROJECT BARU ---
Write-Host ""
Print-Step "4" "Buat project baru?"
$createProject = Read-Host "   Ingin membuat project baru sekarang? (y/n)"

if ($createProject -eq "y" -or $createProject -eq "Y") {
    $projectName = Read-Host "   Nama project"
    
    if ([string]::IsNullOrWhiteSpace($projectName)) {
        Write-Host "   ${RED}❌ Nama project tidak boleh kosong.${NC}"
    } elseif (Test-Path $projectName) {
        Write-Host "   ${RED}❌ Folder '$projectName' sudah ada!${NC}"
    } else {
        Write-Host "   ${BLUE}⏳ Mengkloning template project...${NC}"
        git clone https://github.com/herisvan321/rustbasic "$projectName"
        Remove-Item -Path "$projectName\.git" -Recurse -Force

        if (Test-Path "$projectName\.env.example") {
            Copy-Item "$projectName\.env.example" "$projectName\.env"
            Write-Host "   ${BLUE}📋${NC} .env.example → .env"
        }

        if (Test-Path "$projectName\.env") {
            Write-Host "   ${BLUE}🔑${NC} Generating APP_KEY..."
            Set-Location $projectName
            rustbasic-cli key:generate
            Set-Location ..
        }

        Write-Host "`n${GREEN}${BOLD}$CHECK Project '$projectName' berhasil dibuat!${NC}"
        Write-Host "   ${DIM}Jalankan perintah berikut:${NC}"
        Write-Host "   ${BOLD}cd $projectName${NC}"
        Write-Host "   ${BOLD}rustbasic serve${NC}"
    }
} else {
    Write-Host "`n${YELLOW}${INFO} Info:${NC} Gunakan perintah berikut untuk membuat project baru:"
    Write-Host "   ${BOLD}${CYAN}rustbasic new <nama_project>${NC}"
}

Write-Host "`n${ITALIC}${DIM}Silakan restart terminal atau jalankan: . `$PROFILE${NC}"
