import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// CRUD transaksi di users/{uid}/transactions.
class TransactionService {
  CollectionReference<Map<String, dynamic>> get _col {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('transactions');
  }

  /// Real-time, urut dari tanggal terbaru.
  Stream<List<TransactionModel>> streamTransactions() {
    return _col.orderBy('tanggal', descending: true).snapshots().map(
          (snap) =>
              snap.docs.map((d) => TransactionModel.fromFirestore(d)).toList(),
        );
  }

  Future<void> add(TransactionModel transaksi) {
    return _col.add(transaksi.toMap());
  }

  Future<void> update(
    String id, {
    required double nominal,
    required String catatan,
  }) {
    return _col.doc(id).update({'nominal': nominal, 'catatan': catatan});
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}

import 'package:cloud_firestore/cloud_firestore.dart';

/// Data satu transaksi.
/// Disimpan di: users/{uid}/transactions/{id}
class TransactionModel {
  static const String pemasukan = 'Pemasukan';
  static const String pengeluaran = 'Pengeluaran';

  final String id;
  final String judul;
  final double nominal;
  final String tipe; // 'Pemasukan' atau 'Pengeluaran'
  final String catatan;
  final DateTime tanggal;

  const TransactionModel({
    required this.id,
    required this.judul,
    required this.nominal,
    required this.tipe,
    required this.catatan,
    required this.tanggal,
  });

  bool get isPemasukan => tipe == pemasukan;

  factory TransactionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return TransactionModel(
      id: doc.id,
      judul: data['judul'] ?? '',
      nominal: (data['nominal'] ?? 0).toDouble(),
      tipe: data['tipe'] ?? pengeluaran,
      catatan: data['catatan'] ?? '',
      tanggal: (data['tanggal'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'nominal': nominal,
      'tipe': tipe,
      'catatan': catatan,
      'tanggal': Timestamp.fromDate(tanggal),
    };
  }
}