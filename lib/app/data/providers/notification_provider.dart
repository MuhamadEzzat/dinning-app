import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertask/app/data/providers/auth_provider.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';
import '../../utils/deep_link_handler.dart';
import '../../widgets/in_app_notification.dart';

class NotificationProvider extends GetxService {
  static NotificationProvider get to => Get.find();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationRepository _repository = Get.find<NotificationRepository>();
  final DeepLinkHandler _deepLinkHandler = Get.find<DeepLinkHandler>();

  final RxString _fcmToken = ''.obs;
  final RxList<NotificationModel> _notifications = <NotificationModel>[].obs;
  final RxInt _unreadCount = 0.obs;
  final RxBool _isLoading = false.obs;

  String get fcmToken => _fcmToken.value;
  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _initializeFCM();
    _loadNotifications();
  }

  Future<void> _initializeFCM() async {
    try {
      // Request permission
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get FCM token
        String? token = await _messaging.getToken();
        if (token != null) {
          _fcmToken.value = token;
          // Only save token if user is authenticated
          if (Get.find<AuthProvider>().isAuthenticated) {
            await _saveTokenToFirestore(token);
          }
        }

        // Listen for token refresh
        _messaging.onTokenRefresh.listen((newToken) {
          _fcmToken.value = newToken;
          // Only save token if user is authenticated
          if (Get.find<AuthProvider>().isAuthenticated) {
            _saveTokenToFirestore(newToken);
          }
        });

        // Listen for auth state changes to save token when user logs in
        // We'll check authentication status when saving tokens instead

        // Handle foreground messages
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

        // Handle background messages
        FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

        // Handle terminated app messages
        RemoteMessage? initialMessage = await _messaging.getInitialMessage();
        if (initialMessage != null) {
          _handleTerminatedMessage(initialMessage);
        }
      }
    } catch (e) {
      print('FCM initialization error: $e');
    }
  }

  Future<void> _saveTokenToFirestore(String token) async {
    try {
      // Save token to user document in Firestore
      // This will be used for sending targeted notifications
      final user = Get.find<AuthProvider>().firebaseUser;
      if (user != null) {
        // Use set with merge to handle cases where document doesn't exist yet
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fcmToken': token,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        }, SetOptions(merge: true));

        print('FCM token saved successfully for user: ${user.uid}');
      } else {
        print('Cannot save FCM token: User not authenticated');
      }
    } catch (e) {
      print('Failed to save FCM token: $e');
      // Log more detailed error information
      if (e.toString().contains('not-found')) {
        print(
            'User document does not exist in Firestore. This is expected for new users.');
      }
    }
  }

  /// Public method to save FCM token when user logs in
  Future<void> saveTokenForAuthenticatedUser() async {
    if (_fcmToken.value.isNotEmpty &&
        Get.find<AuthProvider>().isAuthenticated) {
      await _saveTokenToFirestore(_fcmToken.value);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message received: ${message.messageId}');

    // Show local notification or in-app notification
    _showInAppNotification(message);

    // Handle deep link if present
    if (message.data['deepLink'] != null) {
      _deepLinkHandler.handleDeepLink(message.data['deepLink']);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print('Background message received: ${message.messageId}');

    // Handle deep link
    if (message.data['deepLink'] != null) {
      _deepLinkHandler.handleDeepLink(message.data['deepLink']);
    }
  }

  void _handleTerminatedMessage(RemoteMessage message) {
    print('Terminated app message received: ${message.messageId}');

    // Handle deep link
    if (message.data['deepLink'] != null) {
      _deepLinkHandler.handleDeepLink(message.data['deepLink']);
    }
  }

  void _showInAppNotification(RemoteMessage message) {
    // Create notification model and add to list
    final notification = NotificationModel(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'Notification',
      body: message.notification?.body ?? '',
      type: _getNotificationTypeFromData(message.data),
      data: message.data,
      deepLinkUrl: message.data['deepLink'],
      createdAt: DateTime.now(),
    );

    // Add to notifications list
    _notifications.insert(0, notification);
    _updateUnreadCount();

    // Show in-app notification overlay
    InAppNotificationOverlay.show(
      notification: notification,
      onTap: () {
        // Handle notification tap
        if (notification.deepLinkUrl != null) {
          _deepLinkHandler.handleDeepLink(notification.deepLinkUrl!);
        }
        // Mark as read
        markAsRead(notification.id);
      },
      duration: const Duration(seconds: 5),
    );
  }

  NotificationType _getNotificationTypeFromData(Map<String, dynamic> data) {
    final typeString = data['type']?.toString().toLowerCase();
    switch (typeString) {
      case 'info':
        return NotificationType.info;
      case 'warning':
        return NotificationType.warning;
      case 'error':
        return NotificationType.error;
      case 'success':
        return NotificationType.success;
      default:
        return NotificationType.general;
    }
  }

  Future<void> _loadNotifications() async {
    try {
      _isLoading.value = true;
      final user = Get.find<AuthProvider>().firebaseUser;
      if (user != null) {
        final notifications = await _repository.getUserNotifications(user.uid);
        _notifications.value = notifications;
        _updateUnreadCount();
      }
    } catch (e) {
      print('Failed to load notifications: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void _updateUnreadCount() {
    _unreadCount.value = _notifications.where((n) => !n.isRead).length;
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markAsRead(notificationId);

      // Update local list
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        _updateUnreadCount();
      }
    } catch (e) {
      print('Failed to mark notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final user = Get.find<AuthProvider>().firebaseUser;
      if (user != null) {
        await _repository.markAllAsRead(user.uid);

        // Update local list
        for (int i = 0; i < _notifications.length; i++) {
          _notifications[i] = _notifications[i].copyWith(isRead: true);
        }
        _updateUnreadCount();
      }
    } catch (e) {
      print('Failed to mark all notifications as read: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _repository.deleteNotification(notificationId);
      _notifications.removeWhere((n) => n.id == notificationId);
      _updateUnreadCount();
    } catch (e) {
      print('Failed to delete notification: $e');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Failed to subscribe to topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
    } catch (e) {
      print('Failed to unsubscribe from topic: $e');
    }
  }

  Future<void> subscribeToRoleTopic(String role) async {
    await subscribeToTopic('role_$role');
  }

  Future<void> unsubscribeFromRoleTopic(String role) async {
    await unsubscribeFromTopic('role_$role');
  }

  // Send notification (admin function)
  Future<void> sendNotification({
    required String title,
    required String body,
    NotificationType type = NotificationType.general,
    NotificationPriority priority = NotificationPriority.normal,
    String? imageUrl,
    Map<String, dynamic>? data,
    String? deepLinkUrl,
    List<String>? targetRoles,
    List<String>? targetTopics,
    List<String>? targetUserIds,
  }) async {
    try {
      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        type: type,
        priority: priority,
        imageUrl: imageUrl,
        data: data,
        deepLinkUrl: deepLinkUrl,
        targetRoles: targetRoles,
        targetTopics: targetTopics,
        targetUserIds: targetUserIds,
        createdAt: DateTime.now(),
        senderId: Get.find<AuthProvider>().firebaseUser?.uid,
        senderName: Get.find<AuthProvider>().userModel?.displayName,
      );

      await _repository.createNotification(notification);
    } catch (e) {
      print('Failed to send notification: $e');
    }
  }

  void refreshNotifications() {
    _loadNotifications();
  }

  /// Show an in-app notification manually
  void showInAppNotification({
    required String title,
    required String body,
    NotificationType type = NotificationType.general,
    String? deepLinkUrl,
    Map<String, dynamic>? data,
    Duration duration = const Duration(seconds: 4),
  }) {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      data: data,
      deepLinkUrl: deepLinkUrl,
      createdAt: DateTime.now(),
    );

    // Add to notifications list
    _notifications.insert(0, notification);
    _updateUnreadCount();

    // Show in-app notification overlay
    InAppNotificationOverlay.show(
      notification: notification,
      onTap: () {
        if (deepLinkUrl != null) {
          _deepLinkHandler.handleDeepLink(deepLinkUrl);
        }
        markAsRead(notification.id);
      },
      duration: duration,
    );
  }

  /// Dismiss the current in-app notification
  void dismissInAppNotification() {
    InAppNotificationOverlay.dismiss();
  }
}
