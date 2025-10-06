import 'package:flutter_test/flutter_test.dart';
import '../../lib/app/data/models/user_model.dart';

void main() {
  group('Auth Validation Tests', () {
    test('should validate email correctly', () {
      // Valid email
      expect(_validateEmail('test@example.com'), null);

      // Invalid email
      expect(_validateEmail('invalid-email'), isNotNull);

      // Empty email
      expect(_validateEmail(''), isNotNull);
    });

    test('should validate password correctly', () {
      // Valid password
      expect(_validatePassword('password123'), null);

      // Short password
      expect(_validatePassword('123'), isNotNull);

      // Empty password
      expect(_validatePassword(''), isNotNull);
    });

    test('should validate confirm password correctly', () {
      const password = 'password123';

      // Matching passwords
      expect(_validateConfirmPassword(password, password), null);

      // Non-matching passwords
      expect(_validateConfirmPassword(password, 'different'), isNotNull);
    });

    test('should validate display name correctly', () {
      // Valid name
      expect(_validateDisplayName('John Doe'), null);

      // Short name
      expect(_validateDisplayName('J'), isNotNull);

      // Empty name
      expect(_validateDisplayName(''), isNotNull);
    });

    test('should get correct role from string', () {
      expect(_getRoleFromString('admin'), UserRole.admin);
      expect(_getRoleFromString('super_admin'), UserRole.superAdmin);
      expect(_getRoleFromString('user'), UserRole.user);
      expect(_getRoleFromString('moderator'), UserRole.moderator);
      expect(_getRoleFromString('parent'), UserRole.parent);
      expect(_getRoleFromString('child'), UserRole.child);
      expect(_getRoleFromString('invalid'), UserRole.user); // Default
    });

    test('should check role permissions correctly', () {
      // Admin permissions
      expect(UserRole.superAdmin.isAdmin, true);
      expect(UserRole.admin.isAdmin, true);
      expect(UserRole.user.isAdmin, false);

      // Moderator permissions
      expect(UserRole.superAdmin.isModerator, true);
      expect(UserRole.admin.isModerator, true);
      expect(UserRole.moderator.isModerator, true);
      expect(UserRole.user.isModerator, false);

      // Content management
      expect(UserRole.superAdmin.canManageContent, true);
      expect(UserRole.admin.canManageContent, true);
      expect(UserRole.moderator.canManageContent, true);
      expect(UserRole.user.canManageContent, false);
    });
  });
}

// Helper validation functions (copied from AuthController logic)
String? _validateEmail(String email) {
  if (email.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
    return 'Please enter a valid email';
  }
  return null;
}

String? _validatePassword(String password) {
  if (password.isEmpty) {
    return 'Password is required';
  }
  if (password.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? _validateConfirmPassword(String password, String confirmPassword) {
  if (confirmPassword.isEmpty) {
    return 'Please confirm your password';
  }
  if (password != confirmPassword) {
    return 'Passwords do not match';
  }
  return null;
}

String? _validateDisplayName(String name) {
  if (name.isEmpty) {
    return 'Display name is required';
  }
  if (name.length < 2) {
    return 'Display name must be at least 2 characters';
  }
  return null;
}

UserRole _getRoleFromString(String roleText) {
  switch (roleText.toLowerCase()) {
    case 'admin':
      return UserRole.admin;
    case 'super_admin':
      return UserRole.superAdmin;
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









