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
uninstall_panel() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                    UNINSTALL PANEL                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "


bash <(curl -s https://pterodactyl-installer.se) <<EOF
y
y
y
y
EOF


  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]                 UNINSTALL PANEL SUKSES             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  exit 0
}

# Uninstall theme
uninstall_theme() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                    DELETE THEME                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  bash <(curl https://raw.githubusercontent.com/sandyparadox59-alt/felixbetates/edit/main/repair.sh)
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]                 DELETE THEME SUKSES             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
}
install_themeSteeler() {
#!/bin/bash

echo -e "                                                       "
echo -e "${BLUE}[+] =============================================== [+]${NC}"
echo -e "${BLUE}[+]                  INSTALLASI THEMA               [+]${NC}"
echo -e "${BLUE}[+] =============================================== [+]${NC}"
echo -e "                                                                   "

# Unduh file tema
wget -O /root/C2.zip https://github.com/sandyparadox59-alt/felixbetates/raw/main/C2.zip

# Ekstrak file tema
unzip /root/C2.zip -d /root/pterodactyl

# Salin tema ke direktori Pterodactyl
sudo cp -rfT /root/pterodactyl /var/www/pterodactyl

# Instal Node.js dan Yarn
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm i -g yarn

# Instal dependensi dan build tema
cd /var/www/pterodactyl
yarn add react-feather
php artisan migrate
yarn build:production
php artisan view:clear

# Hapus file dan direktori sementara
sudo rm /root/C2.zip
sudo rm -rf /root/pterodactyl

echo -e "                                                       "
echo -e "${GREEN}[+] =============================================== [+]${NC}"
echo -e "${GREEN}[+]                   INSTALL SUCCESS               [+]${NC}"
echo -e "${GREEN}[+] =============================================== [+]${NC}"
echo -e ""
sleep 2
clear
exit 0

}
create_node() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                    CREATE NODE                     [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  #!/bin/bash
#!/bin/bash

# Minta input dari pengguna
read -p "Masukkan nama lokasi: " location_name
read -p "Masukkan deskripsi lokasi: " location_description
read -p "Masukkan domain: " domain
read -p "Masukkan nama node: " node_name
read -p "Masukkan RAM (dalam MB): " ram
read -p "Masukkan jumlah maksimum disk space (dalam MB): " disk_space
read -p "Masukkan Locid: " locid

# Ubah ke direktori pterodactyl
cd /var/www/pterodactyl || { echo "Direktori tidak ditemukan"; exit 1; }

# Membuat lokasi baru
php artisan p:location:make <<EOF
$location_name
$location_description
EOF

# Membuat node baru
php artisan p:node:make <<EOF
$node_name
$location_description
$locid
https
$domain
yes
no
no
$ram
$ram
$disk_space
$disk_space
100
8080
2022
/var/lib/pterodactyl/volumes
EOF

  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]        CREATE NODE & LOCATION SUKSES             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  exit 0
}
configure_wings() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                    CONFIGURE WINGS                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  #!/bin/bash

# Minta input token dari pengguna
read -p "Masukkan token Configure menjalankan wings: " wings

eval "$wings"
# Menjalankan perintah systemctl start wings
sudo systemctl start wings

  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]                 CONFIGURE WINGS SUKSES             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  exit 0
}
hackback_panel() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                    HACK BACK PANEL                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  # Minta input dari pengguna
read -p "Masukkan Username Panel: " user
read -p "password login " psswdhb
  #!/bin/bash
cd /var/www/pterodactyl || { echo "Direktori tidak ditemukan"; exit 1; }

# Membuat lokasi baru
php artisan p:user:make <<EOF
yes
hackback@gmail.com
$user
$user
$user
$psswdhb
EOF
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]                 AKUN TELAH DI ADD             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  
  exit 0
}
ubahpw_vps() {
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]                    UBAH PASSWORD VPS       [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
read -p "Masukkan Pw Baru: " pw
read -p "Masukkan Ulang Pw Baru " pw

passwd <<EOF
$pw
$pw

EOF


  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]                 GANTI PW VPS SUKSES         [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  
  exit 0
}

# Main script
display_welcome
install_jq
check_token

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
  echo "8. install themeSteeler"
  echo "x. Keluar"
  echo -ne "${YELLOW}Pilih menu: ${NC}"
}
while true; do
  main_menu
  read -r MENU_CHOICE
  clear
  case "$MENU_CHOICE" in
    1) install_theme ;;
    2) uninstall_theme ;;
    3) configure_wings ;;
    4) create_node ;;
    5) uninstall_panel ;;
    6) hackback_panel ;;
    7) ubahpw_vps ;;
    8) install_themeSteeler ;;
    x) echo -e "${RED}Keluar dari script.${NC}"; exit 0 ;;
    *) echo -e "${RED}Pilihan tidak valid.${NC}" ;;
  esac
  sleep 1
done
