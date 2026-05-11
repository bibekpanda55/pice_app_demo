import 'package:flutter/material.dart';

import '../models/payment_request.dart';
import '../theme/pice_theme.dart';
import '../utils/format.dart';
import 'payment_request_share_screen.dart';

/// The user's own business as it appears on outgoing payment requests.
/// In a real Pice app this comes from the user's KYC profile.
const String _myBusinessName = 'Composio Retail Pvt Ltd';
const String _myGstin = '29COMPO1234A1Z5';

/// "Supplier-side" form: ask for the bits a buyer needs to know about an
/// incoming payment. Tapping Generate hands a [PaymentRequest] to the
/// share screen.
class RequestPaymentScreen extends StatefulWidget {
  const RequestPaymentScreen({super.key});

  @override
  State<RequestPaymentScreen> createState() => _RequestPaymentScreenState();
}

class _RequestPaymentScreenState extends State<RequestPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _invoiceCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime? _dueDate;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _invoiceCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _generate() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountCtrl.text.trim());
    final req = PaymentRequest(
      id: 'p-${DateTime.now().millisecondsSinceEpoch}',
      amountInr: amount,
      fromBusinessName: _myBusinessName,
      fromGstin: _myGstin,
      invoiceNumber:
          _invoiceCtrl.text.trim().isEmpty ? null : _invoiceCtrl.text.trim(),
      dueDate: _dueDate,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      createdAt: DateTime.now(),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => PaymentRequestShareScreen(request: req),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Text(
          'Request Payment',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: PiceColors.ink,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  children: [
                    const Text(
                      'Send a payment request to a buyer over WhatsApp. '
                      "They tap the link and pay through Pice — invoice "
                      'details, amount, and due date all carried in the link.',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: PiceColors.subtle,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _label('Amount'),
                    TextFormField(
                      controller: _amountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: PiceColors.ink,
                      ),
                      decoration: _decoration(
                        prefix: const Padding(
                          padding: EdgeInsets.only(
                              left: 12, right: 0, top: 12, bottom: 12),
                          child: Text(
                            '₹',
                            style: TextStyle(
                              fontSize: 22,
                              color: PiceColors.subtle,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        hint: '0',
                      ),
                      validator: (v) {
                        final n = double.tryParse((v ?? '').trim());
                        if (n == null || n <= 0) return 'Enter a valid amount';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    _label('Invoice number (optional)'),
                    TextFormField(
                      controller: _invoiceCtrl,
                      decoration: _decoration(hint: 'INV-2026-0142'),
                    ),
                    const SizedBox(height: 18),
                    _label('Due date (optional)'),
                    InkWell(
                      onTap: _pickDueDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: PiceColors.scaffoldBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: PiceColors.divider),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: PiceColors.subtle,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _dueDate == null
                                  ? 'Pick a date'
                                  : shortDate(_dueDate!),
                              style: TextStyle(
                                fontSize: 15,
                                color: _dueDate == null
                                    ? PiceColors.subtle
                                    : PiceColors.ink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            if (_dueDate != null)
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                onPressed: () =>
                                    setState(() => _dueDate = null),
                                icon: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: PiceColors.subtle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _label('Note for buyer (optional)'),
                    TextFormField(
                      controller: _noteCtrl,
                      maxLines: 3,
                      maxLength: 160,
                      decoration: _decoration(
                        hint: 'For Q1 reorder · part shipment',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _generate,
                    child: const Text('Generate Payment Request'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: PiceColors.subtle,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      );

  InputDecoration _decoration({String? hint, Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: PiceColors.subtle),
      filled: true,
      fillColor: PiceColors.scaffoldBg,
      prefixIcon: prefix,
      prefixIconConstraints: const BoxConstraints(maxWidth: 30),
      counterText: '',
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: PiceColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: PiceColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: PiceColors.navy, width: 1.5),
      ),
    );
  }
}
