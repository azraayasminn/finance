import 'package:flutter/material.dart';

/// Semua warna aplikasi ada di sini supaya gampang diubah.
class AppColor {
  AppColor._();

  // Dasar
  static const Color ink = Color(0xFF14213D); // teks utama
  static const Color paper = Color(0xFFFFFFFF); // latar layar
  static const Color fill = Color(0xFFF4F6FA); // latar kolom input
  static const Color line = Color(0xFFE8EAEF); // garis pemisah
  static const Color muted = Color(0xFF6B7385); // teks pendukung

  // Warna utama
  static const Color primary = Color(0xFF2F5BEA); // biru kobalt
  static const Color sun = Color(0xFFFFB020); // kuning, untuk tombol Catat

  // Pemasukan & pengeluaran
  static const Color income = Color(0xFF0B8F68); // hijau
  static const Color expense = Color(0xFFE03A5A); // merah muda

  // Warna lembut (latar ikon dan chip)
  static const Color primarySoft = Color(0xFFE8EEFF);
  static const Color incomeSoft = Color(0xFFE3F8F1);
  static const Color expenseSoft = Color(0xFFFDE8EC);

  // Teks di atas panel biru
  static const Color onPrimaryMuted = Color(0xFFD3DDFB);
}