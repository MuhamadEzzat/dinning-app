import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class UserRepository extends GetxService {
  static UserRepository get to => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(user.id)
          .set(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      final updatedUser = user.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection(_collection)
          .doc(user.id)
          .update(updatedUser.toFirestore());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection(_collection).doc(uid).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<List<UserModel>> getUsersByRole(UserRole role) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('role', isEqualTo: role.value)
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get users by role: $e');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }

  Future<void> updateUserRole(String uid, UserRole newRole) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'role': newRole.value,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update user role: $e');
    }
  }

  Future<void> updateUserPreferences(
      String uid, Map<String, dynamic> preferences) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'preferences': preferences,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update user preferences: $e');
    }
  }

  Future<void> deactivateUser(String uid) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'isActive': false,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to deactivate user: $e');
    }
  }

  Future<void> activateUser(String uid) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'isActive': true,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to activate user: $e');
    }
  }

  // Parent-Child relationship methods
  Future<void> addChildToParent(String parentId, String childId) async {
    try {
      final batch = _firestore.batch();

      // Add child to parent's children list
      final parentRef = _firestore.collection(_collection).doc(parentId);
      batch.update(parentRef, {
        'childrenIds': FieldValue.arrayUnion([childId]),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Set parent for child
      final childRef = _firestore.collection(_collection).doc(childId);
      batch.update(childRef, {
        'parentId': parentId,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to add child to parent: $e');
    }
  }

  Future<void> removeChildFromParent(String parentId, String childId) async {
    try {
      final batch = _firestore.batch();

      // Remove child from parent's children list
      final parentRef = _firestore.collection(_collection).doc(parentId);
      batch.update(parentRef, {
        'childrenIds': FieldValue.arrayRemove([childId]),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Remove parent from child
      final childRef = _firestore.collection(_collection).doc(childId);
      batch.update(childRef, {
        'parentId': FieldValue.delete(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to remove child from parent: $e');
    }
  }

  Future<List<UserModel>> getChildren(String parentId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('parentId', isEqualTo: parentId)
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get children: $e');
    }
  }

  Stream<List<UserModel>> watchUsersByRole(UserRole role) {
    return _firestore
        .collection(_collection)
        .where('role', isEqualTo: role.value)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }

  Stream<UserModel?> watchUser(String uid) {
    return _firestore
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }
}

