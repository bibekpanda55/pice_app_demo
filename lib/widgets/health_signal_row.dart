import 'package:flutter/material.dart';

import '../models/supplier.dart';
import '../theme/pice_theme.dart';

/// One row inside the SupplierHealthCard. Shows an icon, the signal label,
/// the detail string, and a coloured dot reflecting the verdict.
class HealthSignalRow extends StatelessWidget {
  final HealthSignal signal;

  const HealthSignalRow({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(signal.icon, size: 18, color: PiceColors.inkSoft),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                signal.label,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: PiceColors.subtle,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                signal.detail,
                style: const TextStyle(
                  fontSize: 14,
                  color: PiceColors.ink,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: signal.verdict.color,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
