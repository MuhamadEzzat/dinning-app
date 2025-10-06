import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Light Theme Text Styles
  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.lightText,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.lightText,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.lightText,
    ),
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.lightText,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.lightText,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.lightText,
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.lightText,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.lightText,
    ),
    titleSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.lightText,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.lightText,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.lightText,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.lightTextSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.lightText,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.lightText,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextSecondary,
    ),
  );

  // Dark Theme Text Styles
  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.darkText,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.darkText,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.darkText,
    ),
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.darkText,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.darkText,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.darkText,
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.darkText,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.darkText,
    ),
    titleSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.darkText,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.darkText,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.darkText,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.darkTextSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.darkText,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.darkText,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextSecondary,
    ),
  );

  // Kids Theme Text Styles (Larger fonts, playful)
  static const TextTheme kidsTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: AppColors.kidsText,
      letterSpacing: 1.2,
    ),
    displayMedium: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.kidsText,
      letterSpacing: 1.0,
    ),
    displaySmall: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.kidsText,
      letterSpacing: 0.8,
    ),
    headlineLarge: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w600,
      color: AppColors.kidsText,
      letterSpacing: 0.6,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.kidsText,
      letterSpacing: 0.4,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.kidsText,
      letterSpacing: 0.2,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.kidsText,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.kidsText,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.kidsText,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: AppColors.kidsText,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.kidsText,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.kidsTextSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.kidsText,
    ),
    labelMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.kidsText,
    ),
    labelSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.kidsTextSecondary,
    ),
  );

  // Helper methods for role-based text styling
  static TextStyle getRoleTextStyle(String role, {bool isKidsMode = false}) {
    final baseStyle =
        isKidsMode ? kidsTextTheme.titleMedium! : lightTextTheme.titleMedium!;
    return baseStyle.copyWith(
      color: AppColors.getRoleColor(role),
      fontWeight: FontWeight.bold,
    );
  }

  // Helper method for welcome text styling
  static TextStyle getWelcomeTextStyle(bool isKidsMode) {
    if (isKidsMode) {
      return kidsTextTheme.headlineLarge!.copyWith(
        color: AppColors.kidsPrimary,
        fontWeight: FontWeight.bold,
      );
    }
    return lightTextTheme.headlineLarge!.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.bold,
    );
  }
}

