import 'package:flutter/material.dart';

class SocialAuthButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onGoogleSignIn;

  const SocialAuthButtons({
    super.key,
    required this.isLoading,
    required this.onGoogleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),

        const SizedBox(height: 20),

        // Google Sign In Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onGoogleSignIn,
            icon: Image.asset(
              'assets/icons/google_icon.png',
              height: 20,
              width: 20,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.login, size: 20);
              },
            ),
            label: const Text('Continue with Google'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}









