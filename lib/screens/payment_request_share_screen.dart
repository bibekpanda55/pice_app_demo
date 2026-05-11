import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/payment_request.dart';
import '../theme/pice_theme.dart';
import '../utils/format.dart';
import 'incoming_payment_screen.dart';

/// Post-generation screen that hands the user three ways to ship the link:
/// open WhatsApp's share intent, copy the link to clipboard, or preview the
/// flow as a buyer for demoing without two devices.
class PaymentRequestShareScreen extends StatelessWidget {
  final PaymentRequest request;

  const PaymentRequestShareScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
        ),
        titleSpacing: 0,
        title: const Text(
          'Share Payment Request',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: PiceColors.ink,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          children: [
            _RequestSummaryCard(request: request),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: PiceColors.scaffoldBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: PiceColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PAYMENT LINK',
                    style: TextStyle(
                      fontSize: 11,
                      color: PiceColors.subtle,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    request.deepLink,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: PiceColors.inkSoft,
                      fontFamily: 'monospace',
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () => _shareViaWhatsApp(context),
              icon: const Icon(
                Icons.chat_rounded,
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Share on WhatsApp'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => _copyLink(context),
              icon: const Icon(
                Icons.link_rounded,
                size: 18,
                color: PiceColors.ink,
              ),
              label: const Text('Copy Link'),
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
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        IncomingPaymentScreen(request: request),
                  ),
                );
              },
              icon: const Icon(
                Icons.visibility_outlined,
                size: 18,
                color: PiceColors.navy,
              ),
              label: const Text('Preview as buyer'),
              style: OutlinedButton.styleFrom(
                foregroundColor: PiceColors.navy,
                side: BorderSide(color: PiceColors.navy.withOpacity(0.4)),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              "If the buyer hasn't installed Pice yet the link opens a "
              "lightweight web preview of the request, with a one-tap install "
              "into the same flow.",
              style: TextStyle(
                fontSize: 11.5,
                color: PiceColors.subtle,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareViaWhatsApp(BuildContext context) async {
    final encoded = Uri.encodeComponent(request.whatsappMessage);
    final waUri = Uri.parse('https://wa.me/?text=$encoded');
    try {
      final ok = await launchUrl(waUri, mode: LaunchMode.externalApplication);
      if (!context.mounted) return;
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not open WhatsApp. Use Copy Link instead.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open WhatsApp: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: request.deepLink));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Hero card summarising the generated request — same shape as the buyer
/// will see when they open the link.
class _RequestSummaryCard extends StatelessWidget {
  final PaymentRequest request;

  const _RequestSummaryCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PiceColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PAYMENT REQUESTED',
            style: TextStyle(
              fontSize: 11,
              color: PiceColors.subtle,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            inr(request.amountInr),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: PiceColors.ink,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'From ${request.fromBusinessName}',
            style: const TextStyle(
              fontSize: 14,
              color: PiceColors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'GSTIN ${request.fromGstin}',
            style: const TextStyle(
              fontSize: 11.5,
              color: PiceColors.subtle,
              letterSpacing: 0.5,
            ),
          ),
          if (request.invoiceNumber != null || request.dueDate != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: PiceColors.divider),
            const SizedBox(height: 12),
            if (request.invoiceNumber != null)
              _kv('Invoice', request.invoiceNumber!),
            if (request.dueDate != null) _kv('Due', shortDate(request.dueDate!)),
          ],
          if (request.note != null && request.note!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: PiceColors.mintSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                request.note!,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: PiceColors.forestGreen,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 70,
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
          Expanded(
            child: Text(
              v,
              style: const TextStyle(
                fontSize: 14,
                color: PiceColors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
