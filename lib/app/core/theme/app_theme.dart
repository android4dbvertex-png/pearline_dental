import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF29B6F6);
  static const Color primaryDark = Color(0xFF0288D1);
  static const Color primaryLight = Color(0xFF81D4FA);
  static const Color accentRed = Color(0xFFE53935);
  static const Color cardBlue = Color(0xFF29B6F6);
  static const Color cardPink = Color(0xFFCE93D8);
  static const Color cardOrange = Color(0xFFFFB74D);
  static const Color cardPurple = Color(0xFF9575CD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF212121);
  static const Color textGrey = Color(0xFF757575);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: AppColors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppColors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppColors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          hintStyle: const TextStyle(color: AppColors.grey),
          labelStyle: const TextStyle(color: AppColors.textGrey),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.primary,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.primaryLight,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        useMaterial3: false,
      );
}
