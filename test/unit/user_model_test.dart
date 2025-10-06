import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fluttertask/app/data/models/user_model.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('UserModel', () {
    late UserModel testUser;

    setUp(() {
      testUser = UserModel(
        id: 'test-user-id',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        role: UserRole.user,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
        isEmailVerified: true,
        preferences: {'theme': 'light'},
        isActive: true,
      );
    });

    test('should create user model correctly', () {
      expect(testUser.id, 'test-user-id');
      expect(testUser.email, 'test@example.com');
      expect(testUser.displayName, 'Test User');
      expect(testUser.role, UserRole.user);
      expect(testUser.isEmailVerified, true);
      expect(testUser.isActive, true);
    });

    test('should convert to Firestore document correctly', () {
      final firestoreData = testUser.toFirestore();

      expect(firestoreData['email'], 'test@example.com');
      expect(firestoreData['displayName'], 'Test User');
      expect(firestoreData['role'], 'user');
      expect(firestoreData['isEmailVerified'], true);
      expect(firestoreData['isActive'], true);
      expect(firestoreData['preferences'], {'theme': 'light'});
    });

    test('should create from Firestore document correctly', () {
      final mockDoc = MockDocumentSnapshot();
      when(mockDoc.id).thenReturn('test-user-id');
      when(mockDoc.data()).thenReturn({
        'email': 'test@example.com',
        'displayName': 'Test User',
        'photoUrl': 'https://example.com/photo.jpg',
        'role': 'user',
        'createdAt': Timestamp.fromDate(DateTime(2023, 1, 1)),
        'updatedAt': Timestamp.fromDate(DateTime(2023, 1, 2)),
        'isEmailVerified': true,
        'preferences': {'theme': 'light'},
        'isActive': true,
      });

      final user = UserModel.fromFirestore(mockDoc);

      expect(user.id, 'test-user-id');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.role, UserRole.user);
      expect(user.isEmailVerified, true);
      expect(user.isActive, true);
    });

    test('should copy with new values correctly', () {
      final updatedUser = testUser.copyWith(
        displayName: 'Updated Name',
        isEmailVerified: false,
      );

      expect(updatedUser.id, testUser.id);
      expect(updatedUser.email, testUser.email);
      expect(updatedUser.displayName, 'Updated Name');
      expect(updatedUser.isEmailVerified, false);
      expect(updatedUser.role, testUser.role);
    });

    test('should implement equality correctly', () {
      final sameUser = UserModel(
        id: 'test-user-id',
        email: 'test@example.com',
        displayName: 'Test User',
        role: UserRole.user,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
        isEmailVerified: true,
        isActive: true,
      );

      final differentUser = UserModel(
        id: 'different-id',
        email: 'test@example.com',
        displayName: 'Test User',
        role: UserRole.user,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
        isEmailVerified: true,
        isActive: true,
      );

      expect(testUser == sameUser, true);
      expect(testUser == differentUser, false);
    });
  });

  group('UserRole', () {
    test('should return correct string values', () {
      expect(UserRole.superAdmin.value, 'super_admin');
      expect(UserRole.admin.value, 'admin');
      expect(UserRole.user.value, 'user');
      expect(UserRole.moderator.value, 'moderator');
      expect(UserRole.parent.value, 'parent');
      expect(UserRole.child.value, 'child');
    });

    test('should create from string correctly', () {
      expect(UserRoleExtension.fromString('super_admin'), UserRole.superAdmin);
      expect(UserRoleExtension.fromString('admin'), UserRole.admin);
      expect(UserRoleExtension.fromString('user'), UserRole.user);
      expect(UserRoleExtension.fromString('moderator'), UserRole.moderator);
      expect(UserRoleExtension.fromString('parent'), UserRole.parent);
      expect(UserRoleExtension.fromString('child'), UserRole.child);
      expect(UserRoleExtension.fromString('invalid'), UserRole.user); // Default
    });

    test('should check role permissions correctly', () {
      expect(UserRole.superAdmin.isAdmin, true);
      expect(UserRole.admin.isAdmin, true);
      expect(UserRole.user.isAdmin, false);

      expect(UserRole.superAdmin.isModerator, true);
      expect(UserRole.admin.isModerator, true);
      expect(UserRole.moderator.isModerator, true);
      expect(UserRole.user.isModerator, false);

      expect(UserRole.superAdmin.canManageUsers, true);
      expect(UserRole.admin.canManageUsers, true);
      expect(UserRole.user.canManageUsers, false);

      expect(UserRole.child.hasRestrictedAccess, true);
      expect(UserRole.user.hasRestrictedAccess, false);
    });
  });
}

// Mock class for testing
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}









