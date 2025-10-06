import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import 'notification_provider.dart';

class AuthProvider extends GetxController {
  static AuthProvider get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Simplified Google Sign-In initialization for v6.x
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  final UserRepository _userRepository = Get.find<UserRepository>();

  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  User? get firebaseUser => _firebaseUser.value;
  UserModel? get userModel => _userModel.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isAuthenticated => _firebaseUser.value != null;
  bool get isEmailVerified => _firebaseUser.value?.emailVerified ?? false;
  bool get value => isAuthenticated;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(_auth.authStateChanges());
    ever(_firebaseUser, _onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) async {
    if (user != null) {
      await _loadUserModel(user.uid);
      // Save FCM token for authenticated user
      try {
        final notificationProvider = Get.find<NotificationProvider>();
        await notificationProvider.saveTokenForAuthenticatedUser();
      } catch (e) {
        // NotificationProvider might not be initialized yet, ignore error
        log('Could not save FCM token: $e');
      }
    } else {
      _userModel.value = null;
    }
  }

  Future<void> _loadUserModel(String uid) async {
    try {
      final userModel = await _userRepository.getUser(uid);
      _userModel.value = userModel;
    } catch (e) {
      _errorMessage.value = 'Failed to load user data: $e';
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user != null;
    } on FirebaseAuthException catch (e) {
      _errorMessage.value = _getAuthErrorMessage(e);
      return false;
    } catch (e) {
      _errorMessage.value = 'An unexpected error occurred: $e';
      log(_errorMessage.value);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
    UserRole role,
  ) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(displayName);

        final userModel = UserModel(
          id: credential.user!.uid,
          email: email,
          displayName: displayName,
          photoUrl: credential.user!.photoURL,
          role: role,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isEmailVerified: credential.user!.emailVerified,
          isActive: true,
        );

        await _userRepository.createUser(userModel);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage.value = _getAuthErrorMessage(e);
      return false;
    } catch (e) {
      _errorMessage.value = 'An unexpected error occurred: $e';
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign in with Google using v6.x API (stable)
  /// Sign in with Google using v6.x API
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await _googleSignIn.signOut();
      // Trigger the Google Sign-In flow (v6.x method)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // User cancelled the sign-in
      if (googleUser == null) {
        _errorMessage.value = 'Google sign-in was cancelled';
        log('User cancelled Google sign-in');
        return false;
      }

      log('Google user signed in: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Check if we have the necessary tokens
      if (googleAuth.idToken == null) {
        _errorMessage.value =
            'Google Sign-In configuration error. Missing idToken. '
            'Please check Firebase Console settings and SHA-1 fingerprint.';
        log('idToken is null - check Firebase configuration');
        return false;
      }

      // Create a new credential for Firebase (v6.x includes both tokens)
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        log('Firebase user signed in: ${userCredential.user!.uid}');

        // Check if user exists in Firestore
        final existingUser =
            await _userRepository.getUser(userCredential.user!.uid);

        if (existingUser == null) {
          // Create new user with default role
          final userModel = UserModel(
            id: userCredential.user!.uid, // Use Firebase UID
            email: userCredential.user!.email ?? googleUser.email,
            displayName: userCredential.user!.displayName ??
                googleUser.displayName ??
                'Google User',
            photoUrl:
                userCredential.user!.photoURL ?? googleUser.photoUrl ?? '',
            role: UserRole.user,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isEmailVerified: userCredential.user!.emailVerified,
            isActive: true,
          );

          await _userRepository.createUser(userModel);
          log('New user created in Firestore');
        }

        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage.value = _getAuthErrorMessage(e);
      log('Firebase Auth Error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      _errorMessage.value = 'Google sign-in failed: ${e.toString()}';
      log('Google sign-in error: $e');
      return false;
    } finally {
      _isLoading.value = false;
      if (_errorMessage.value.isNotEmpty) {
        log(_errorMessage.value);
      }
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      _userModel.value = null;
    } catch (e) {
      _errorMessage.value = 'Sign out failed: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _errorMessage.value = _getAuthErrorMessage(e);
    } catch (e) {
      _errorMessage.value = 'Failed to send reset email: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await _firebaseUser.value?.sendEmailVerification();
    } catch (e) {
      _errorMessage.value = 'Failed to send verification email: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> reloadUser() async {
    try {
      await _firebaseUser.value?.reload();
      _firebaseUser.refresh();
    } catch (e) {
      _errorMessage.value = 'Failed to reload user: $e';
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }

  // Role-based access control methods
  bool hasRole(UserRole role) {
    return _userModel.value?.role == role;
  }

  bool hasAnyRole(List<UserRole> roles) {
    return _userModel.value != null && roles.contains(_userModel.value!.role);
  }

  bool canManageUsers() {
    return _userModel.value?.role.canManageUsers ?? false;
  }

  bool canManageContent() {
    return _userModel.value?.role.canManageContent ?? false;
  }

  bool hasRestrictedAccess() {
    return _userModel.value?.role.hasRestrictedAccess ?? false;
  }
}
