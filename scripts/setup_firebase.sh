#!/bin/bash

echo "Setting up Firebase for FlutterTask..."
echo

# Check if FlutterFire CLI is installed
if ! command -v flutterfire &> /dev/null; then
    echo "Installing FlutterFire CLI..."
    dart pub global activate flutterfire_cli
    echo
fi

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "Installing Firebase CLI..."
    npm install -g firebase-tools
    echo
fi

echo "Please provide the following information:"
echo

read -p "Firebase Project Name (e.g., fluttertask-app): " PROJECT_NAME
read -p "Firebase Project ID (e.g., fluttertask-app-12345): " PROJECT_ID
read -p "Android Package Name (e.g., com.example.fluttertask): " PACKAGE_NAME
read -p "iOS Bundle ID (e.g., com.example.fluttertask): " BUNDLE_ID
read -p "Dynamic Link Domain (e.g., fluttertask.page.link): " DYNAMIC_DOMAIN

echo
echo "Configuration Summary:"
echo "- Project Name: $PROJECT_NAME"
echo "- Project ID: $PROJECT_ID"
echo "- Android Package: $PACKAGE_NAME"
echo "- iOS Bundle ID: $BUNDLE_ID"
echo "- Dynamic Domain: $DYNAMIC_DOMAIN"
echo

read -p "Is this correct? (y/n): " CONFIRM
if [[ $CONFIRM != "y" && $CONFIRM != "Y" ]]; then
    echo "Setup cancelled."
    exit 1
fi

echo
echo "Step 1: Login to Firebase..."
firebase login

echo
echo "Step 2: Configure FlutterFire..."
flutterfire configure --project=$PROJECT_ID

echo
echo "Step 3: Generate SHA certificates..."
chmod +x scripts/generate_sha_keys.sh
./scripts/generate_sha_keys.sh

echo
echo "Step 4: Update configuration files..."
echo "Please manually update the following files with your configuration:"
echo "- firebase_options.dart"
echo "- lib/app/utils/deep_link_handler.dart (update domain)"
echo "- android/app/src/main/AndroidManifest.xml (if needed)"
echo "- ios/Runner/Info.plist (if needed)"

echo
echo "Firebase setup completed!"
echo
echo "Next steps:"
echo "1. Add SHA-1 and SHA-256 to Firebase Console"
echo "2. Enable Authentication, Firestore, Storage, FCM, and Dynamic Links"
echo "3. Deploy security rules"
echo "4. Test the app"
echo









