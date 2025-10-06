import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFBBDEFB);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF3C3C3C);

  // Kids Theme Colors
  static const Color kidsPrimary = Color(0xFFFF6B6B);
  static const Color kidsSecondary = Color(0xFF4ECDC4);
  static const Color kidsAccent = Color(0xFFFFE66D);
  static const Color kidsBackground = Color(0xFFFFF8E1);
  static const Color kidsCard = Color(0xFFFFF3C4);
  static const Color kidsText = Color(0xFF2E2E2E);
  static const Color kidsTextSecondary = Color(0xFF666666);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Role-based Colors
  static const Color superAdmin = Color(0xFF9C27B0);
  static const Color admin = Color(0xFFFF5722);
  static const Color user = Color(0xFF2196F3);
  static const Color moderator = Color(0xFF4CAF50);
  static const Color parent = Color(0xFFFF9800);
  static const Color child = Color(0xFF00BCD4);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kidsGradient = LinearGradient(
    colors: [kidsPrimary, kidsSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Helper method to get role color
  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'super_admin':
        return superAdmin;
      case 'admin':
        return admin;
      case 'moderator':
        return moderator;
      case 'parent':
        return parent;
      case 'child':
        return child;
      case 'user':
      default:
        return user;
    }
  }
}

