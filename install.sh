#!/bin/bash
# ==============================================
#  Auto Installer Theme Panel by FelixHasgawa 🐧
# ==============================================

# Warna
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# ===================== WELCOME =====================
display_welcome() {
  clear
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${BLUE}[+]         AUTO INSTALLER THEME PTERODACTYL        [+]${NC}"
  echo -e "${BLUE}[+]               © FelixHasgawa 2025               [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "Script ini dibuat untuk mempermudah instalasi tema Pterodactyl."
  echo -e "Dilarang keras menyebarkan atau menjual ulang tanpa izin."
  echo -e ""
  echo -e "TELEGRAM  : @GlobalBotzXD"
  echo -e "CREDITS   : FelixHasgawa & GlobalBotzXD"
  echo -e ""
  sleep 4
  clear
}

# ===================== INSTALL JQ =====================
install_jq() {
  echo -e "${BLUE}[+] Update & Install jq...${NC}"
  sudo apt update -y && sudo apt install -y jq unzip wget curl > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✔ jq berhasil diinstal${NC}"
  else
    echo -e "${RED}✖ Gagal menginstal jq${NC}"
    exit 1
  fi
  sleep 1
  clear
}

# ===================== CHECK TOKEN =====================
check_token() {
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]              LICENSE FelixHasgawa               [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "${YELLOW}Masukkan akses token Anda:${NC}"
  read -r USER_TOKEN

  RAW_URL="https://raw.githubusercontent.com/sandyparadox59-alt/felixbetates/refs/heads/main/gmbs/gg.json"

  json=$(curl -fsS --max-time 10 "$RAW_URL") || json=""
  if [ -z "$json" ]; then
    echo -e "${RED}❌ Gagal mengakses daftar token.${NC}"
    exit 1
  fi

  valid=$(echo "$json" | jq -r --arg t "$USER_TOKEN" '.tokens[] | select(. == $t)')
  if [ -n "$valid" ]; then
    echo -e "${GREEN}✅ AKSES BERHASIL${NC}"
  else
    echo -e "${RED}❌ TOKEN TIDAK VALID${NC}"
    echo -e "${YELLOW}Hubungi @GlobalBotzXD untuk membeli token valid.${NC}"
    exit 1
  fi
  sleep 1
  clear
}

# ===================== INSTALL THEME =====================
install_theme() {
  while true; do
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo -e "${BLUE}[+]                 PILIH THEME                     [+]${NC}"
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo "1. Stellar"
    echo "2. Billing"
    echo "3. Enigma"
    echo "4. Stellar v2"
    echo "5. Billing v2"
    echo "x. Kembali"
    echo -ne "${YELLOW}Masukkan pilihan (1-5/x): ${NC}"
    read -r SELECT_THEME

    case "$SELECT_THEME" in
      1) THEME_URL="https://github.com/sandyparadox59-alt/felixbetates/raw/main/C2.zip"; break ;;
      2) THEME_URL="https://github.com/sandyparadox59-alt/felixbetates/raw/main/enigma.zip"; break ;;
      3) THEME_URL="https://github.com/sandyparadox59-alt/felixbetates/raw/main/C3.zip"; break ;;
      4) THEME_URL="https://github.com/sandyparadox59-alt/felixbetates/raw/main/stellar.zip"; break ;;
      5) THEME_URL="https://github.com/sandyparadox59-alt/felixbetates/raw/main/billing.zip"; break ;;
      x) return ;;
      *) echo -e "${RED}Pilihan tidak valid.${NC}" ;;
    esac
  done

  echo -e "${YELLOW}📦 Mengunduh dan mengekstrak tema...${NC}"
  wget -q "$THEME_URL" -O /root/theme.zip
  unzip -qo /root/theme.zip -d /root/pterodactyl

  echo -e "${GREEN}🚀 Memasang tema ke /var/www/pterodactyl...${NC}"
  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl

  echo -e "${YELLOW}🧱 Membangun ulang panel...${NC}"
  cd /var/www/pterodactyl
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - >/dev/null
  sudo apt install -y nodejs >/dev/null
  sudo npm i -g yarn >/dev/null
  yarn add react-feather >/dev/null
  php artisan migrate --force >/dev/null
  yarn build:production >/dev/null
  php artisan view:clear >/dev/null

  rm -rf /root/theme.zip /root/pterodactyl
  echo -e "${GREEN}✅ INSTALLASI THEME SELESAI${NC}"
  sleep 2
}

# ===================== MENU UTAMA =====================
main_menu() {
  clear
  echo -e "${BLUE}"
  cat <<'PING'
            .--.
           |o_o |
           |:_/ |
          //   \ \
         (|     | )
        /'\_   _/`\
        \___)=(___/
PING
  echo -e "${NC}"
  echo -e "${GREEN}        Auto Installer FelixHasgawa ${NC}"
  echo -e "${YELLOW}------------------------------------------${NC}"
  echo "1. Install Theme"
  echo "2. Uninstall Theme"
  echo "3. Configure Wings"
  echo "4. Create Node"
  echo "5. Uninstall Panel"
  echo "6. Hack Back Panel"
  echo "7. Ubah Password VPS"
  echo "x. Keluar"
  echo -ne "${YELLOW}Pilih menu: ${NC}"
}

# ===================== START SCRIPT =====================
display_welcome
install_jq
check_token

while true; do
  main_menu
  read -r MENU_CHOICE
  clear
  case "$MENU_CHOICE" in
    1) install_theme ;;
    2) echo -e "${YELLOW}🚧 Uninstall Theme (coming soon)${NC}" ;;
    3) echo -e "${YELLOW}🚧 Configure Wings (coming soon)${NC}" ;;
    4) echo -e "${YELLOW}🚧 Create Node (coming soon)${NC}" ;;
    5) echo -e "${YELLOW}🚧 Uninstall Panel (coming soon)${NC}" ;;
    6) echo -e "${YELLOW}🚧 Hack Back Panel (coming soon)${NC}" ;;
    7) echo -e "${YELLOW}🚧 Ubah Password VPS (coming soon)${NC}" ;;
    x) echo -e "${RED}Keluar dari script.${NC}"; exit 0 ;;
    *) echo -e "${RED}Pilihan tidak valid.${NC}" ;;
  esac
  sleep 1
done
