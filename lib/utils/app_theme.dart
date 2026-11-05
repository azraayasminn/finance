import 'package:flutter/material.dart';
import 'app_color.dart';

/// Tema global: font, kolom input, tombol, dan snackbar.
class AppTheme {
  AppTheme._();

  static OutlineInputBorder _border(Color color, {double width = 0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: width == 0
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );
  }

  static ThemeData get light {
    final textTheme = ThemeData.light().textTheme.apply(
          bodyColor: AppColor.ink,
          displayColor: AppColor.ink,
        );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColor.paper,
      colorScheme: const ColorScheme.light(
        primary: AppColor.primary,
        onPrimary: Colors.white,
        surface: AppColor.paper,
        onSurface: AppColor.ink,
        error: AppColor.expense,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.paper,
        foregroundColor: AppColor.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColor.ink,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColor.line,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColor.fill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(color: AppColor.muted),
        border: _border(Colors.transparent),
        enabledBorder: _border(Colors.transparent),
        focusedBorder: _border(AppColor.primary, width: 1.5),
        errorBorder: _border(AppColor.expense, width: 1.5),
        focusedErrorBorder: _border(AppColor.expense, width: 1.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColor.primary,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColor.sun,
        foregroundColor: AppColor.ink,
        elevation: 0,
        extendedTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColor.ink,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}