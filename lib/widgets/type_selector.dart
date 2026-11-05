import 'package:financeapps/models/transaction_model.dart';
import 'package:financeapps/utils/app_color.dart';
import 'package:flutter/material.dart';

/// Pilihan Pengeluaran / Pemasukan dalam dua tombol besar berwarna.
class TypeSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const TypeSelector({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _option(
            tipe: TransactionModel.pengeluaran,
            icon: Icons.arrow_upward_rounded,
            accent: AppColor.expense,
            soft: AppColor.expenseSoft,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _option(
            tipe: TransactionModel.pemasukan,
            icon: Icons.arrow_downward_rounded,
            accent: AppColor.income,
            soft: AppColor.incomeSoft,
          ),
        ),
      ],
    );
  }

  Widget _option({
    required String tipe,
    required IconData icon,
    required Color accent,
    required Color soft,
  }) {
    final selected = value == tipe;
    return GestureDetector(
      onTap: () => onChanged(tipe),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? soft : AppColor.fill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? accent : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: selected ? accent : AppColor.muted),
            const SizedBox(width: 8),
            Text(
              tipe,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? accent : AppColor.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}