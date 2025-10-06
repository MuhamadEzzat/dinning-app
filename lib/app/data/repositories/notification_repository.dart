import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/notification_model.dart';

class NotificationRepository extends GetxService {
  static NotificationRepository get to => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'notifications';

  Future<void> createNotification(NotificationModel notification) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(notification.id)
          .set(notification.toFirestore());
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('targetUserIds', arrayContains: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      return querySnapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user notifications: $e');
    }
  }

  Future<List<NotificationModel>> getNotificationsByRole(String role) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('targetRoles', arrayContains: role)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      return querySnapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get notifications by role: $e');
    }
  }

  Future<List<NotificationModel>> getNotificationsByTopic(String topic) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('targetTopics', arrayContains: topic)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      return querySnapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get notifications by topic: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore.collection(_collection).doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  Future<void> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('targetUserIds', arrayContains: userId)
          .where('isRead', isEqualTo: false)
          .get();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection(_collection).doc(notificationId).delete();
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  Future<void> deleteOldNotifications(int daysOld) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('createdAt', isLessThan: Timestamp.fromDate(cutoffDate))
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete old notifications: $e');
    }
  }

  Stream<List<NotificationModel>> watchUserNotifications(String userId) {
    return _firestore
        .collection(_collection)
        .where('targetUserIds', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<NotificationModel>> watchNotificationsByRole(String role) {
    return _firestore
        .collection(_collection)
        .where('targetRoles', arrayContains: role)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }

  Future<int> getUnreadCount(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('targetUserIds', arrayContains: userId)
          .where('isRead', isEqualTo: false)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  Stream<int> watchUnreadCount(String userId) {
    return _firestore
        .collection(_collection)
        .where('targetUserIds', arrayContains: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}

