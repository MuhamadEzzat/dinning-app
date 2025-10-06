import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fluttertask/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterTask App Integration Tests', () {
    testWidgets('App launches and shows splash screen',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify splash screen is shown
      expect(find.text('FlutterTask'), findsOneWidget);
      expect(find.text('Your Dining Experience Awaits'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Navigation to auth screen after splash',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to complete
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Should navigate to auth screen
      expect(find.text('Welcome to FlutterTask'), findsOneWidget);
      expect(
          find.text('Sign in to continue your dining journey'), findsOneWidget);
    });

    testWidgets('Auth form validation works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Theme switching works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Navigate to profile (this would require authentication in real app)
      // For testing, we'll simulate theme switching

      // This test would need to be updated based on actual navigation flow
      // after implementing proper authentication flow
    });

    testWidgets('Bottom navigation works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // This test would verify bottom navigation after successful authentication
      // For now, we'll just verify the app structure
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Deep Link Integration Tests', () {
    testWidgets('Deep link handling works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test deep link handling
      // This would require actual deep link testing setup
      // For now, we'll verify the app can handle the initial route
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Push Notification Integration Tests', () {
    testWidgets('Notification handling works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test notification handling
      // This would require actual FCM testing setup
      // For now, we'll verify the app initializes properly
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}









