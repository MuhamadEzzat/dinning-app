import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  general,
  roleBased,
  topicBased,
  deepLink,
  info,
  warning,
  error,
  success,
}

enum NotificationPriority {
  low,
  normal,
  high,
  urgent,
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final NotificationPriority priority;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  final String? deepLinkUrl;
  final List<String>? targetRoles;
  final List<String>? targetTopics;
  final List<String>? targetUserIds;
  final DateTime createdAt;
  final DateTime? scheduledFor;
  final bool isRead;
  final String? senderId;
  final String? senderName;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.priority = NotificationPriority.normal,
    this.imageUrl,
    this.data,
    this.deepLinkUrl,
    this.targetRoles,
    this.targetTopics,
    this.targetUserIds,
    required this.createdAt,
    this.scheduledFor,
    this.isRead = false,
    this.senderId,
    this.senderName,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => NotificationType.general,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.name == data['priority'],
        orElse: () => NotificationPriority.normal,
      ),
      imageUrl: data['imageUrl'],
      data: data['data'],
      deepLinkUrl: data['deepLinkUrl'],
      targetRoles: data['targetRoles']?.cast<String>(),
      targetTopics: data['targetTopics']?.cast<String>(),
      targetUserIds: data['targetUserIds']?.cast<String>(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      scheduledFor: data['scheduledFor'] != null
          ? (data['scheduledFor'] as Timestamp).toDate()
          : null,
      isRead: data['isRead'] ?? false,
      senderId: data['senderId'],
      senderName: data['senderName'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'type': type.name,
      'priority': priority.name,
      'imageUrl': imageUrl,
      'data': data,
      'deepLinkUrl': deepLinkUrl,
      'targetRoles': targetRoles,
      'targetTopics': targetTopics,
      'targetUserIds': targetUserIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'scheduledFor':
          scheduledFor != null ? Timestamp.fromDate(scheduledFor!) : null,
      'isRead': isRead,
      'senderId': senderId,
      'senderName': senderName,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    NotificationPriority? priority,
    String? imageUrl,
    Map<String, dynamic>? data,
    String? deepLinkUrl,
    List<String>? targetRoles,
    List<String>? targetTopics,
    List<String>? targetUserIds,
    DateTime? createdAt,
    DateTime? scheduledFor,
    bool? isRead,
    String? senderId,
    String? senderName,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      deepLinkUrl: deepLinkUrl ?? this.deepLinkUrl,
      targetRoles: targetRoles ?? this.targetRoles,
      targetTopics: targetTopics ?? this.targetTopics,
      targetUserIds: targetUserIds ?? this.targetUserIds,
      createdAt: createdAt ?? this.createdAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      isRead: isRead ?? this.isRead,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, type: ${type.name})';
  }
}
