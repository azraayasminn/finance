import 'package:financeapps/utils/app_color.dart';
import 'package:financeapps/utils/formatter.dart';
import 'package:financeapps/models/transaction_model.dart';
import 'package:financeapps/services/transaction_service.dart';
import 'package:financeapps/widgets/brandmark.dart';

class DetailTransactionScreen extends StatefulWidget {
  final TransactionModel transaction;

  const DetailTransactionScreen({super.key, required this.transaction});

  @override
  State<DetailTransactionScreen> createState() =>
      _DetailTransactionScreenState();
}

class _DetailTransactionScreenState extends State<DetailTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = TransactionService();
  late final TextEditingController _nominal;
  late final TextEditingController _catatan;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nominal = TextEditingController(
      text: widget.transaction.nominal.toStringAsFixed(0),
    );
    _catatan = TextEditingController(text: widget.transaction.catatan);
  }

  @override
  void dispose() {
    _nominal.dispose();
    _catatan.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _service.update(
        widget.transaction.id,
        nominal: double.parse(_nominal.text),
        catatan: _catatan.text.trim(),
      );
      messenger.showSnackBar(
        const SnackBar(content: Text('Perubahan disimpan')),
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Perubahan belum tersimpan. Coba lagi.')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _delete() async {
    final yes = await CustomDialog.confirm(
      context,
      title: 'Hapus transaksi ini?',
      message: 'Data yang dihapus tidak bisa dikembalikan.',
      confirmText: 'Hapus',
      destructive: true,
    );
    if (!yes) return;
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _service.delete(widget.transaction.id);
      messenger.showSnackBar(
        const SnackBar(content: Text('Transaksi dihapus')),
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Transaksi belum terhapus. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.transaction;
    final accent = t.isPemasukan ? AppColor.income : AppColor.expense;
    final soft = t.isPemasukan ? AppColor.incomeSoft : AppColor.expenseSoft;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail transaksi')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: soft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.tipe,
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        Formatter.rupiahBertanda(t.nominal, t.tipe),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      t.judul,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Formatter.tanggal(t.tanggal),
                      style: const TextStyle(color: AppColor.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Ubah nominal atau catatan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nominal,
                      label: 'Nominal',
                      prefixText: 'Rp ',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Nominal wajib diisi';
                        }
                        if ((double.tryParse(v) ?? 0) <= 0) {
                          return 'Nominal harus lebih dari 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _catatan,
                      label: 'Catatan',
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: 'Simpan perubahan',
                loading: _loading,
                onPressed: _save,
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: _delete,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColor.expense,
                  ),
                  child: const Text('Hapus transaksi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}