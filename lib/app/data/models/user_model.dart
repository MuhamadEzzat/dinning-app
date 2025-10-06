import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  superAdmin,
  admin,
  user,
  moderator,
  parent,
  child,
}

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.superAdmin:
        return 'super_admin';
      case UserRole.admin:
        return 'admin';
      case UserRole.user:
        return 'user';
      case UserRole.moderator:
        return 'moderator';
      case UserRole.parent:
        return 'parent';
      case UserRole.child:
        return 'child';
    }
  }

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'super_admin':
        return UserRole.superAdmin;
      case 'admin':
        return UserRole.admin;
      case 'moderator':
        return UserRole.moderator;
      case 'parent':
        return UserRole.parent;
      case 'child':
        return UserRole.child;
      case 'user':
      default:
        return UserRole.user;
    }
  }

  bool get isAdmin => this == UserRole.superAdmin || this == UserRole.admin;
  bool get isModerator => isAdmin || this == UserRole.moderator;
  bool get isParent => this == UserRole.parent;
  bool get isChild => this == UserRole.child;
  bool get canManageUsers => isAdmin;
  bool get canManageContent => isModerator;
  bool get hasRestrictedAccess => isChild;
}

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final Map<String, dynamic>? preferences;
  final bool isActive;
  final String? parentId; // For child accounts
  final List<String>? childrenIds; // For parent accounts

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
    this.preferences,
    required this.isActive,
    this.parentId,
    this.childrenIds,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      role: UserRoleExtension.fromString(data['role'] ?? 'user'),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isEmailVerified: data['isEmailVerified'] ?? false,
      preferences: data['preferences'],
      isActive: data['isActive'] ?? true,
      parentId: data['parentId'],
      childrenIds: data['childrenIds']?.cast<String>(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role.value,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isEmailVerified': isEmailVerified,
      'preferences': preferences,
      'isActive': isActive,
      'parentId': parentId,
      'childrenIds': childrenIds,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    Map<String, dynamic>? preferences,
    bool? isActive,
    String? parentId,
    List<String>? childrenIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      preferences: preferences ?? this.preferences,
      isActive: isActive ?? this.isActive,
      parentId: parentId ?? this.parentId,
      childrenIds: childrenIds ?? this.childrenIds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName, role: ${role.value})';
  }
}

