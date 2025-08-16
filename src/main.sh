#!/bin/bash

# eKematian - Sistem Pengurusan Maklumat Kematian

DATA_FILE="data_kematian.txt"

function menu() {
    echo "==== eKematian ===="
    echo "1. Daftar Kematian"
    echo "2. Cari Rekod Kematian"
    echo "3. Senarai Semua Rekod"
    echo "0. Keluar"
    echo -n "Pilihan anda: "
    read pilihan
    case $pilihan in
        1) daftar_kematian ;; 
        2) cari_rekod ;; 
        3) senarai_rekod ;; 
        0) exit 0 ;; 
        *) echo "Pilihan salah." ;; 
    esac
    echo ""
    menu
}

function daftar_kematian() {
    echo "Masukkan Nama Si Mati:"
    read nama
    echo "Masukkan No. KP:"
    read nokp
    echo "Masukkan Tarikh Kematian (YYYY-MM-DD):"
    read tarikh
    echo "$nama|$nokp|$tarikh" >> $DATA_FILE
    echo "Rekod berjaya didaftarkan."
}

function cari_rekod() {
    echo "Masukkan No. KP yang ingin dicari:"
    read nokp
    rekod=$(grep "$nokp" $DATA_FILE)
    if [ -z "$rekod" ]; then
        echo "Rekod tidak dijumpai."
    else
        echo "Rekod dijumpai: $rekod"
    fi
}

function senarai_rekod() {
    if [ ! -f $DATA_FILE ]; then
        echo "Tiada rekod."
        return
    fi
    echo "==== Senarai Rekod Kematian ===="
    cat $DATA_FILE
}

# Cipta fail data jika belum wujud
touch $DATA_FILE

menu
