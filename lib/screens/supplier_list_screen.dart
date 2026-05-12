import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          itemCount: mockSuppliers.length + 2,
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
            if (i == mockSuppliers.length + 1) {
              return const _BuiltByFooter();
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

/// Compact "about the author" card below the supplier list. Surfaces
/// LinkedIn, GitHub, the proposal PDF, and the demo video, each as a
/// tappable pill that opens the URL in the user's default browser.
class _BuiltByFooter extends StatelessWidget {
  const _BuiltByFooter();

  static const _linkedIn =
      'https://www.linkedin.com/in/bibek-panda-a8ba66174/';
  static const _github = 'https://github.com/bibekpanda55/';
  static const _resume =
      'https://drive.google.com/file/d/1dW6BQ-PvCPLQE8MNUN5AbWdqr3rLpgyP/view?usp=sharing';
  static const _proposalPdf =
      'https://drive.google.com/file/d/1UH_Yeoi4SQh8AYO4pzlhYJuP-pTcX7BO/view?usp=sharing';
  static const _demoVideoPart1 =
      'https://www.loom.com/share/651756d86d8c4ac7851e3c545f3eef89';
  static const _demoVideoPart2 =
      'https://www.loom.com/share/113f0058c0f34371bf8543a68c0ad55f';
  static const _androidApk =
      'https://drive.google.com/file/d/15QFWgCYWSOYQYWpCnizXSAzIlAiePZkS/view?usp=sharing';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 4),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PiceColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'BUILT BY',
              style: TextStyle(
                fontSize: 11,
                color: PiceColors.subtle,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Bibek Panda',
              style: TextStyle(
                fontSize: 17,
                color: PiceColors.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'A portfolio prototype exploring three feature additions to Pice.',
              style: TextStyle(
                fontSize: 12.5,
                color: PiceColors.subtle,
                height: 1.4,
              ),
            ),
            SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _LinkChip(
                  icon: Icons.business_center_rounded,
                  label: 'LinkedIn',
                  url: _linkedIn,
                ),
                _LinkChip(
                  icon: Icons.code_rounded,
                  label: 'GitHub',
                  url: _github,
                ),
                _LinkChip(
                  icon: Icons.article_rounded,
                  label: 'Resume',
                  url: _resume,
                ),
                _LinkChip(
                  icon: Icons.picture_as_pdf_rounded,
                  label: 'Proposal PDF',
                  url: _proposalPdf,
                ),
                _LinkChip(
                  icon: Icons.play_circle_outline_rounded,
                  label: 'Demo · pt 1',
                  url: _demoVideoPart1,
                ),
                _LinkChip(
                  icon: Icons.play_circle_outline_rounded,
                  label: 'Demo · pt 2',
                  url: _demoVideoPart2,
                ),
                _LinkChip(
                  icon: Icons.android_rounded,
                  label: 'Android APK',
                  url: _androidApk,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const _LinkChip({
    required this.icon,
    required this.label,
    required this.url,
  });

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse(url);
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!context.mounted) return;
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $label.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open $label.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _open(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: PiceColors.divider),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: PiceColors.navy),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: PiceColors.navy,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.open_in_new_rounded,
                size: 12,
                color: PiceColors.subtle,
              ),
            ],
          ),
        ),
      ),
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
