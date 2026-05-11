import 'package:flutter/material.dart';

import 'screens/supplier_list_screen.dart';
import 'theme/pice_theme.dart';

void main() {
  runApp(const PiceDemoApp());
}

class PiceDemoApp extends StatelessWidget {
  const PiceDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pice_demo',
      debugShowCheckedModeBanner: false,
      theme: buildPiceTheme(),
      home: const SupplierListScreen(),
    );
  }
}
