import 'package:flutter/foundation.dart';

import '../data/mock_invoices.dart';
import '../models/invoice.dart';

/// In-memory store for invoices. Backed by [seedInvoices] for the demo.
///
/// Every mutation calls [notifyListeners] so any [ListenableBuilder] watching
/// this repository (e.g. the Invoices screen tabs and the supplier list
/// AppBar badge) refreshes automatically.
class InvoiceRepository extends ChangeNotifier {
  InvoiceRepository(List<Invoice> seed) : _invoices = List<Invoice>.of(seed);

  final List<Invoice> _invoices;

  List<Invoice> all() => List<Invoice>.unmodifiable(_invoices);

  List<Invoice> byStatus(InvoiceStatus status) =>
      _invoices.where((i) => i.status == status).toList();

  List<Invoice> bySupplier(String supplierId) =>
      _invoices.where((i) => i.supplierId == supplierId).toList();

  int countDisputed() =>
      _invoices.where((i) => i.status == InvoiceStatus.disputed).length;

  void markDisputed(
    String invoiceId, {
    required String note,
    required bool notifySupplier,
  }) {
    final i = _invoices.indexWhere((x) => x.id == invoiceId);
    if (i == -1) return;
    _invoices[i] = _invoices[i].copyWith(
      status: InvoiceStatus.disputed,
      disputeNote: note,
      disputedAt: DateTime.now(),
      notifiedSupplier: notifySupplier,
    );
    notifyListeners();
  }

  void clearDispute(String invoiceId) {
    final i = _invoices.indexWhere((x) => x.id == invoiceId);
    if (i == -1) return;
    _invoices[i] = _invoices[i].copyWith(
      status: InvoiceStatus.pending,
      clearDispute: true,
    );
    notifyListeners();
  }

  void markPaid(String invoiceId) {
    final i = _invoices.indexWhere((x) => x.id == invoiceId);
    if (i == -1) return;
    _invoices[i] = _invoices[i].copyWith(
      status: InvoiceStatus.paid,
      clearDispute: true,
    );
    notifyListeners();
  }
}

/// Process-wide singleton used by the demo screens. In a production app this
/// would be provided through a DI container (Riverpod, Provider, etc.).
final InvoiceRepository invoiceRepo = InvoiceRepository(seedInvoices);
