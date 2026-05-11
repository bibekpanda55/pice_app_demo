import 'package:flutter/material.dart';

import '../models/invoice.dart';
import '../services/invoice_repository.dart';
import '../theme/pice_theme.dart';
import '../utils/format.dart';
import 'dispute_invoice_sheet.dart';

/// Bottom sheet shown when an invoice tile is tapped. Surfaces details and
/// the actions available for the current invoice status — including the
/// "Flag as Disputed" entry point that opens the [DisputeInvoiceSheet].
class InvoiceDetailSheet extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetailSheet({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: PiceColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            invoice.supplierName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: PiceColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            invoice.invoiceNumber,
            style: const TextStyle(
              fontSize: 12,
              color: PiceColors.subtle,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            inr(invoice.amountInr),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: PiceColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          _kv('Issued', shortDate(invoice.issueDate)),
          _kv('Due', shortDate(invoice.dueDate)),
          _kv('Status', invoice.status.label, valueColor: invoice.status.color),
          if (invoice.status == InvoiceStatus.disputed &&
              invoice.disputedAt != null)
            _kv('Disputed', shortDate(invoice.disputedAt!)),
          if (invoice.status == InvoiceStatus.disputed &&
              invoice.disputeNote != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PiceColors.amber.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PiceColors.amber.withOpacity(0.30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.flag_rounded,
                        size: 14,
                        color: PiceColors.amber,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        invoice.notifiedSupplier
                            ? 'DISPUTE NOTE · SUPPLIER NOTIFIED'
                            : 'DISPUTE NOTE',
                        style: const TextStyle(
                          fontSize: 11,
                          color: PiceColors.amber,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    invoice.disputeNote!,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: PiceColors.inkSoft,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          ..._buildActions(context),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    switch (invoice.status) {
      case InvoiceStatus.pending:
        return [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Payment flow is out of scope for this prototype.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Pay Now'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                // Wait one frame so the previous sheet has fully dismissed
                // before opening the next one.
                await Future<void>.delayed(const Duration(milliseconds: 80));
                if (!context.mounted) return;
                await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => DisputeInvoiceSheet(invoice: invoice),
                );
              },
              icon: const Icon(
                Icons.flag_outlined,
                size: 18,
                color: PiceColors.amber,
              ),
              label: const Text('Flag as Disputed'),
              style: OutlinedButton.styleFrom(
                foregroundColor: PiceColors.amber,
                side: BorderSide(color: PiceColors.amber.withOpacity(0.5)),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ];
      case InvoiceStatus.disputed:
        return [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                invoiceRepo.markPaid(invoice.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Marked as paid (prototype).'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Mark as Paid'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                invoiceRepo.clearDispute(invoice.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Dispute cleared. Invoice back to pending.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: PiceColors.subtle,
                side: const BorderSide(color: PiceColors.divider),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Clear Dispute'),
            ),
          ),
        ];
      case InvoiceStatus.paid:
        return [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: PiceColors.ink,
                side: const BorderSide(color: PiceColors.divider),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Close'),
            ),
          ),
        ];
    }
  }

  Widget _kv(String k, String v, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              k,
              style: const TextStyle(
                fontSize: 12.5,
                color: PiceColors.subtle,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            v,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? PiceColors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
