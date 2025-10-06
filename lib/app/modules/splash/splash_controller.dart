import 'dart:developer';

import 'package:get/get.dart';
import '../../data/providers/auth_provider.dart';
import '../../routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  @override
  void onInit() {
    super.onInit();
    log('LOLLLLLL0');
    Get.offAllNamed(Routes.HOME);
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Wait for 2 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is authenticated
    if (_authProvider.isAuthenticated) {
      log('LOLLLLLL1${_authProvider.isAuthenticated.toString()}');
      // User is logged in, go to home
      Get.offAllNamed(Routes.HOME);
    } else {
      log('LOLLLLLL2${_authProvider.isAuthenticated.toString()}');
      // User is not logged in, go to auth
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
