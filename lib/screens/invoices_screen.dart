import 'package:flutter/material.dart';

import '../models/invoice.dart';
import '../services/invoice_repository.dart';
import '../theme/pice_theme.dart';
import '../widgets/invoice_detail_sheet.dart';
import '../widgets/invoice_tile.dart';

/// Tabbed list of invoices: All / Pending / Disputed. Tapping any tile opens
/// a bottom-sheet detail view; the Disputed tab is the home of the new
/// "third state" introduced by this feature.
class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
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
          'Invoices',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: PiceColors.ink,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: ListenableBuilder(
            listenable: invoiceRepo,
            builder: (context, _) {
              final all = invoiceRepo.all().length;
              final pending =
                  invoiceRepo.byStatus(InvoiceStatus.pending).length;
              final disputed =
                  invoiceRepo.byStatus(InvoiceStatus.disputed).length;
              return TabBar(
                controller: _tabs,
                indicatorColor: PiceColors.navy,
                indicatorWeight: 2.5,
                labelColor: PiceColors.navy,
                unselectedLabelColor: PiceColors.subtle,
                labelStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
                tabs: [
                  Tab(text: 'All ($all)'),
                  Tab(text: 'Pending ($pending)'),
                  Tab(text: 'Disputed ($disputed)'),
                ],
              );
            },
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: invoiceRepo,
        builder: (context, _) {
          return TabBarView(
            controller: _tabs,
            children: [
              _list(invoiceRepo.all(), 'No invoices yet.'),
              _list(
                invoiceRepo.byStatus(InvoiceStatus.pending),
                'No pending invoices.',
              ),
              _list(
                invoiceRepo.byStatus(InvoiceStatus.disputed),
                'No disputed invoices.',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _list(List<Invoice> items, String emptyText) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            emptyText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: PiceColors.subtle,
            ),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final inv = items[i];
        return InvoiceTile(
          invoice: inv,
          onTap: () => showModalBottomSheet<void>(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) => InvoiceDetailSheet(invoice: inv),
          ),
        );
      },
    );
  }
}
