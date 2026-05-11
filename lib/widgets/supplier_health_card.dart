import 'package:flutter/material.dart';

import '../models/supplier.dart';
import '../theme/pice_theme.dart';
import 'health_signal_row.dart';

/// Pre-payment supplier intelligence: GST filing recency, payment-history,
/// and BizCircle risk signals — combined into a single traffic-light card.
class SupplierHealthCard extends StatelessWidget {
  final Supplier supplier;

  const SupplierHealthCard({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    final verdict = supplier.overall;
    final color = verdict.color;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PiceColors.divider),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Verdict header
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(verdict.icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SUPPLIER HEALTH',
                      style: TextStyle(
                        fontSize: 11,
                        color: PiceColors.subtle,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      verdict.headline,
                      style: TextStyle(
                        fontSize: 18,
                        color: color,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: PiceColors.divider),
          const SizedBox(height: 6),
          // Signal rows
          for (int i = 0; i < supplier.signals.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: HealthSignalRow(signal: supplier.signals[i]),
            ),
            if (i != supplier.signals.length - 1)
              const Divider(height: 1, color: PiceColors.divider),
          ],
          const SizedBox(height: 8),
          // Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: PiceColors.mintSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 14, color: PiceColors.forestGreen),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Combined from GST portal, your past payments, and BizCircle.',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: PiceColors.forestGreen,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
