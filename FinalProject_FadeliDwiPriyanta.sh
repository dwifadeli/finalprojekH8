#!/bin/bash

# Array untuk menyimpan data mahasiswa
declare -a nama_mahasiswa
declare -a jurusan_mahasiswa
declare -a nilai_mahasiswa

function tampil_data_mahasiswa() {
  local n="${1:-Awal}"  #Untuk menambahkan keterangan BARU saat setelah update data
  clear
  echo "Data Mahasiswa $n: " 
  echo "--------------------------------------------"
  echo "| Nama    |         Jurusan      | Nilai   |"
  echo "--------------------------------------------"

  # Inisialisasi lebar kolom
  nama_max_length=5
  jurusan_max_length=8
  nilai_max_length=5

  # Mendapatkan lebar maksimum untuk setiap kolom
  for ((i=0; i<${#nama_mahasiswa[@]}; i++)); do
    nama_length=${#nama_mahasiswa[$i]}
    jurusan_length=${#jurusan_mahasiswa[$i]}
    nilai_length=${#nilai_mahasiswa[$i]}
    if ((nama_length > nama_max_length)); then
      nama_max_length=$nama_length
    fi
    if ((jurusan_length > jurusan_max_length)); then
      jurusan_max_length=$jurusan_length
    fi
    if ((nilai_length > nilai_max_length)); then
      nilai_max_length=$nilai_length
    fi
  done

  # Menampilkan data dengan lebar kolom yang disesuaikan
  for ((i=0; i<${#nama_mahasiswa[@]}; i++)); do
    printf "| %-$(($nama_max_length+2))s | %-$(($jurusan_max_length+2))s | %-$(($nilai_max_length+2))s |\n" "${nama_mahasiswa[$i]}" "${jurusan_mahasiswa[$i]}" "${nilai_mahasiswa[$i]}"
  done

  echo "--------------------------------------------"
}

# Function to find index of student by name
function cari_index_mahasiswa() {
  nama_cari="$1"
  for ((i=0; i<${#nama_mahasiswa[@]}; i++)); do
    if [[ "${nama_mahasiswa[$i]}" == "$nama_cari" ]]; then
      echo "$i"
      return
    fi
  done
  echo "-1"
}

# Function to update student data
function update_mahasiswa() {
  echo -n "Masukkan nama mahasiswa yang ingin diupdate: "
  read nama_update

  index=$(cari_index_mahasiswa "$nama_update")
  if [[ $index != "-1" ]]; then
    echo "Data mahasiswa ditemukan:"
    echo "Nama: ${nama_mahasiswa[$index]}"
    echo "Jurusan: ${jurusan_mahasiswa[$index]}"
    echo "Nilai: ${nilai_mahasiswa[$index]}"

    echo -n "Apakah ingin mengubah jurusan mahasiswa? (Y/N): "
    read jawaban
    if [[ "$jawaban" == "Y" || "$jawaban" == "y" ]]; then
      echo -n "Masukkan jurusan baru: "
      read jurusan_baru
      jurusan_mahasiswa[$index]=$jurusan_baru
      echo "Jurusan mahasiswa berhasil diubah."
    fi

    tampil_data_mahasiswa "Jurusan telah diupdate, Data Mahasiswa terbaru" 
    analisis_kelulusan
  else
    echo "Mahasiswa dengan nama $nama_update tidak ditemukan."
  fi
}

# Function to add new student data
function tambah_mahasiswa() {
  echo -n "Masukkan nama mahasiswa baru: "
  read nama_baru
  echo -n "Masukkan jurusan mahasiswa baru: "
  read jurusan_baru
  echo -n "Masukkan nilai mahasiswa baru: "
  read nilai_baru

  # Validasi input nilai (antara 0-100)
  if [[ $nilai_baru -lt 0 || $nilai_baru -gt 100 ]]; then
    echo "Nilai harus antara 0 dan 100."
    return
  fi

  # Menambahkan data baru ke array
  nama_mahasiswa+=("$nama_baru")
  jurusan_mahasiswa+=("$jurusan_baru")
  nilai_mahasiswa+=("$nilai_baru")

  echo "Data mahasiswa baru berhasil ditambahkan."
  tampil_data_mahasiswa "setelah penambahan data baru"
  analisis_kelulusan
}

# Logika Kelulusan
function analisis_kelulusan() {
  lulus=0
  tidak_lulus=0

  for ((i=0; i<${#nilai_mahasiswa[@]}; i++)); do
    if (( ${nilai_mahasiswa[$i]} >= 80 )); then
      lulus=$((lulus + 1))
    else
      tidak_lulus=$((tidak_lulus + 1))
    fi
  done

  echo " "
  echo "Statistik Kelulusan:"
  echo "---------------------------------------------------------"
  echo "| Jumlah Mahasiswa Lulus | Jumlah Mahasiswa Tidak Lulus | "
  echo "---------------------------------------------------------"
  echo "|             $lulus          |             $tidak_lulus                | "
  echo "---------------------------------------------------------"
  echo " "
}

# List Awal
nama_mahasiswa=("Andi" "Lutfi" "Nadia")
jurusan_mahasiswa=("Teknik Informatika" "Sistem Informatika" "Teknik Elektro")
nilai_mahasiswa=(78 83 88)

tampil_data_mahasiswa
analisis_kelulusan

while true; do
  echo -n "Apakah ingin mengupdate data mahasiswa? (Y/N): "
  read jawaban

  if [[ $jawaban == "N" || $jawaban == "n" ]]; then
    echo -n "Apakah ingin menambahkan data mahasiswa baru? (Y/N): "
    read tambah

    if [[ $tambah == "Y" || $tambah == "y" ]]; then
      tambah_mahasiswa
    elif [[ $tambah == "N" || $tambah == "n" ]]; then
      break
    else
      echo "Pilihan tidak valid."
    fi
  elif [[ $jawaban == "Y" || $jawaban == "y" ]]; then
    update_mahasiswa
  else
    echo "Pilihan tidak valid."
  fi
done
