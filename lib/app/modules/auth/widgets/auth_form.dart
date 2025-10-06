import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';

class AuthForm extends StatelessWidget {
  final bool isSignUp;
  final bool isLoading;
  final String errorMessage;
  final VoidCallback onToggleMode;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  const AuthForm({
    super.key,
    required this.isSignUp,
    required this.isLoading,
    required this.errorMessage,
    required this.onToggleMode,
    required this.onSubmit,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Display Name Field (Sign Up only)
          if (isSignUp) ...[
            TextFormField(
              controller: controller.displayNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: controller.validateDisplayName,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
          ],

          // Email Field
          TextFormField(
            controller: controller.emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          // Password Field
          TextFormField(
            controller: controller.passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            obscureText: true,
            validator: controller.validatePassword,
            textInputAction:
                isSignUp ? TextInputAction.next : TextInputAction.done,
          ),
          const SizedBox(height: 16),

          // Confirm Password Field (Sign Up only)
          if (isSignUp) ...[
            TextFormField(
              controller: controller.confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: true,
              validator: controller.validateConfirmPassword,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
          ],

          // Role Selection (Sign Up only)
          if (isSignUp) ...[
            DropdownButtonFormField<String>(
              value: controller.roleController.text.isEmpty
                  ? 'user'
                  : controller.roleController.text,
              decoration: InputDecoration(
                labelText: 'Role',
                prefixIcon: const Icon(Icons.admin_panel_settings),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'user', child: Text('User')),
                DropdownMenuItem(value: 'moderator', child: Text('Moderator')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
                DropdownMenuItem(
                    value: 'super_admin', child: Text('Super Admin')),
                DropdownMenuItem(value: 'parent', child: Text('Parent')),
                DropdownMenuItem(value: 'child', child: Text('Child')),
              ],
              onChanged: (value) {
                controller.roleController.text = value ?? 'user';
              },
            ),
            const SizedBox(height: 24),
          ],

          // Submit Button
          ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    isSignUp ? 'Sign Up' : 'Sign In',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),

          const SizedBox(height: 16),

          // Forgot Password (Sign In only)
          if (!isSignUp) ...[
            TextButton(
              onPressed: isLoading ? null : onForgotPassword,
              child: const Text('Forgot Password?'),
            ),
            const SizedBox(height: 16),
          ],

          // Toggle Mode
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isSignUp
                    ? 'Already have an account?'
                    : "Don't have an account?",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: isLoading ? null : onToggleMode,
                child: Text(
                  isSignUp ? 'Sign In' : 'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}









