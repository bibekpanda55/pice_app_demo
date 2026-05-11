import 'package:flutter/material.dart';

import '../theme/pice_theme.dart';

/// Traffic-light verdict for the supplier health card.
enum HealthVerdict { healthy, watch, risky }

extension HealthVerdictX on HealthVerdict {
  Color get color {
    switch (this) {
      case HealthVerdict.healthy:
        return PiceColors.verified;
      case HealthVerdict.watch:
        return PiceColors.amber;
      case HealthVerdict.risky:
        return PiceColors.red;
    }
  }

  /// Headline shown in the card (e.g. "Looks healthy").
  String get headline {
    switch (this) {
      case HealthVerdict.healthy:
        return 'Looks healthy';
      case HealthVerdict.watch:
        return 'Worth a second look';
      case HealthVerdict.risky:
        return 'Pause and verify';
    }
  }

  /// Compact label for list chips.
  String get shortLabel {
    switch (this) {
      case HealthVerdict.healthy:
        return 'Healthy';
      case HealthVerdict.watch:
        return 'Watch';
      case HealthVerdict.risky:
        return 'At risk';
    }
  }

  IconData get icon {
    switch (this) {
      case HealthVerdict.healthy:
        return Icons.verified_rounded;
      case HealthVerdict.watch:
        return Icons.error_outline_rounded;
      case HealthVerdict.risky:
        return Icons.warning_amber_rounded;
    }
  }
}

/// One row inside the supplier health card.
class HealthSignal {
  final IconData icon;
  final String label;
  final String detail;
  final HealthVerdict verdict;

  const HealthSignal({
    required this.icon,
    required this.label,
    required this.detail,
    required this.verdict,
  });
}

/// A supplier the user can pay through Pice.
class Supplier {
  final String id;
  final String name;
  final String legalName;
  final String bankName;
  final String accountLast4;
  final bool panVerified;
  final HealthVerdict overall;
  final List<HealthSignal> signals;

  const Supplier({
    required this.id,
    required this.name,
    required this.legalName,
    required this.bankName,
    required this.accountLast4,
    required this.panVerified,
    required this.overall,
    required this.signals,
  });
}
