import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
      ),

      cardColor: AppColors.card,

      dividerColor: AppColors.divider,

      textTheme: GoogleFonts.poppinsTextTheme(
        base.textTheme,
      ).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),

      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),

        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}