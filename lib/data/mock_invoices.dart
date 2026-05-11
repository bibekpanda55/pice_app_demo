import '../models/invoice.dart';

/// Anchor "today" so the demo's relative dates stay consistent across launches
/// and the disputed invoice always reads "disputed 7 days ago".
final DateTime _today = DateTime(2026, 5, 7);

/// Sample invoices spanning all 4 suppliers and all 3 statuses, so the
/// Invoices screen has a real story on first launch.
final List<Invoice> seedInvoices = [
  // Trashback India (s1) — healthy supplier
  Invoice(
    id: 'inv-001',
    supplierId: 's1',
    supplierName: 'Trashback India Private Limited',
    invoiceNumber: 'INV-2026-0142',
    amountInr: 24500,
    issueDate: _today.subtract(const Duration(days: 12)),
    dueDate: _today.add(const Duration(days: 18)),
    status: InvoiceStatus.pending,
  ),
  Invoice(
    id: 'inv-002',
    supplierId: 's1',
    supplierName: 'Trashback India Private Limited',
    invoiceNumber: 'INV-2026-0119',
    amountInr: 18750,
    issueDate: _today.subtract(const Duration(days: 38)),
    dueDate: _today.subtract(const Duration(days: 8)),
    status: InvoiceStatus.paid,
  ),

  // Aarav Distributors (s2) — watch
  Invoice(
    id: 'inv-003',
    supplierId: 's2',
    supplierName: 'Aarav Distributors',
    invoiceNumber: 'AAR/26-27/0091',
    amountInr: 56300,
    issueDate: _today.subtract(const Duration(days: 5)),
    dueDate: _today.add(const Duration(days: 25)),
    status: InvoiceStatus.pending,
  ),

  // Sunrise Pharma Wholesale (s3) — risky supplier; one disputed invoice
  Invoice(
    id: 'inv-004',
    supplierId: 's3',
    supplierName: 'Sunrise Pharma Wholesale',
    invoiceNumber: 'SP/2026/438',
    amountInr: 142800,
    issueDate: _today.subtract(const Duration(days: 22)),
    dueDate: _today.subtract(const Duration(days: 8)),
    status: InvoiceStatus.disputed,
    disputeNote:
        'Order short by 14 cartons. Supplier confirmed dispatch but '
        'never reconciled. Holding payment until counted.',
    disputedAt: _today.subtract(const Duration(days: 7)),
    notifiedSupplier: true,
  ),
  Invoice(
    id: 'inv-005',
    supplierId: 's3',
    supplierName: 'Sunrise Pharma Wholesale',
    invoiceNumber: 'SP/2026/451',
    amountInr: 87600,
    issueDate: _today.subtract(const Duration(days: 3)),
    dueDate: _today.add(const Duration(days: 27)),
    status: InvoiceStatus.pending,
  ),

  // Krishna Hardware Traders (s4) — healthy
  Invoice(
    id: 'inv-006',
    supplierId: 's4',
    supplierName: 'Krishna Hardware Traders',
    invoiceNumber: 'KH/2604',
    amountInr: 31200,
    issueDate: _today.subtract(const Duration(days: 9)),
    dueDate: _today.add(const Duration(days: 21)),
    status: InvoiceStatus.pending,
  ),
  Invoice(
    id: 'inv-007',
    supplierId: 's4',
    supplierName: 'Krishna Hardware Traders',
    invoiceNumber: 'KH/2588',
    amountInr: 12450,
    issueDate: _today.subtract(const Duration(days: 28)),
    dueDate: _today.subtract(const Duration(days: 2)),
    status: InvoiceStatus.paid,
  ),
];
