import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../theme/app_theme.dart';

class ThemeProvider extends GetxController {
  static ThemeProvider get to => Get.find();

  final _storage = GetStorage();
  final _themeKey = 'app_theme_mode';

  late Rx<AppThemeMode> _currentTheme;
  AppThemeMode get currentTheme => _currentTheme.value;
  AppThemeMode get value => _currentTheme.value;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = _storage.read(_themeKey);
    if (savedTheme != null) {
      _currentTheme = AppThemeMode.values
          .firstWhere(
            (theme) => theme.name == savedTheme,
            orElse: () => AppThemeMode.light,
          )
          .obs;
    } else {
      _currentTheme = AppThemeMode.light.obs;
    }
    _applyTheme();
  }

  void _applyTheme() {
    AppTheme.setTheme(_currentTheme.value);
  }

  void setTheme(AppThemeMode theme) {
    _currentTheme.value = theme;
    _storage.write(_themeKey, theme.name);
    _applyTheme();
  }

  void toggleTheme() {
    switch (_currentTheme.value) {
      case AppThemeMode.light:
        setTheme(AppThemeMode.dark);
        break;
      case AppThemeMode.dark:
        setTheme(AppThemeMode.kids);
        break;
      case AppThemeMode.kids:
        setTheme(AppThemeMode.light);
        break;
    }
  }

  bool get isLightMode => _currentTheme.value == AppThemeMode.light;
  bool get isDarkMode => _currentTheme.value == AppThemeMode.dark;
  bool get isKidsMode => _currentTheme.value == AppThemeMode.kids;

  String get themeName {
    switch (_currentTheme.value) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.kids:
        return 'Kids';
    }
  }

  String get nextThemeName {
    switch (_currentTheme.value) {
      case AppThemeMode.light:
        return 'Dark';
      case AppThemeMode.dark:
        return 'Kids';
      case AppThemeMode.kids:
        return 'Light';
    }
  }
}
