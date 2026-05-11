import 'package:flutter/material.dart';

import '../theme/pice_theme.dart';

/// State an invoice can be in within Pice.
///
/// `pending` and `paid` already exist in Pice today. `disputed` is the new
/// third state introduced by this feature — for invoices the buyer is
/// holding because of a real-world problem with the goods or service.
enum InvoiceStatus { pending, paid, disputed }

extension InvoiceStatusX on InvoiceStatus {
  Color get color {
    switch (this) {
      case InvoiceStatus.pending:
        return const Color(0xFF4B6890);
      case InvoiceStatus.paid:
        return PiceColors.verified;
      case InvoiceStatus.disputed:
        return PiceColors.amber;
    }
  }

  String get label {
    switch (this) {
      case InvoiceStatus.pending:
        return 'Pending';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.disputed:
        return 'Disputed';
    }
  }

  IconData get icon {
    switch (this) {
      case InvoiceStatus.pending:
        return Icons.schedule_rounded;
      case InvoiceStatus.paid:
        return Icons.check_circle_rounded;
      case InvoiceStatus.disputed:
        return Icons.flag_rounded;
    }
  }
}

/// A single invoice imported into Pice.
class Invoice {
  final String id;
  final String supplierId;
  final String supplierName;
  final String invoiceNumber;
  final double amountInr;
  final DateTime issueDate;
  final DateTime dueDate;
  final InvoiceStatus status;

  /// Reason the invoice was disputed (only set when `status == disputed`).
  final String? disputeNote;

  /// When the dispute flag was raised.
  final DateTime? disputedAt;

  /// Whether the supplier was notified through Pice when the dispute was raised.
  final bool notifiedSupplier;

  const Invoice({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.invoiceNumber,
    required this.amountInr,
    required this.issueDate,
    required this.dueDate,
    required this.status,
    this.disputeNote,
    this.disputedAt,
    this.notifiedSupplier = false,
  });

  Invoice copyWith({
    InvoiceStatus? status,
    String? disputeNote,
    DateTime? disputedAt,
    bool? notifiedSupplier,
    bool clearDispute = false,
  }) {
    return Invoice(
      id: id,
      supplierId: supplierId,
      supplierName: supplierName,
      invoiceNumber: invoiceNumber,
      amountInr: amountInr,
      issueDate: issueDate,
      dueDate: dueDate,
      status: status ?? this.status,
      disputeNote: clearDispute ? null : (disputeNote ?? this.disputeNote),
      disputedAt: clearDispute ? null : (disputedAt ?? this.disputedAt),
      notifiedSupplier:
          clearDispute ? false : (notifiedSupplier ?? this.notifiedSupplier),
    );
  }
}
