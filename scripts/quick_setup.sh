#!/bin/bash

echo "FlutterTask Quick Setup"
echo "======================"
echo

echo "1. Installing dependencies..."
flutter pub get

echo
echo "2. Generating SHA certificates..."
chmod +x scripts/generate_sha_keys.sh
./scripts/generate_sha_keys.sh

echo
echo "3. Running Firebase setup..."
chmod +x scripts/setup_firebase.sh
./scripts/setup_firebase.sh

echo
echo "4. Running tests..."
flutter test

echo
echo "5. Building the app..."
flutter build apk --debug

echo
echo "Setup completed!"
echo
echo "Don't forget to:"
echo "- Add SHA certificates to Firebase Console"
echo "- Enable Firebase services"
echo "- Update firebase_options.dart with your configuration"
echo "- Deploy security rules"
echo









