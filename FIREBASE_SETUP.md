# Firebase Setup Guide for FlutterTask

This guide will help you set up Firebase for your FlutterTask project.

## Prerequisites

1. **FlutterFire CLI** - Install if not already installed:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Firebase Account** - Sign up at [Firebase Console](https://console.firebase.google.com/)

3. **Google Cloud Project** - You'll need to create or use an existing Google Cloud project

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter your project details:
   - **Project name**: `fluttertask-app` (or your preferred name)
   - **Project ID**: `fluttertask-app-xxxxx` (will be auto-generated)
   - **Google Analytics**: Enable (recommended)
4. Click "Create project"

## Step 2: Generate SHA Certificates

### For Windows:
```bash
# Run the batch script
scripts\generate_sha_keys.bat
```

### For macOS/Linux:
```bash
# Make script executable
chmod +x scripts/generate_sha_keys.sh

# Run the script
./scripts/generate_sha_keys.sh
```

### Manual Method:
```bash
# Navigate to android directory
cd android

# Generate debug keystore SHA-1 and SHA-256
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**Copy the SHA-1 and SHA-256 fingerprints** - you'll need these for Firebase configuration.

## Step 3: Configure Firebase Services

### 3.1 Authentication
1. In Firebase Console → **Authentication** → **Sign-in method**
2. Enable **Email/Password** authentication
3. Enable **Google** authentication
4. Configure OAuth consent screen if prompted

### 3.2 Firestore Database
1. In Firebase Console → **Firestore Database**
2. Click "Create database"
3. Choose **Production mode** (we'll use custom rules)
4. Select a location (choose closest to your users)

### 3.3 Cloud Storage
1. In Firebase Console → **Storage**
2. Click "Get started"
3. Choose **Production mode**
4. Select same location as Firestore

### 3.4 Cloud Messaging
1. In Firebase Console → **Cloud Messaging**
2. No additional setup needed for basic functionality

### 3.5 Dynamic Links
1. In Firebase Console → **Dynamic Links**
2. Click "Get started"
3. Create a domain (e.g., `fluttertask.page.link`)
4. Configure Android and iOS app settings

## Step 4: Add Android App to Firebase

1. In Firebase Console → **Project Overview** → **Add app** → **Android**
2. Enter your app details:
   - **Android package name**: `com.example.fluttertask`
   - **App nickname**: `FlutterTask Android`
   - **Debug signing certificate SHA-1**: Paste the SHA-1 from Step 2
3. Click "Register app"
4. Download `google-services.json`
5. Place it in `android/app/` directory

## Step 5: Add iOS App to Firebase

1. In Firebase Console → **Project Overview** → **Add app** → **iOS**
2. Enter your app details:
   - **iOS bundle ID**: `com.example.fluttertask`
   - **App nickname**: `FlutterTask iOS`
3. Click "Register app"
4. Download `GoogleService-Info.plist`
5. Add it to `ios/Runner/` in Xcode

## Step 6: Configure FlutterFire

### Option A: Using FlutterFire CLI (Recommended)

```bash
# Login to Firebase
firebase login

# Configure FlutterFire
flutterfire configure
```

Follow the prompts:
1. Select your Firebase project
2. Select platforms (Android, iOS, Web)
3. The CLI will automatically configure your project

### Option B: Manual Configuration

1. Update `firebase_options.dart` with your project configuration
2. Update `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```
3. Update `android/build.gradle`:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
   }
   ```

## Step 7: Deploy Security Rules

### Firestore Rules
```bash
# Deploy Firestore rules
firebase deploy --only firestore:rules
```

### Storage Rules
```bash
# Deploy Storage rules
firebase deploy --only storage
```

## Step 8: Configure Dynamic Links

1. In Firebase Console → **Dynamic Links** → **New dynamic link**
2. Configure your domain and link parameters
3. Update `lib/app/utils/deep_link_handler.dart` with your domain:
   ```dart
   uriPrefix: 'https://your-domain.page.link'
   ```

## Step 9: Test Configuration

1. Run the app:
   ```bash
   flutter run
   ```

2. Test authentication:
   - Try signing up with email/password
   - Try Google Sign-In
   - Test password reset

3. Test notifications:
   - Send a test notification from Firebase Console
   - Verify deep link functionality

## Troubleshooting

### Common Issues:

1. **SHA-1 Mismatch**:
   - Ensure you're using the correct keystore
   - For release builds, use your release keystore SHA-1

2. **Google Sign-In Issues**:
   - Verify OAuth client configuration
   - Check SHA-1 fingerprints in Firebase Console

3. **Dynamic Links Not Working**:
   - Verify domain configuration
   - Check URL scheme registration

4. **Build Errors**:
   - Clean and rebuild: `flutter clean && flutter pub get`
   - Check Firebase configuration files are in correct locations

## Required Information for Setup

Please provide the following information:

1. **Firebase Project Name**: (e.g., `fluttertask-app`)
2. **Firebase Project ID**: (e.g., `fluttertask-app-12345`)
3. **Android Package Name**: (e.g., `com.example.fluttertask`)
4. **iOS Bundle ID**: (e.g., `com.example.fluttertask`)
5. **Dynamic Link Domain**: (e.g., `fluttertask.page.link`)

## Next Steps

After completing this setup:

1. Update `firebase_options.dart` with your actual configuration
2. Test all Firebase services
3. Deploy security rules
4. Configure push notifications
5. Test deep linking functionality

---

**Need Help?** Check the [Firebase Documentation](https://firebase.google.com/docs) or [FlutterFire Documentation](https://firebase.flutter.dev/)









