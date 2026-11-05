import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Semua urusan akun: daftar, masuk, keluar, dan profil.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  /// Menunggu Firebase selesai memulihkan sesi (dipakai di splash).
  Future<User?> sessionUser() => _auth.authStateChanges().first;

  /// Buat akun, lalu simpan profil ke koleksi users.
  Future<void> register({
    required String nama,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _db.collection('users').doc(cred.user!.uid).set({
      'nama': nama,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> login({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() => _auth.signOut();

  /// Nama pemilik akun dari users/{uid}.
  Future<String> getNama() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return '';
    final doc = await _db.collection('users').doc(uid).get();
    return (doc.data()?['nama'] ?? '') as String;
  }

  /// Pesan error yang jelas dan menjelaskan solusinya.
  static String pesanError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email ini sudah terdaftar. Coba masuk atau pakai email lain.';
      case 'invalid-email':
        return 'Format email belum benar.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah. Pakai minimal 6 karakter.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau kata sandi salah.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi beberapa menit lagi.';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet. Periksa jaringanmu.';
      default:
        return 'Terjadi kesalahan. Coba lagi.';
    }
  }
}