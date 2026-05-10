#!/bin/bash

# RustBasic Smart Installer (Mac & Linux)
# ---------------------------------------

set -e

# Warna output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

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

echo -e "${CYAN}${BOLD}Menjalankan RustBasic Installer untuk $OS_TYPE...${NC}\n"

# --- FUNGSI UNINSTALL ---
uninstall_rustbasic() {
    echo -e "${RED}Menghapus instalasi RustBasic...${NC}"
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
    echo -e "${GREEN}✅ Berhasil dihapus.${NC}"
}

# --- LOGIKA MENU ---
if command -v rustbasic-cli &> /dev/null || [ -f "/usr/local/bin/rustbasic" ]; then
    echo -e "${BLUE}RustBasic terdeteksi.${NC} Pilih opsi:"
    echo "1) Reinstall"
    echo "2) Uninstall"
    echo "3) Exit"
    if [ -t 0 ]; then
        read -p "Pilihan: " choice
    else
        read -p "Pilihan: " choice < /dev/tty
    fi
    case $choice in
        1) uninstall_rustbasic ;;
        2) uninstall_rustbasic; exit 0 ;;
        *) exit 0 ;;
    esac
fi

# --- INSTALASI ---
echo -e "${BLUE}⏳ Langkah 1/3: Membangun dari GitHub...${NC}"
cargo install --git https://github.com/herisvan321/rustbasic --bin rustbasic-cli --force

echo -e "${BLUE}⏳ Langkah 2/3: Mendaftarkan perintah global...${NC}"
# Symlink untuk akses instan (opsional, jika punya izin)
if [ -w "/usr/local/bin" ]; then
    ln -sf "$HOME/.cargo/bin/rustbasic-cli" /usr/local/bin/rustbasic || true
else
    echo -e "${BLUE}💡 Info: Melewati pembuatan symlink di /usr/local/bin (izin ditolak).${NC}"
fi

# Alias untuk permanen
if ! grep -q "alias rustbasic=" "$SHELL_CONFIG"; then
    echo "alias rustbasic='rustbasic-cli'" >> "$SHELL_CONFIG"
fi

echo -e "${BLUE}⏳ Langkah 3/4: Cek dependency...${NC}"
command -v cargo-watch &> /dev/null || cargo install cargo-watch

echo -e "\n${GREEN}${BOLD}✨ RUSTBASIC BERHASIL TERPASANG! ✨${NC}"
echo -e "Konfigurasi disimpan di: $SHELL_CONFIG"

# --- BUAT PROJECT BARU (OPSIONAL) ---
echo ""
echo -e "${CYAN}${BOLD}📦 Langkah 4/4: Buat project baru?${NC}"
if [ -t 0 ]; then
    read -p "Ingin membuat project baru sekarang? (y/n): " create_project
else
    read -p "Ingin membuat project baru sekarang? (y/n): " create_project < /dev/tty
fi

if [ "$create_project" == "y" ] || [ "$create_project" == "Y" ]; then
    if [ -t 0 ]; then
        read -p "Nama project: " project_name
    else
        read -p "Nama project: " project_name < /dev/tty
    fi

    if [ -z "$project_name" ]; then
        echo -e "${RED}❌ Nama project tidak boleh kosong.${NC}"
    elif [ -d "$project_name" ]; then
        echo -e "${RED}❌ Folder '$project_name' sudah ada!${NC}"
    else
        echo -e "${BLUE}⏳ Mengkloning template project...${NC}"
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

        echo -e "\n${GREEN}${BOLD}✅ Project '$project_name' berhasil dibuat!${NC}"
        echo -e "   cd $project_name"
        echo -e "   rustbasic serve"
    fi
else
    echo -e "\n${GREEN}Gunakan perintah berikut untuk membuat project baru:${NC}"
    echo -e "   ${BOLD}rustbasic new \<nama_project\>${NC}"
fi

echo -e "\nSilakan jalankan '${BOLD}source $SHELL_CONFIG${NC}' jika perintah belum muncul."
