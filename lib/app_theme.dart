import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const terracotta = Color(0xFFC94F32);
  static const terracottaDark = Color(0xFF963B28);
  static const cream = Color(0xFFFFF8EE);
  static const ink = Color(0xFF2B211D);
  static const muted = Color(0xFF786A61);
  static const avocado = Color(0xFF587044);
  static const yellow = Color(0xFFF3B544);
  static const surface = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.terracotta,
      brightness: Brightness.light,
      surface: AppColors.cream,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        primary: AppColors.terracotta,
        onPrimary: Colors.white,
        secondary: AppColors.avocado,
        onSurface: AppColors.ink,
      ),
      scaffoldBackgroundColor: AppColors.cream,
      fontFamily: 'Avenir',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.terracotta.withOpacity(.14),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
    );
  }
}
