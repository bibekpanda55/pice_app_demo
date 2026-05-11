/// A payment request a Pice user can generate as a "supplier" and share via
/// WhatsApp (or any messenger). The recipient — typically a buyer in
/// WhatsApp coordination — taps the link and lands on the buyer-side
/// confirm screen with everything pre-filled.
class PaymentRequest {
  final String id;
  final double amountInr;
  final String fromBusinessName;
  final String fromGstin;
  final String? invoiceNumber;
  final DateTime? dueDate;
  final String? note;
  final DateTime createdAt;

  const PaymentRequest({
    required this.id,
    required this.amountInr,
    required this.fromBusinessName,
    required this.fromGstin,
    this.invoiceNumber,
    this.dueDate,
    this.note,
    required this.createdAt,
  });

  /// Universal-link form: opens the page even if Pice isn't installed
  /// (a real implementation would serve a tiny preview page at this URL
  /// that App-Links / Universal-Links route into the app).
  String get deepLink {
    final qp = <String, String>{
      'ref': id,
      'amt': amountInr.toStringAsFixed(2),
      'from': fromBusinessName,
      'gst': fromGstin,
      if (invoiceNumber != null && invoiceNumber!.isNotEmpty)
        'inv': invoiceNumber!,
      if (dueDate != null) 'due': _isoDate(dueDate!),
      if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
    };
    final qs = qp.entries
        .map((e) =>
            '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return 'https://pice.app/pay?$qs';
  }

  /// Pre-composed message ready for the WhatsApp share intent.
  String get whatsappMessage {
    final amountStr = '₹${amountInr.toStringAsFixed(0)}';
    final lines = <String>[
      'Payment request from $fromBusinessName',
      if (invoiceNumber != null && invoiceNumber!.isNotEmpty)
        'Invoice: $invoiceNumber',
      'Amount: $amountStr',
      if (dueDate != null) 'Due: ${_humanDate(dueDate!)}',
      if (note != null && note!.trim().isNotEmpty) note!.trim(),
      '',
      'Pay securely via Pice:',
      deepLink,
    ];
    return lines.join('\n');
  }

  /// Reverses [deepLink] back into a model. Returns null if [input] is not a
  /// valid Pice payment-request URL. This is the parser a real receiver
  /// (e.g. an `app_links` listener) would call on every incoming link.
  static PaymentRequest? tryParse(String input) {
    Uri uri;
    try {
      uri = Uri.parse(input.trim());
    } catch (_) {
      return null;
    }
    final isHttps =
        uri.scheme == 'https' && uri.host == 'pice.app' && uri.path == '/pay';
    final isCustom = uri.scheme == 'pice' &&
        (uri.host == 'pay' || uri.path == 'pay' || uri.path == '/pay');
    if (!isHttps && !isCustom) return null;

    final qp = uri.queryParameters;
    final amount = double.tryParse(qp['amt'] ?? '');
    final from = qp['from'];
    final gst = qp['gst'];
    if (amount == null || from == null || gst == null) return null;

    DateTime? due;
    final dueRaw = qp['due'];
    if (dueRaw != null) {
      try {
        due = DateTime.parse(dueRaw);
      } catch (_) {}
    }

    return PaymentRequest(
      id: qp['ref'] ?? 'p-${DateTime.now().millisecondsSinceEpoch}',
      amountInr: amount,
      fromBusinessName: from,
      fromGstin: gst,
      invoiceNumber: qp['inv'],
      dueDate: due,
      note: qp['note'],
      createdAt: DateTime.now(),
    );
  }
}

String _isoDate(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

String _humanDate(DateTime d) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}
