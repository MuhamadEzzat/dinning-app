import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/models/user_model.dart';
import '../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  UserModel? get userModel => _authProvider.userModel;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _isLoading.value = true;
    try {
      // User data is already loaded in AuthProvider
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulate loading
    } finally {
      _isLoading.value = false;
    }
  }

  void editProfile() {
    Get.dialog(
      AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Profile editing feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void manageUsers() {
    Get.snackbar(
      'Admin Feature',
      'User management feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void manageRestaurants() {
    Get.snackbar(
      'Admin Feature',
      'Restaurant management feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void sendNotifications() {
    Get.dialog(
      AlertDialog(
        title: const Text('Send Notification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Success',
                'Notification sent successfully!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void viewAnalytics() {
    Get.snackbar(
      'Admin Feature',
      'Analytics feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void manageNotifications() {
    Get.dialog(
      AlertDialog(
        title: const Text('Notification Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive push notifications'),
              value: true,
              onChanged: (value) {
                // Handle notification toggle
              },
            ),
            SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive email notifications'),
              value: false,
              onChanged: (value) {
                // Handle email notification toggle
              },
            ),
            SwitchListTile(
              title: const Text('Marketing Emails'),
              subtitle: const Text('Receive promotional emails'),
              value: false,
              onChanged: (value) {
                // Handle marketing email toggle
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void managePrivacy() {
    Get.dialog(
      AlertDialog(
        title: const Text('Privacy Settings'),
        content: const Text('Privacy settings feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showHelp() {
    Get.dialog(
      AlertDialog(
        title: const Text('Help & Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Need help? Here are some options:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email Support'),
              subtitle: const Text('support@fluttertask.com'),
              onTap: () {
                // Open email app
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone Support'),
              subtitle: const Text('+1 (555) 123-4567'),
              onTap: () {
                // Open phone app
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Live Chat'),
              subtitle: const Text('Available 24/7'),
              onTap: () {
                // Open chat
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void showAbout() {
    Get.dialog(
      AlertDialog(
        title: const Text('About FlutterTask'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('FlutterTask v1.0.0'),
            const SizedBox(height: 8),
            const Text('A comprehensive Flutter app with:'),
            const SizedBox(height: 8),
            const Text('• Firebase Authentication'),
            const Text('• Role-based Authorization'),
            const Text('• Push Notifications'),
            const Text('• Deep Linking'),
            const Text('• Multi-style Theming'),
            const SizedBox(height: 16),
            const Text('Built with Flutter & GetX'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _isLoading.value = true;
      try {
        await _authProvider.signOut();
        Get.offAllNamed(Routes.AUTH);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to logout: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        _isLoading.value = false;
      }
    }
  }
}
