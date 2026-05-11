import 'package:flutter/material.dart';

import '../data/mock_suppliers.dart';
import '../models/invoice.dart';
import '../models/supplier.dart';
import '../services/invoice_repository.dart';
import '../theme/pice_theme.dart';
import 'invoices_screen.dart';
import 'merchant_detail_screen.dart';
import 'request_payment_screen.dart';

/// Entry screen of the demo. Lists the sample suppliers and provides a
/// receipt icon in the AppBar (with a disputed-count badge) that opens the
/// Invoices screen.
class SupplierListScreen extends StatelessWidget {
  const SupplierListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        toolbarHeight: 64,
        title: const Text(
          'Suppliers',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: PiceColors.ink,
          ),
        ),
        actions: const [
          _InvoicesIconButton(),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
          itemCount: mockSuppliers.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            if (i == 0) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 4, top: 4),
                child: Text(
                  'Tap a supplier to see their health card before paying.',
                  style: TextStyle(
                    fontSize: 14,
                    color: PiceColors.subtle,
                    height: 1.4,
                  ),
                ),
              );
            }
            return _SupplierTile(supplier: mockSuppliers[i - 1]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const RequestPaymentScreen(),
          ),
        ),
        icon: const Icon(Icons.qr_code_2_rounded),
        label: const Text(
          'Request',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: PiceColors.navy,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _InvoicesIconButton extends StatelessWidget {
  const _InvoicesIconButton();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: invoiceRepo,
      builder: (context, _) {
        final disputed = invoiceRepo.byStatus(InvoiceStatus.disputed).length;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              tooltip: 'Invoices',
              icon: const Icon(
                Icons.receipt_long_rounded,
                color: PiceColors.ink,
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const InvoicesScreen(),
                ),
              ),
            ),
            if (disputed > 0)
              Positioned(
                top: 6,
                right: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: PiceColors.amber,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  constraints: const BoxConstraints(minWidth: 18),
                  child: Text(
                    '$disputed',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SupplierTile extends StatelessWidget {
  final Supplier supplier;

  const _SupplierTile({required this.supplier});

  @override
  Widget build(BuildContext context) {
    final color = supplier.overall.color;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => MerchantDetailScreen(supplier: supplier),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: PiceColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6EEF8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: Color(0xFF4B6890),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: PiceColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${supplier.bankName} • •••• ${supplier.accountLast4}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: PiceColors.subtle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      supplier.overall.shortLabel,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
