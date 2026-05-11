# pice_demo

A Flutter prototype for Android and iOS that demonstrates the **Supplier Health Score** — a pre-payment intelligence card surfaced on the merchant detail screen, combining GST filing recency, your payment history with the supplier, and BizCircle risk signals into a single traffic-light verdict.

## Run

```bash
flutter create --platforms=android,ios .   # regenerates native build files (Gradle wrapper, Xcode project, etc.)
flutter pub get
flutter run
```

## What's in the demo

- **Suppliers list** — 4 sample suppliers with traffic-light chips (Healthy / Watch / At risk).
- **Merchant detail screen** — mirrors Pice's existing layout (avatar, big name, all-caps legal name, PAN Verified pill, Transaction History pill, Pay Now CTA, `pice protects` mark).
- **SupplierHealthCard** — the new component, inserted between Transaction History and Import Invoices.
- For risky suppliers, tapping Pay Now triggers a "Heads up" confirmation dialog.

## Layout

```
pice_demo/
├── pubspec.yaml
├── analysis_options.yaml
├── lib/
│   ├── main.dart
│   ├── theme/pice_theme.dart
│   ├── models/supplier.dart
│   ├── data/mock_suppliers.dart
│   ├── screens/
│   │   ├── supplier_list_screen.dart
│   │   └── merchant_detail_screen.dart
│   └── widgets/
│       ├── health_signal_row.dart
│       └── supplier_health_card.dart
├── test/widget_test.dart
├── android/   (platform stub)
└── ios/       (platform stub)
```
