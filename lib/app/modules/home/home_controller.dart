import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/notification_provider.dart';
import '../../data/models/user_model.dart';
import '../../data/models/notification_model.dart';
import '../../utils/deep_link_handler.dart';

class HomeController extends GetxController {
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  final NotificationProvider _notificationProvider =
      Get.find<NotificationProvider>();

  final RxInt _currentIndex = 0.obs;
  final RxBool _isLoading = false.obs;

  int get currentIndex => _currentIndex.value;
  bool get isLoading => _isLoading.value;
  UserModel? get userModel => _authProvider.userModel;
  int get unreadCount => _notificationProvider.unreadCount;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading.value = true;
    try {
      // Load any necessary data for home screen
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading
    } finally {
      _isLoading.value = false;
    }
  }

  void changeTab(int index) {
    _currentIndex.value = index;
  }

  void showNotifications() {
    // Navigate to notifications screen or show bottom sheet
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: Theme.of(Get.context!).textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                final notifications = _notificationProvider.notifications;
                if (notifications.isEmpty) {
                  return const Center(
                    child: Text('No notifications yet'),
                  );
                }
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: notification.isRead
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                        child: Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(notification.title),
                      subtitle: Text(notification.body),
                      trailing: Text(
                        _formatTime(notification.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () {
                        _notificationProvider.markAsRead(notification.id);
                        if (notification.deepLinkUrl != null) {
                          Get.find<DeepLinkHandler>()
                              .handleDeepLink(notification.deepLinkUrl!);
                        }
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void manageUsers() {
    // Navigate to user management screen
    Get.snackbar(
      'Admin Feature',
      'User management feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void manageRestaurants() {
    // Navigate to restaurant management screen
    Get.snackbar(
      'Admin Feature',
      'Restaurant management feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showFavorites() {
    Get.snackbar(
      'Favorites',
      'Your favorite restaurants will appear here!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showOrderHistory() {
    Get.snackbar(
      'Order History',
      'Your order history will appear here!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void testInAppNotification() {
    // Test different types of in-app notifications
    final notificationTypes = [
      {
        'type': 'success',
        'title': 'Success!',
        'body': 'Your order has been placed successfully.'
      },
      {
        'type': 'info',
        'title': 'New Feature',
        'body': 'Check out our new restaurant recommendations!'
      },
      {
        'type': 'warning',
        'title': 'Low Balance',
        'body': 'Your wallet balance is running low.'
      },
      {
        'type': 'error',
        'title': 'Order Failed',
        'body': 'Unable to process your order. Please try again.'
      },
    ];

    final randomNotification = notificationTypes[
        DateTime.now().millisecondsSinceEpoch % notificationTypes.length];

    _notificationProvider.showInAppNotification(
      title: randomNotification['title']!,
      body: randomNotification['body']!,
      type: _getNotificationTypeFromString(randomNotification['type']!),
      duration: const Duration(seconds: 6),
    );
  }

  NotificationType _getNotificationTypeFromString(String type) {
    switch (type) {
      case 'success':
        return NotificationType.success;
      case 'info':
        return NotificationType.info;
      case 'warning':
        return NotificationType.warning;
      case 'error':
        return NotificationType.error;
      default:
        return NotificationType.general;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
