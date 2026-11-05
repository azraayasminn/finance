import 'package:flutter/material.dart';
import 'transaction_model.dart';
import 'auth_service.dart';
import 'transaction_service.dart';
import 'app_color.dart';
import 'formatter.dart';
import 'custom_dialog.dart';
import 'empty_state.dart';
import 'stat_card.dart';
import 'transaction_card.dart';
import 'add_transaction_screen.dart';
import 'detail_transaction_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _auth = AuthService();
  late final Stream<List<TransactionModel>> _stream;
  String _nama = '';

  @override
  void initState() {
    super.initState();
    _stream = TransactionService().streamTransactions();
    _auth.getNama().then((nama) {
      if (mounted) setState(() => _nama = nama);
    });
  }

  Future<void> _logout() async {
    final yes = await CustomDialog.confirm(
      context,
      title: 'Keluar dari akun?',
      message: 'Kamu perlu masuk lagi untuk membuka catatanmu.',
      confirmText: 'Keluar',
      destructive: true,
    );
    if (!yes) return;
    await _auth.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Catat'),
      ),
      body: SafeArea(
        child: StreamBuilder<List<TransactionModel>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const EmptyState(
                icon: Icons.cloud_off_rounded,
                title: 'Data belum bisa dimuat',
                message: 'Periksa koneksi internetmu, lalu buka ulang aplikasi.',
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final list = snapshot.data!;
            double masuk = 0;
            double keluar = 0;
            for (final t in list) {
              if (t.isPemasukan) {
                masuk += t.nominal;
              } else {
                keluar += t.nominal;
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildSummary(masuk, keluar, list.length),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 4),
                  child: Text(
                    'Riwayat',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                Expanded(
                  child: list.isEmpty
                      ? const EmptyState(
                          icon: Icons.receipt_long_rounded,
                          title: 'Belum ada transaksi',
                          message: 'Ketuk Catat untuk menambah transaksi pertamamu.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, i) => TransactionCard(
                            transaction: list[i],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailTransactionScreen(
                                  transaction: list[i],
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat datang,',
                  style: TextStyle(color: AppColor.muted, fontSize: 14),
                ),
                Text(
                  _nama.isEmpty ? '...' : _nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _logout,
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout_rounded, color: AppColor.muted),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(double masuk, double keluar, int jumlah) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saldo',
              style: TextStyle(
                color: AppColor.onPrimaryMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                Formatter.rupiah(masuk - keluar),
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Pemasukan',
                    value: Formatter.rupiah(masuk),
                    background: AppColor.incomeSoft,
                    accent: AppColor.income,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatCard(
                    label: 'Pengeluaran',
                    value: Formatter.rupiah(keluar),
                    background: AppColor.expenseSoft,
                    accent: AppColor.expense,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              '$jumlah transaksi tercatat',
              style: const TextStyle(
                color: AppColor.onPrimaryMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}