# Google Sign-In Setup Guide

## 🔧 **Current Status**

✅ **Firebase Project**: `ezzat-flutter-task`  
✅ **Google Services File**: `google-services.json` is in place  
✅ **App Links**: Replaced deprecated Dynamic Links with modern app_links  
❌ **Google Sign-In**: Needs OAuth client configuration  

## 🚀 **Next Steps to Complete Google Sign-In**

### **Step 1: Generate SHA Certificates**

Run the SHA generation script to get your certificates:

```bash
# Windows
scripts\generate_sha_keys.bat

# macOS/Linux
chmod +x scripts/generate_sha_keys.sh
./scripts/generate_sha_keys.sh
```

### **Step 2: Add SHA Certificates to Firebase**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `ezzat-flutter-task`
3. Go to **Project Settings** → **Your Apps** → **Android App**
4. Scroll down to **SHA certificate fingerprints**
5. Click **Add fingerprint**
6. Add both SHA-1 and SHA-256 from Step 1

### **Step 3: Enable Google Sign-In**

1. In Firebase Console → **Authentication** → **Sign-in method**
2. Click on **Google** provider
3. Toggle **Enable**
4. Add your **Project support email**
5. Click **Save**

### **Step 4: Configure OAuth Consent Screen**

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project: `ezzat-flutter-task`
3. Go to **APIs & Services** → **OAuth consent screen**
4. Configure the consent screen:
   - **User Type**: External (for public apps)
   - **App name**: FlutterTask
   - **User support email**: Your email
   - **Developer contact**: Your email
5. Add scopes:
   - `../auth/userinfo.email`
   - `../auth/userinfo.profile`
6. Add test users (your email addresses)

### **Step 5: Create OAuth 2.0 Credentials**

1. In Google Cloud Console → **APIs & Services** → **Credentials**
2. Click **Create Credentials** → **OAuth 2.0 Client IDs**
3. Select **Android** application type
4. Enter details:
   - **Name**: FlutterTask Android
   - **Package name**: `com.example.fluttertask`
   - **SHA-1 certificate fingerprint**: (from Step 1)
5. Click **Create**
6. Download the `google-services.json` file and replace the existing one

### **Step 6: Update Firebase Configuration**

The `firebase_options.dart` file has been updated with your project details:
- **Project ID**: `ezzat-flutter-task`
- **API Key**: `AIzaSyD7znXcX9TohjrByWHBR8OjpMr2qsDETeg`
- **App ID**: `1:963296147693:android:115d107d6a109c82e974e4`

### **Step 7: Test the App**

```bash
flutter run
```

## 🔗 **Deep Links Configuration**

### **Custom Scheme Links**
Your app now supports custom scheme deep links:
- `fluttertask://home` - Opens home screen
- `fluttertask://dining?id=123` - Opens specific restaurant
- `fluttertask://profile` - Opens profile screen

### **HTTPS Links**
Your app also supports HTTPS deep links:
- `https://ezzat-flutter-task.web.app/home`
- `https://ezzat-flutter-task.web.app/dining?id=123`

### **Android Manifest Configuration**

Add this to `android/app/src/main/AndroidManifest.xml`:

```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    android:theme="@style/LaunchTheme">
    
    <!-- Existing intent filters -->
    
    <!-- Custom scheme intent filter -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="fluttertask" />
    </intent-filter>
    
    <!-- HTTPS intent filter -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https"
              android:host="ezzat-flutter-task.web.app" />
    </intent-filter>
</activity>
```

## 🧪 **Testing**

### **Test Google Sign-In**
1. Run the app
2. Go to authentication screen
3. Tap "Continue with Google"
4. Should open Google sign-in flow

### **Test Deep Links**
1. Use ADB to test custom scheme:
   ```bash
   adb shell am start -W -a android.intent.action.VIEW -d "fluttertask://dining?id=123" com.example.fluttertask
   ```

2. Test HTTPS links:
   ```bash
   adb shell am start -W -a android.intent.action.VIEW -d "https://ezzat-flutter-task.web.app/home" com.example.fluttertask
   ```

## 🎯 **What's Been Updated**

✅ **Removed Firebase Dynamic Links** (deprecated)  
✅ **Added App Links** (modern alternative)  
✅ **Updated Firebase Configuration** with your project details  
✅ **Simplified Deep Link Handling** with custom schemes and HTTPS  
✅ **Updated Dependencies** to remove deprecated packages  

## 🚨 **Important Notes**

1. **Google Sign-In requires SHA certificates** - Make sure to add them to Firebase Console
2. **OAuth consent screen** must be configured for Google Sign-In to work
3. **Test users** should be added to OAuth consent screen during development
4. **Deep links** now use modern app_links package instead of deprecated dynamic links

## 📞 **Need Help?**

If you encounter any issues:
1. Check Firebase Console for error messages
2. Verify SHA certificates are correctly added
3. Ensure OAuth consent screen is properly configured
4. Test with a simple deep link first

---

**Your FlutterTask app is now ready with modern deep linking and Google Sign-In support! 🚀**









