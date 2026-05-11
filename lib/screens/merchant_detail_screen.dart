import 'package:flutter/material.dart';

import '../models/supplier.dart';
import '../theme/pice_theme.dart';
import '../widgets/supplier_health_card.dart';

/// Mirrors Pice's merchant detail screen, with the new SupplierHealthCard
/// inserted between the Transaction History pill and the Import Invoices card.
class MerchantDetailScreen extends StatelessWidget {
  final Supplier supplier;

  const MerchantDetailScreen({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  children: [
                    _MerchantHeader(supplier: supplier),
                    const SizedBox(height: 16),
                    const _PanAndContactPill(),
                    const SizedBox(height: 16),
                    const _TransactionHistoryPill(),
                    const SizedBox(height: 18),
                    SupplierHealthCard(supplier: supplier),
                    const SizedBox(height: 18),
                    _PayingToBlock(supplier: supplier),
                    const SizedBox(height: 16),
                    const _ImportInvoicesCard(),
                  ],
                ),
              ),
            ),
            _PayBar(supplier: supplier),
          ],
        ),
      ),
    );
  }
}

class _MerchantHeader extends StatelessWidget {
  final Supplier supplier;

  const _MerchantHeader({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFE6EEF8),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.storefront_rounded,
            color: Color(0xFF4B6890),
            size: 28,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          supplier.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: PiceColors.ink,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 14,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFD64545),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.bolt_rounded, color: Colors.white, size: 9),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                supplier.legalName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: PiceColors.subtle,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PanAndContactPill extends StatelessWidget {
  const _PanAndContactPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PiceColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  const Text(
                    'PAN',
                    style: TextStyle(
                      fontSize: 11,
                      color: PiceColors.subtle,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: PiceColors.verified,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 11),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 14,
                          color: PiceColors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
              height: 60,
              child: VerticalDivider(width: 1, color: PiceColors.divider)),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2563EB),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: () {},
              child: const Text(
                'Add Contact',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionHistoryPill extends StatelessWidget {
  const _TransactionHistoryPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: PiceColors.divider),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.swap_horiz_rounded, size: 16, color: PiceColors.ink),
          SizedBox(width: 8),
          Text(
            'Transaction History',
            style: TextStyle(
              fontSize: 13,
              color: PiceColors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayingToBlock extends StatelessWidget {
  final Supplier supplier;

  const _PayingToBlock({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 15, color: PiceColors.ink),
            children: [
              const TextSpan(text: 'Paying to '),
              TextSpan(
                text: '${supplier.bankName} Bank',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF1F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_rounded,
                size: 14,
                color: Color(0xFFD64545),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '•••• ${supplier.accountLast4}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: PiceColors.ink,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: PiceColors.ink,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text(
                'View',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImportInvoicesCard extends StatelessWidget {
  const _ImportInvoicesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PiceColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Import Invoices',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: PiceColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'From GST Portal',
                  style: TextStyle(fontSize: 13, color: PiceColors.subtle),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: PiceColors.ink.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'Import Now',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: PiceColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 84,
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: PiceColors.mintBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: PiceColors.forestGreen,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayBar extends StatelessWidget {
  final Supplier supplier;

  const _PayBar({required this.supplier});

  @override
  Widget build(BuildContext context) {
    final risky = supplier.overall == HealthVerdict.risky;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (risky) {
                  showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Heads up'),
                      content: const Text(
                        'This supplier has risk signals. Pay only if you\'ve '
                        'verified the order separately.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showPayStub(context);
                          },
                          child: const Text('Pay anyway'),
                        ),
                      ],
                    ),
                  );
                } else {
                  _showPayStub(context);
                }
              },
              child: const Text('Pay Now'),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'pice ',
                style: TextStyle(
                  fontSize: 13,
                  color: PiceColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'protects',
                style: TextStyle(fontSize: 13, color: PiceColors.subtle),
              ),
              SizedBox(width: 4),
              Icon(Icons.verified_rounded,
                  color: PiceColors.verified, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  void _showPayStub(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment flow is out of scope for this prototype.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
