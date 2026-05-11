#!/bin/bash

# RustBasic Smart Installer (Mac & Linux)
# ---------------------------------------

set -e

# Warna & Gaya output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
NC='\033[0m'

# Simbol
CHECK="✔"
INFO="ℹ"
STEP="➜"
ROCKET="🚀"

# Fungsi Helper UI
print_line() {
    echo -e "${DIM}─────────────────────────────────────────────────────────────────${NC}"
}

print_header() {
    echo -e "\n${CYAN}╭───────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${CYAN}│${NC}    ${BOLD}${PURPLE}RUSTBASIC${NC} ${DIM}- Smart Installer (Mac & Linux)${NC}           ${CYAN}│${NC}"
    echo -e "${CYAN}╰───────────────────────────────────────────────────────────────╯${NC}"
}

print_step() {
    local step_num=$1
    local message=$2
    echo -e "${BLUE}${BOLD}[${step_num}/4]${NC} ${STEP} ${message}"
}

# Deteksi OS
OS_TYPE="$(uname)"
if [ "$OS_TYPE" == "Darwin" ]; then
    SED_EXT="''"
    SHELL_CONFIG="$HOME/.zshrc"
    [ ! -f "$SHELL_CONFIG" ] && SHELL_CONFIG="$HOME/.bash_profile"
else
    SED_EXT=""
    SHELL_CONFIG="$HOME/.bashrc"
    [ -f "$HOME/.zshrc" ] && SHELL_CONFIG="$HOME/.zshrc"
fi

print_header
echo -e "${ITALIC}${DIM}Menyiapkan instalasi untuk $OS_TYPE...${NC}\n"

# --- FUNGSI UNINSTALL ---
uninstall_rustbasic() {
    echo -e "${RED}${BOLD}🗑  Menghapus instalasi RustBasic...${NC}"
    cargo uninstall rustbasic || true
    if [ -f "/usr/local/bin/rustbasic" ]; then
        sudo rm -f /usr/local/bin/rustbasic || true
    fi
    # Hapus alias dari config shell
    if [ "$OS_TYPE" == "Darwin" ]; then
        sed -i '' '/alias rustbasic=/d' "$SHELL_CONFIG" || true
    else
        sed -i '/alias rustbasic=/d' "$SHELL_CONFIG" || true
    fi
    echo -e "${GREEN}${CHECK} Berhasil dihapus.${NC}"
}

# --- LOGIKA MENU ---
if command -v rustbasic-cli &> /dev/null || [ -f "/usr/local/bin/rustbasic" ]; then
    echo -e "${BLUE}${BOLD}${INFO} RustBasic terdeteksi.${NC} Pilih opsi:"
    echo -e "   ${CYAN}1)${NC} Reinstall"
    echo -e "   ${CYAN}2)${NC} Uninstall"
    echo -e "   ${CYAN}3)${NC} Exit"
    print_line
    if [ -t 0 ]; then
        read -p "   Pilihan [1-3]: " choice
    else
        read -p "   Pilihan [1-3]: " choice < /dev/tty
    fi
    case $choice in
        1) uninstall_rustbasic ;;
        2) uninstall_rustbasic; exit 0 ;;
        *) exit 0 ;;
    esac
    echo ""
fi

# --- INSTALASI ---
print_step "1" "Membangun dari GitHub..."
cargo install --git https://github.com/herisvan321/rustbasic --bin rustbasic-cli --force

print_step "2" "Mendaftarkan perintah global..."
# Symlink untuk akses instan (opsional, jika punya izin)
if [ -w "/usr/local/bin" ]; then
    ln -sf "$HOME/.cargo/bin/rustbasic-cli" /usr/local/bin/rustbasic || true
else
    echo -e "   ${DIM}💡 Info: Melewati pembuatan symlink di /usr/local/bin (izin ditolak).${NC}"
fi

# Alias untuk permanen
if ! grep -q "alias rustbasic=" "$SHELL_CONFIG"; then
    echo "alias rustbasic='rustbasic-cli'" >> "$SHELL_CONFIG"
fi

print_step "3" "Memeriksa dependensi (cargo-watch)..."
command -v cargo-watch &> /dev/null || cargo install cargo-watch

echo -e "\n${GREEN}${BOLD}╭───────────────────────────────────────────────────────────────╮${NC}"
echo -e "${GREEN}${BOLD}│${NC}    ${ROCKET}  ${BOLD}RUSTBASIC BERHASIL TERPASANG!${NC}                       ${GREEN}${BOLD}│${NC}"
echo -e "${GREEN}${BOLD}╰───────────────────────────────────────────────────────────────╯${NC}"
echo -e "${DIM}Konfigurasi disimpan di: $SHELL_CONFIG${NC}"

echo ""
print_step "4" "Buat project baru?"
if [ -t 0 ]; then
    read -p "   Ingin membuat project baru sekarang? (y/n): " create_project
else
    read -p "   Ingin membuat project baru sekarang? (y/n): " create_project < /dev/tty
fi

if [ "$create_project" == "y" ] || [ "$create_project" == "Y" ]; then
    if [ -t 0 ]; then
        read -p "   Nama project: " project_name
    else
        read -p "   Nama project: " project_name < /dev/tty
    fi

    if [ -z "$project_name" ]; then
        echo -e "   ${RED}❌ Nama project tidak boleh kosong.${NC}"
    elif [ -d "$project_name" ]; then
        echo -e "   ${RED}❌ Folder '$project_name' sudah ada!${NC}"
    else
        echo -e "   ${BLUE}⏳ Mengkloning template project...${NC}"
        git clone https://github.com/herisvan321/rustbasic "$project_name"
        rm -rf "$project_name/.git"

        # Copy .env.example menjadi .env
        if [ -f "$project_name/.env.example" ]; then
            cp "$project_name/.env.example" "$project_name/.env"
            echo -e "   ${BLUE}📋${NC} .env.example → .env"
        fi

        # Generate APP_KEY
        if [ -f "$project_name/.env" ]; then
            echo -e "   ${BLUE}🔑${NC} Generating APP_KEY..."
            cd "$project_name"
            rustbasic-cli key:generate 2>/dev/null || "$HOME/.cargo/bin/rustbasic-cli" key:generate 2>/dev/null || true
            cd ..
        fi

        echo -e "\n${GREEN}${BOLD}${CHECK} Project '$project_name' berhasil dibuat!${NC}"
        echo -e "   ${DIM}Jalankan perintah berikut:${NC}"
        echo -e "   ${BOLD}cd $project_name${NC}"
        echo -e "   ${BOLD}rustbasic serve${NC}"
    fi
else
    echo -e "\n${YELLOW}${INFO} Info:${NC} Gunakan perintah berikut untuk membuat project baru:"
    echo -e "   ${BOLD}${CYAN}rustbasic new <nama_project>${NC}"
fi

echo -e "\n${ITALIC}${DIM}Silakan jalankan '${BOLD}source $SHELL_CONFIG${NC}${ITALIC}${DIM}' jika perintah 'rustbasic' belum muncul.${NC}"
