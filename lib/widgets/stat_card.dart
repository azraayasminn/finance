import 'package:financeapps/utils/app_color.dart';
import 'package:flutter/material.dart';

/// Kotak kecil berisi label dan angka (Pemasukan / Pengeluaran).
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color background;
  final Color accent;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.background,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColor.muted,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}