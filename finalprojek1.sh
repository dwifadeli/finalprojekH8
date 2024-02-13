#!/bin/bash

# Array untuk menyimpan data mahasiswa
declare -a nama_mahasiswa
declare -a jurusan_mahasiswa
declare -a nilai_mahasiswa

function tampil_data_mahasiswa() {
  local n="${1:-Default}"  #Untuk menambahkan keterangan BARU saat setelah update data
  clear
  echo "Data Mahasiswa $n : " 
  echo "-----------------------------------------"
  echo "| Nama  |       Jurusan        | Nilai  |"
  echo "-----------------------------------------"
  for ((i=0; i<${#nama_mahasiswa[@]}; i++)); do
    echo "| ${nama_mahasiswa[$i]} | ${jurusan_mahasiswa[$i]} | ${nilai_mahasiswa[$i]} |"
  done
  echo "-----------------------------------------"
}

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

   tampil_data_mahasiswa "Setelah Pembaruan" 
    analisis_kelulusan
  else
    echo "Mahasiswa dengan nama $nama_update tidak ditemukan."
  fi
}

# Fungsi untuk menambahkan data mahasiswa
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
  tampil_data_mahasiswa "Setelah Pembaruan"
  analisis_kelulusan
}

# Fungsi untuk menganalisis data kelulusan mahasiswa
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
  echo "Analisis Data Kelulusan Mahasiswa:"
  echo "  ---------------------------------------------------------"
  echo "  | Jumlah Mahasiswa Lulus | Jumlah Mahasiswa Tidak Lulus | "
  echo "  ---------------------------------------------------------"
  echo "  |             $lulus          |             $tidak_lulus                | "
  echo "  ---------------------------------------------------------"
  echo " "
}

# Menu utama
# Menambahkan data awal
nama_mahasiswa=("Andi " "Lutfi" "Nadia")
jurusan_mahasiswa=("Teknik Informatika" "Sistem Informatika" "Teknik Elektro")
nilai_mahasiswa=(78 83 88)

tampil_data_mahasiswa
analisis_kelulusan

# Pertanyaan untuk mengupdate data mahasiswa
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