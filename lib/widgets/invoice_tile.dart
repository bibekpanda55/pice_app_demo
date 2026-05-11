import 'package:flutter/material.dart';

import '../models/invoice.dart';
import '../theme/pice_theme.dart';
import '../utils/format.dart';

/// A row in the Invoices list. Shows supplier, invoice number, amount, and a
/// chip describing the invoice status (Pending / Paid / Disputed). For
/// disputed invoices the dispute note is previewed inline.
class InvoiceTile extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback onTap;

  const InvoiceTile({
    super.key,
    required this.invoice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = invoice.status.color;
    final overdue = invoice.status == InvoiceStatus.pending &&
        invoice.dueDate.isBefore(DateTime.now());

    final dueLine = switch (invoice.status) {
      InvoiceStatus.paid => 'Paid · was due ${shortDate(invoice.dueDate)}',
      InvoiceStatus.disputed => invoice.disputedAt != null
          ? 'Disputed ${agoLabel(invoice.disputedAt!)}'
          : 'Disputed',
      InvoiceStatus.pending => overdue
          ? 'Overdue · was due ${shortDate(invoice.dueDate)}'
          : 'Due ${shortDate(invoice.dueDate)}',
    };

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: PiceColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      invoice.supplierName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: PiceColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(status: invoice.status),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      invoice.invoiceNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: PiceColors.subtle,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    inr(invoice.amountInr),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: PiceColors.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                dueLine,
                style: TextStyle(
                  fontSize: 12,
                  color: invoice.status == InvoiceStatus.disputed || overdue
                      ? statusColor
                      : PiceColors.subtle,
                  fontWeight:
                      overdue ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (invoice.status == InvoiceStatus.disputed &&
                  invoice.disputeNote != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: PiceColors.amber.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: PiceColors.amber.withOpacity(0.30),
                    ),
                  ),
                  child: Text(
                    invoice.disputeNote!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: PiceColors.inkSoft,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final InvoiceStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
