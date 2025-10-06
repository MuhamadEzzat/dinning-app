@echo off
echo Setting up Firebase for FlutterTask...
echo.

REM Check if FlutterFire CLI is installed
flutterfire --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing FlutterFire CLI...
    dart pub global activate flutterfire_cli
    echo.
)

REM Check if Firebase CLI is installed
firebase --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Firebase CLI...
    npm install -g firebase-tools
    echo.
)

echo Please provide the following information:
echo.
set /p PROJECT_NAME="Firebase Project Name (e.g., fluttertask-app): "
set /p PROJECT_ID="Firebase Project ID (e.g., fluttertask-app-12345): "
set /p PACKAGE_NAME="Android Package Name (e.g., com.example.fluttertask): "
set /p BUNDLE_ID="iOS Bundle ID (e.g., com.example.fluttertask): "
set /p DYNAMIC_DOMAIN="Dynamic Link Domain (e.g., fluttertask.page.link): "

echo.
echo Configuration Summary:
echo - Project Name: %PROJECT_NAME%
echo - Project ID: %PROJECT_ID%
echo - Android Package: %PACKAGE_NAME%
echo - iOS Bundle ID: %BUNDLE_ID%
echo - Dynamic Domain: %DYNAMIC_DOMAIN%
echo.

set /p CONFIRM="Is this correct? (y/n): "
if /i "%CONFIRM%" neq "y" (
    echo Setup cancelled.
    pause
    exit /b 1
)

echo.
echo Step 1: Login to Firebase...
firebase login

echo.
echo Step 2: Configure FlutterFire...
flutterfire configure --project=%PROJECT_ID%

echo.
echo Step 3: Generate SHA certificates...
call scripts\generate_sha_keys.bat

echo.
echo Step 4: Update configuration files...
echo Please manually update the following files with your configuration:
echo - firebase_options.dart
echo - lib/app/utils/deep_link_handler.dart (update domain)
echo - android/app/src/main/AndroidManifest.xml (if needed)
echo - ios/Runner/Info.plist (if needed)

echo.
echo Firebase setup completed!
echo.
echo Next steps:
echo 1. Add SHA-1 and SHA-256 to Firebase Console
echo 2. Enable Authentication, Firestore, Storage, FCM, and Dynamic Links
echo 3. Deploy security rules
echo 4. Test the app
echo.

pause









