import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/models/user_model.dart';
import '../../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  final RxBool _isSignUp = false.obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final displayNameController = TextEditingController();
  final roleController = TextEditingController();

  // Form keys
  final formKey = GlobalKey<FormState>();

  RxBool get isSignUp => _isSignUp;
  RxBool get isLoading => _isLoading;
  RxString get errorMessage => _errorMessage;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth provider changes
    // ever(_authProvider.errorMessage, (RxString error) {
    //   _errorMessage.value = error.value;
    // });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    displayNameController.dispose();
    roleController.dispose();
    super.onClose();
  }

  void toggleAuthMode() {
    _isSignUp.value = !_isSignUp.value;
    _clearForm();
    _clearError();
  }

  void _clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    displayNameController.clear();
    roleController.clear();
  }

  void _clearError() {
    _errorMessage.value = '';
    _authProvider.clearError();
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    _isLoading.value = true;
    _clearError();

    try {
      bool success = false;

      if (_isSignUp.value) {
        // Sign up
        final role = getSelectedRole();
        success = await _authProvider.signUpWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text,
          displayNameController.text.trim(),
          role,
        );
      } else {
        // Sign in
        success = await _authProvider.signInWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text,
        );
      }

      if (success) {
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      _errorMessage.value = 'An error occurred: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading.value = true;
    _clearError();

    try {
      final success = await _authProvider.signInWithGoogle();
      log(success ? 'Google sign-in successful' : 'Google sign-in failed');
      if (success) {
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      _errorMessage.value = 'Google sign-in failed: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> forgotPassword() async {
    if (emailController.text.trim().isEmpty) {
      _errorMessage.value = 'Please enter your email address';
      return;
    }

    _isLoading.value = true;
    _clearError();

    try {
      await _authProvider.sendPasswordResetEmail(emailController.text.trim());
      Get.snackbar(
        'Success',
        'Password reset email sent to ${emailController.text.trim()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      _errorMessage.value = 'Failed to send reset email: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  UserRole getSelectedRole() {
    final roleText = roleController.text.trim().toLowerCase();
    switch (roleText) {
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
      default:
        return UserRole.user;
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateDisplayName(String? value) {
    if (_isSignUp.value && (value == null || value.isEmpty)) {
      return 'Please enter your name';
    }
    if (value != null && value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
}
