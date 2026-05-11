import 'package:flutter/material.dart';

/// Color tokens taken from the live Pice app screenshots.
class PiceColors {
  static const navy = Color(0xFF0F1F47);
  static const navyDeep = Color(0xFF0A1733);

  // Backgrounds
  static const scaffoldBg = Color(0xFFF7FAF8);
  static const mintBg = Color(0xFFE8F5EE);
  static const mintSoft = Color(0xFFEAF7F0);

  // Greens
  static const forestGreen = Color(0xFF1F5C3D);
  static const verified = Color(0xFF2BB673);

  // Status
  static const amber = Color(0xFFF0A53A);
  static const red = Color(0xFFE54848);

  // Text
  static const ink = Color(0xFF111827);
  static const inkSoft = Color(0xFF374151);
  static const subtle = Color(0xFF6B7280);

  // Lines
  static const divider = Color(0xFFE5E7EB);
}

ThemeData buildPiceTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: PiceColors.navy,
    brightness: Brightness.light,
  ).copyWith(
    primary: PiceColors.navy,
    onPrimary: Colors.white,
    secondary: PiceColors.verified,
    surface: Colors.white,
    onSurface: PiceColors.ink,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: PiceColors.scaffoldBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: PiceColors.ink,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: PiceColors.navy,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFCBD5E1),
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    dividerColor: PiceColors.divider,
  );
}
