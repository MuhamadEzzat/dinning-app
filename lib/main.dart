import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/data/providers/theme_provider.dart';
import 'app/data/providers/auth_provider.dart';
import 'app/data/providers/notification_provider.dart';
import 'app/data/repositories/user_repository.dart';
import 'app/data/repositories/notification_repository.dart';
import 'app/utils/deep_link_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize GetStorage
  // await GetStorage.init();

  // Initialize dependencies
  await _initializeDependencies();

  runApp(const MyApp());
}

Future<void> _initializeDependencies() async {
  // Initialize utilities
  Get.put(DeepLinkHandler(), permanent: true);
  // Initialize repositories
  Get.put(UserRepository(), permanent: true);
  Get.put(NotificationRepository(), permanent: true);

  // Initialize providers
  Get.put(ThemeProvider(), permanent: true);
  Get.put(AuthProvider(), permanent: true);
  Get.put(NotificationProvider(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FlutterTask',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getThemeData(AppThemeMode.light),
      darkTheme: AppTheme.getThemeData(AppThemeMode.dark),
      themeMode: ThemeMode.system,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      builder: (context, child) {
        return GetBuilder<ThemeProvider>(
          builder: (themeProvider) {
            return Theme(
              data: AppTheme.getThemeData(themeProvider.currentTheme),
              child: child!,
            );
          },
        );
      },
    );
  }
}
