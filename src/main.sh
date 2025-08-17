#!/bin/bash

# =========================
#   eKematian - Simulasi Database (Versi Bash)
#   Mengikut Struktur Table 2024
#   Untuk Android & Web (Proof of Concept)
# =========================

# Fail Data
DATA_PESERTA="peserta.txt"
DATA_PERTUBUHAN="pertubuhan.txt"
DATA_WARIS="waris.txt"
DATA_TRANSAKSI="transaksi.txt"
DATA_KEMATIAN="kematian.txt"

# Utiliti
function line() { printf '=%.0s' {1..80}; echo; }
function pause() { read -n1 -r -p "Tekan sebarang kekunci untuk kembali ke menu..."; }

# Menu Utama
function menu() {
    clear
    line
    echo "                        eKematian - Sistem Pengurusan Kematian"
    line
    echo "1. Daftar Peserta"
    echo "2. Senarai Peserta"
    echo "3. Daftar Pertubuhan"
    echo "4. Senarai Pertubuhan"
    echo "5. Daftar Waris Peserta"
    echo "6. Senarai Waris"
    echo "7. Daftar Transaksi"
    echo "8. Senarai Transaksi"
    echo "9. Daftar Kematian"
    echo "10. Senarai Kematian"
    echo "0. Keluar"
    line
    read -p "Pilihan anda: " pilihan
    case $pilihan in
        1) daftar_peserta ;;
        2) senarai_peserta ;;
        3) daftar_pertubuhan ;;
        4) senarai_pertubuhan ;;
        5) daftar_waris ;;
        6) senarai_waris ;;
        7) daftar_transaksi ;;
        8) senarai_transaksi ;;
        9) daftar_kematian ;;
        10) senarai_kematian ;;
        0) keluar ;;
        *) echo "Pilihan tidak sah!" ; pause ;;
    esac
    menu
}

# Utiliti Dapatkan ID Baru
function auto_id() {
    # $1 = fail data
    if [ ! -s "$1" ]; then echo 1
    else awk -F'|' 'END{print $1+1}' "$1"; fi
}

function peserta_auto_no_keahlian() {
    local id=$1
    local date_code=$(date +%y%m%d)
    echo "EKM-${date_code}-${id}"
}

# --- Peserta
function daftar_peserta() {
    clear; line
    echo "DAFTAR PESERTA BARU"
    line
    read -p "Nama Penuh Peserta           : " nama
    read -p "Tarikh Lahir (YYYY-MM-DD)    : " tarikh_lahir
    id=$(auto_id $DATA_PESERTA)
    no_keahlian=$(peserta_auto_no_keahlian $id)
    tarikh_keahlian=$(date +%Y-%m-%d)
    status="aktif"
    # Ringkas: id|nama|tarikh_lahir|no_keahlian|tarikh_keahlian|status
    echo "${id}|${nama}|${tarikh_lahir}|${no_keahlian}|${tarikh_keahlian}|${status}" >> $DATA_PESERTA
    echo
    echo "✅ Peserta didaftarkan dengan No Keahlian: $no_keahlian"
    pause
}

function senarai_peserta() {
    clear; line
    echo "SENARAI PESERTA"
    line
    if [ ! -s $DATA_PESERTA ]; then
        echo "Tiada peserta didaftarkan."
    else
        printf "%-5s | %-25s | %-15s | %-10s | %-8s\n" "ID" "Nama" "No. Keahlian" "Tarikh" "Status"
        line
        awk -F'|' '{printf "%-5s | %-25s | %-15s | %-10s | %-8s\n", $1, $2, $4, $5, $6}' $DATA_PESERTA
    fi
    line; pause
}

# --- Pertubuhan
function daftar_pertubuhan() {
    clear; line
    echo "DAFTAR PERTUBUHAN"
    line
    read -p "Nama Pertubuhan            : " nama
    read -p "Visi                       : " visi
    read -p "Misi                       : " misi
    id=$(auto_id $DATA_PERTUBUHAN)
    # id|nama|visi|misi
    echo "${id}|${nama}|${visi}|${misi}" >> $DATA_PERTUBUHAN
    echo "✅ Pertubuhan didaftarkan."
    pause
}

function senarai_pertubuhan() {
    clear; line
    echo "SENARAI PERTUBUHAN"
    line
    if [ ! -s $DATA_PERTUBUHAN ]; then
        echo "Tiada pertubuhan didaftarkan."
    else
        printf "%-5s | %-25s | %-30s | %-30s\n" "ID" "Nama" "Visi" "Misi"
        line
        awk -F'|' '{printf "%-5s | %-25s | %-30s | %-30s\n", $1, $2, $3, $4}' $DATA_PERTUBUHAN
    fi
    line; pause
}

# --- Waris
function daftar_waris() {
    clear; line
    echo "DAFTAR WARIS PESERTA"
    line
    read -p "No. Keahlian Peserta      : " no_keahlian
    peserta_line=$(awk -F'|' -v nk="$no_keahlian" '$4==nk{print}' $DATA_PESERTA)
    if [ -z "$peserta_line" ]; then
        echo "❌ Peserta tidak dijumpai."
        pause; return
    fi
    peserta_id=$(echo "$peserta_line" | awk -F'|' '{print $1}')
    peserta_nama=$(echo "$peserta_line" | awk -F'|' '{print $2}')
    echo "Nama Peserta: $peserta_nama"
    read -p "Nama Waris                : " nama
    read -p "Hubungan (cth: Ayah/Ibu)  : " hubungan
    read -p "No. Telefon Waris         : " notel
    id=$(auto_id $DATA_WARIS)
    # id|peserta_id|nama|hubungan|notel
    echo "${id}|${peserta_id}|${nama}|${hubungan}|${notel}" >> $DATA_WARIS
    echo "✅ Waris peserta didaftarkan."
    pause
}

function senarai_waris() {
    clear; line
    echo "SENARAI WARIS PESERTA"
    line
    if [ ! -s $DATA_WARIS ]; then
        echo "Tiada waris didaftarkan."
    else
        printf "%-5s | %-20s | %-20s | %-15s | %-15s\n" "ID" "Nama Peserta" "Nama Waris" "Hubungan" "No Tel"
        line
        while IFS='|' read -r id peserta_id nama hubungan notel; do
            peserta=$(awk -F'|' -v pid="$peserta_id" '$1==pid{print $2}' $DATA_PESERTA)
            printf "%-5s | %-20s | %-20s | %-15s | %-15s\n" "$id" "$peserta" "$nama" "$hubungan" "$notel"
        done < $DATA_WARIS
    fi
    line; pause
}

# --- Transaksi
function daftar_transaksi() {
    clear; line
    echo "DAFTAR TRANSAKSI PESERTA"
    line
    read -p "No. Keahlian Peserta      : " no_keahlian
    peserta_line=$(awk -F'|' -v nk="$no_keahlian" '$4==nk{print}' $DATA_PESERTA)
    if [ -z "$peserta_line" ]; then
        echo "❌ Peserta tidak dijumpai."
        pause; return
    fi
    peserta_id=$(echo "$peserta_line" | awk -F'|' '{print $1}')
    peserta_nama=$(echo "$peserta_line" | awk -F'|' '{print $2}')
    echo "Nama Peserta: $peserta_nama"
    read -p "Tarikh Transaksi (YYYY-MM-DD): " tarikh
    read -p "Jenis (cth: yuran, derma)    : " jenis
    read -p "Jumlah (cth: 100.00)         : " jumlah
    id=$(auto_id $DATA_TRANSAKSI)
    # id|peserta_id|tarikh|jenis|jumlah
    echo "${id}|${peserta_id}|${tarikh}|${jenis}|${jumlah}" >> $DATA_TRANSAKSI
    echo "✅ Transaksi didaftarkan."
    pause
}

function senarai_transaksi() {
    clear; line
    echo "SENARAI TRANSAKSI PESERTA"
    line
    if [ ! -s $DATA_TRANSAKSI ]; then
        echo "Tiada transaksi didaftarkan."
    else
        printf "%-5s | %-20s | %-12s | %-10s | %-10s\n" "ID" "Nama Peserta" "Tarikh" "Jenis" "Jumlah"
        line
        while IFS='|' read -r id peserta_id tarikh jenis jumlah; do
            peserta=$(awk -F'|' -v pid="$peserta_id" '$1==pid{print $2}' $DATA_PESERTA)
            printf "%-5s | %-20s | %-12s | %-10s | %-10s\n" "$id" "$peserta" "$tarikh" "$jenis" "$jumlah"
        done < $DATA_TRANSAKSI
    fi
    line; pause
}

# --- Kematian
function daftar_kematian() {
    clear; line
    echo "DAFTAR REKOD KEMATIAN"
    line
    read -p "No. Keahlian Peserta      : " no_keahlian
    peserta_line=$(awk -F'|' -v nk="$no_keahlian" '$4==nk{print}' $DATA_PESERTA)
    if [ -z "$peserta_line" ]; then
        echo "❌ Peserta tidak dijumpai."
        pause; return
    fi
    peserta_id=$(echo "$peserta_line" | awk -F'|' '{print $1}')
    peserta_nama=$(echo "$peserta_line" | awk -F'|' '{print $2}')
    echo "Nama Peserta: $peserta_nama"
    read -p "Tarikh Kematian (YYYY-MM-DD): " tarikh
    read -p "Sebab Kematian              : " sebab
    id=$(auto_id $DATA_KEMATIAN)
    # id|peserta_id|tarikh|sebab
    echo "${id}|${peserta_id}|${tarikh}|${sebab}" >> $DATA_KEMATIAN
    echo "✅ Rekod kematian berjaya didaftarkan."
    pause
}

function senarai_kematian() {
    clear; line
    echo "SENARAI REKOD KEMATIAN"
    line
    if [ ! -s $DATA_KEMATIAN ]; then
        echo "Tiada rekod kematian."
    else
        printf "%-5s | %-20s | %-12s | %-40s\n" "ID" "Nama Peserta" "Tarikh" "Sebab"
        line
        while IFS='|' read -r id peserta_id tarikh sebab; do
            peserta=$(awk -F'|' -v pid="$peserta_id" '$1==pid{print $2}' $DATA_PESERTA)
            printf "%-5s | %-20s | %-12s | %-40s\n" "$id" "$peserta" "$tarikh" "$sebab"
        done < $DATA_KEMATIAN
    fi
    line; pause
}

function keluar() {
    clear
    echo "Terima kasih menggunakan sistem eKematian."
    exit 0
}

# Inisialisasi Fail
touch $DATA_PESERTA
touch $DATA_PERTUBUHAN
touch $DATA_WARIS
touch $DATA_TRANSAKSI
touch $DATA_KEMATIAN

# Mula Menu
menu
