import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'transaction_model.dart';
import 'transaction_service.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';
import 'type_selector.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nominal = TextEditingController();
  final _judul = TextEditingController();
  final _catatan = TextEditingController();
  String _tipe = TransactionModel.pengeluaran;
  bool _loading = false;

  @override
  void dispose() {
    _nominal.dispose();
    _judul.dispose();
    _catatan.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await TransactionService().add(
        TransactionModel(
          id: '',
          judul: _judul.text.trim(),
          nominal: double.parse(_nominal.text),
          tipe: _tipe,
          catatan: _catatan.text.trim(),
          tanggal: DateTime.now(),
        ),
      );
      messenger.showSnackBar(
        const SnackBar(content: Text('Transaksi disimpan')),
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Transaksi belum tersimpan. Coba lagi.')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catat transaksi')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TypeSelector(
                  value: _tipe,
                  onChanged: (v) => setState(() => _tipe = v),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _nominal,
                  label: 'Nominal',
                  prefixText: 'Rp ',
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Nominal wajib diisi';
                    if ((double.tryParse(v) ?? 0) <= 0) {
                      return 'Nominal harus lebih dari 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _judul,
                  label: 'Judul transaksi',
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Judul wajib diisi'
                      : null,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _catatan,
                  label: 'Catatan (opsional)',
                  maxLines: 2,
                ),
                const SizedBox(height: 28),
                CustomButton(
                  label: 'Simpan transaksi',
                  loading: _loading,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}