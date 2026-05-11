import 'package:flutter/material.dart';

import '../models/supplier.dart';

/// Sample suppliers used to populate the demo. Designed to cover all three
/// verdicts so screenshots tell a complete story.
const List<Supplier> mockSuppliers = [
  Supplier(
    id: 's1',
    name: 'Trashback India Private Limited',
    legalName: 'TRASHBACK INDIA PRIVATE LIMITED',
    bankName: 'ICICI',
    accountLast4: '3749',
    panVerified: true,
    overall: HealthVerdict.healthy,
    signals: [
      HealthSignal(
        icon: Icons.receipt_long_rounded,
        label: 'GST filing',
        detail: 'Filed 12 days ago',
        verdict: HealthVerdict.healthy,
      ),
      HealthSignal(
        icon: Icons.history_rounded,
        label: 'Your payment history',
        detail: 'On time on all 8 payments',
        verdict: HealthVerdict.healthy,
      ),
      HealthSignal(
        icon: Icons.shield_outlined,
        label: 'BizCircle signals',
        detail: '0 flags • verified by 3 buyers',
        verdict: HealthVerdict.healthy,
      ),
    ],
  ),
  Supplier(
    id: 's2',
    name: 'Aarav Distributors',
    legalName: 'AARAV DISTRIBUTORS LLP',
    bankName: 'HDFC',
    accountLast4: '8821',
    panVerified: true,
    overall: HealthVerdict.watch,
    signals: [
      HealthSignal(
        icon: Icons.receipt_long_rounded,
        label: 'GST filing',
        detail: 'Filed 38 days ago',
        verdict: HealthVerdict.watch,
      ),
      HealthSignal(
        icon: Icons.history_rounded,
        label: 'Your payment history',
        detail: 'Avg 4 days late over 6 payments',
        verdict: HealthVerdict.watch,
      ),
      HealthSignal(
        icon: Icons.shield_outlined,
        label: 'BizCircle signals',
        detail: '0 flags • limited network history',
        verdict: HealthVerdict.healthy,
      ),
    ],
  ),
  Supplier(
    id: 's3',
    name: 'Sunrise Pharma Wholesale',
    legalName: 'SUNRISE PHARMA WHOLESALE PVT LTD',
    bankName: 'AXIS',
    accountLast4: '5012',
    panVerified: true,
    overall: HealthVerdict.risky,
    signals: [
      HealthSignal(
        icon: Icons.receipt_long_rounded,
        label: 'GST filing',
        detail: 'Last filed 96 days ago',
        verdict: HealthVerdict.risky,
      ),
      HealthSignal(
        icon: Icons.history_rounded,
        label: 'Your payment history',
        detail: '3 of last 5 payments delayed 10+ days',
        verdict: HealthVerdict.watch,
      ),
      HealthSignal(
        icon: Icons.shield_outlined,
        label: 'BizCircle signals',
        detail: '2 buyers reported delivery issues',
        verdict: HealthVerdict.risky,
      ),
    ],
  ),
  Supplier(
    id: 's4',
    name: 'Krishna Hardware Traders',
    legalName: 'KRISHNA HARDWARE TRADERS',
    bankName: 'SBI',
    accountLast4: '4476',
    panVerified: true,
    overall: HealthVerdict.healthy,
    signals: [
      HealthSignal(
        icon: Icons.receipt_long_rounded,
        label: 'GST filing',
        detail: 'Filed 5 days ago',
        verdict: HealthVerdict.healthy,
      ),
      HealthSignal(
        icon: Icons.history_rounded,
        label: 'Your payment history',
        detail: 'On time on all 14 payments',
        verdict: HealthVerdict.healthy,
      ),
      HealthSignal(
        icon: Icons.shield_outlined,
        label: 'BizCircle signals',
        detail: '0 flags • verified by 7 buyers',
        verdict: HealthVerdict.healthy,
      ),
    ],
  ),
];
