import 'package:flutter/material.dart';

import '../models/invoice.dart';
import '../services/invoice_repository.dart';
import '../theme/pice_theme.dart';

/// Bottom sheet that lets the user mark an invoice as disputed with a short
/// note and an optional toggle to notify the supplier through Pice.
class DisputeInvoiceSheet extends StatefulWidget {
  final Invoice invoice;

  const DisputeInvoiceSheet({super.key, required this.invoice});

  @override
  State<DisputeInvoiceSheet> createState() => _DisputeInvoiceSheetState();
}

class _DisputeInvoiceSheetState extends State<DisputeInvoiceSheet> {
  final TextEditingController _ctrl = TextEditingController();
  bool _notify = true;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _ctrl.text.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
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
            const Text(
              'Flag this invoice as disputed',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: PiceColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.invoice.supplierName} · ${widget.invoice.invoiceNumber}',
              style: const TextStyle(fontSize: 13, color: PiceColors.subtle),
            ),
            const SizedBox(height: 18),
            const Text(
              "What's the issue?",
              style: TextStyle(
                fontSize: 13,
                color: PiceColors.subtle,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _ctrl,
              maxLines: 4,
              maxLength: 240,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText:
                    'Order short by 14 cartons. Awaiting supplier reconciliation.',
                hintStyle: const TextStyle(
                  color: PiceColors.subtle,
                  fontSize: 13.5,
                ),
                filled: true,
                fillColor: PiceColors.scaffoldBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: PiceColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: PiceColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: PiceColors.navy,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: PiceColors.scaffoldBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notify supplier through Pice',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: PiceColors.ink,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "They'll see the note in their Pice dashboard.",
                          style: TextStyle(
                            fontSize: 11.5,
                            color: PiceColors.subtle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _notify,
                    onChanged: (v) => setState(() => _notify = v),
                    activeColor: PiceColors.verified,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSubmit
                    ? () {
                        invoiceRepo.markDisputed(
                          widget.invoice.id,
                          note: _ctrl.text.trim(),
                          notifySupplier: _notify,
                        );
                        Navigator.of(context).pop(true);
                      }
                    : null,
                child: const Text('Flag as Disputed'),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: PiceColors.subtle,
                ),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
