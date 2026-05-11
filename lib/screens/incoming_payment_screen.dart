import 'package:flutter/material.dart';

import '../models/payment_request.dart';
import '../theme/pice_theme.dart';
import '../utils/format.dart';

/// Buyer-side view of an incoming WhatsApp payment request. In production
/// this is the screen routed to by the deep-link handler; for the demo we
/// also reach it via "Preview as buyer" on the share screen.
class IncomingPaymentScreen extends StatelessWidget {
  final PaymentRequest request;

  const IncomingPaymentScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Text(
          'Payment Request',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: PiceColors.ink,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_rounded,
                            size: 13,
                            color: Color(0xFF1A8E48),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Opened from WhatsApp link',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF1A8E48),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _HeroCard(request: request),
                    const SizedBox(height: 16),
                    _DetailsCard(request: request),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: PiceColors.mintSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.shield_outlined,
                            size: 16,
                            color: PiceColors.forestGreen,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pice verifies the requesting business against '
                              'GSTIN and BizCircle before showing you this '
                              'screen. The amount and invoice cannot be '
                              'altered after the link was sent.',
                              style: TextStyle(
                                fontSize: 12,
                                color: PiceColors.forestGreen,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Paying ${inr(request.amountInr)} '
                              '— payment flow is out of scope for this prototype.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Text('Pay ${inr(request.amountInr)} via Pice'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: PiceColors.subtle,
                    ),
                    child: const Text('Not now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final PaymentRequest request;

  const _HeroCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PiceColors.divider),
      ),
      child: Column(
        children: [
          const Text(
            'YOU HAVE BEEN ASKED TO PAY',
            style: TextStyle(
              fontSize: 11,
              color: PiceColors.subtle,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            inr(request.amountInr),
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: PiceColors.ink,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 14,
                height: 14,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: PiceColors.verified,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 10,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  request.fromBusinessName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: PiceColors.ink,
                  ),
                ),
              ),
            ],
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
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final PaymentRequest request;

  const _DetailsCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    if (request.invoiceNumber != null) {
      rows.add(_row('Invoice', request.invoiceNumber!));
    }
    if (request.dueDate != null) {
      rows.add(_row('Due', shortDate(request.dueDate!)));
    }
    rows.add(_row('Reference', request.id));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PiceColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, color: PiceColors.divider),
              ),
          ],
          if (request.note != null && request.note!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: PiceColors.scaffoldBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NOTE FROM SENDER',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: PiceColors.subtle,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    request.note!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: PiceColors.ink,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(String k, String v) {
    return Row(
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
    );
  }
}
