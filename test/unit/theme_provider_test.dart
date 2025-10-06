import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:fluttertask/app/data/providers/theme_provider.dart';
import 'package:fluttertask/app/theme/app_theme.dart';

void main() {
  late ThemeProvider themeProvider;

  setUp(() {
    GetStorage.init();
    themeProvider = ThemeProvider();
    Get.put<ThemeProvider>(themeProvider);
  });

  tearDown(() {
    Get.reset();
    GetStorage.init();
  });

  group('ThemeProvider', () {
    test('should initialize with light theme by default', () {
      expect(themeProvider.currentTheme, AppThemeMode.light);
      expect(themeProvider.isLightMode, true);
      expect(themeProvider.isDarkMode, false);
      expect(themeProvider.isKidsMode, false);
    });

    test('should set theme correctly', () {
      // Set dark theme
      themeProvider.setTheme(AppThemeMode.dark);
      expect(themeProvider.currentTheme, AppThemeMode.dark);
      expect(themeProvider.isDarkMode, true);
      expect(themeProvider.isLightMode, false);
      expect(themeProvider.isKidsMode, false);

      // Set kids theme
      themeProvider.setTheme(AppThemeMode.kids);
      expect(themeProvider.currentTheme, AppThemeMode.kids);
      expect(themeProvider.isKidsMode, true);
      expect(themeProvider.isDarkMode, false);
      expect(themeProvider.isLightMode, false);
    });

    test('should toggle theme correctly', () {
      // Start with light theme
      expect(themeProvider.currentTheme, AppThemeMode.light);

      // Toggle to dark
      themeProvider.toggleTheme();
      expect(themeProvider.currentTheme, AppThemeMode.dark);

      // Toggle to kids
      themeProvider.toggleTheme();
      expect(themeProvider.currentTheme, AppThemeMode.kids);

      // Toggle back to light
      themeProvider.toggleTheme();
      expect(themeProvider.currentTheme, AppThemeMode.light);
    });

    test('should return correct theme names', () {
      themeProvider.setTheme(AppThemeMode.light);
      expect(themeProvider.themeName, 'Light');

      themeProvider.setTheme(AppThemeMode.dark);
      expect(themeProvider.themeName, 'Dark');

      themeProvider.setTheme(AppThemeMode.kids);
      expect(themeProvider.themeName, 'Kids');
    });

    test('should return correct next theme names', () {
      themeProvider.setTheme(AppThemeMode.light);
      expect(themeProvider.nextThemeName, 'Dark');

      themeProvider.setTheme(AppThemeMode.dark);
      expect(themeProvider.nextThemeName, 'Kids');

      themeProvider.setTheme(AppThemeMode.kids);
      expect(themeProvider.nextThemeName, 'Light');
    });
  });
}









