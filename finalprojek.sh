#!/bin/bash

# Fungsi untuk menampilkan data mahasiswa
function tampil_data_mahasiswa() {
  echo "Data Mahasiswa:"
  echo "-----------------------------------------"
  echo "| Nama | Jurusan | Nilai |"
  echo "-----------------------------------------"
  cat data_mahasiswa.txt
  echo "-----------------------------------------"
}

# Fungsi untuk mencari mahasiswa
function cari_mahasiswa() {
  echo -n "Masukkan nama yang ingin dicari: "
  read nama_cari

  grep -i "$nama_cari" data_mahasiswa.txt
}

# Fungsi untuk menambahkan data mahasiswa
function input_dan_penambahan_data() {
  echo -n "Masukkan nama: "
  read nama_baru

  echo -n "Masukkan jurusan: "
  read jurusan_baru

  while true; do
    echo -n "Masukkan nilai: "
    read nilai_baru

    if [[ ! $nilai_baru =~ ^[0-9]+$ ]]; then
      echo "Nilai harus berupa angka."
    elif [[ $nilai_baru -lt 0 || $nilai_baru -gt 100 ]]; then
      echo "Nilai harus antara 0 dan 100."
    else
      break
    fi
  done

  echo "$nama_baru | $jurusan_baru | $nilai_baru" >> data_mahasiswa.txt
}

# Fungsi untuk menganalisis data kelulusan mahasiswa
function analisis_kelulusan() {
  lulus=$(awk -F'|' '$3 >= 80 {count++} END {print count}' data_mahasiswa.txt)
  total=$(wc -l < data_mahasiswa.txt)
  tidak_lulus=$((total - lulus))

  echo "Analisis Data Kelulusan Mahasiswa:"
  echo "  - Total Lulus: $lulus"
  echo "  - Total Tidak Lulus: $tidak_lulus"
}

# Cek apakah file data_mahasiswa.txt sudah ada, jika belum, buat file baru
touch data_mahasiswa.txt

# Menu utama
while true; do
  echo "Pilihan:"
  echo "1. Tampilkan Data Mahasiswa"
  echo "2. Cari Mahasiswa"
  echo "3. Tambah Data Mahasiswa"
  echo "4. Analisis Kelulusan"
  echo "5. Keluar"

  echo -n "Pilih menu (1-5): "
  read pilihan

  case $pilihan in
    1) tampil_data_mahasiswa ;;
    2) cari_mahasiswa ;;
    3) input_dan_penambahan_data ;;
    4) analisis_kelulusan ;;
    5) exit ;;
    *) echo "Pilihan tidak valid." ;;
  esac
done
