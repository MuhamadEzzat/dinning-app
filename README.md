# FlutterTask - Comprehensive Flutter App

A full-featured Flutter application built with GetX state management, featuring Firebase authentication, role-based authorization, push notifications, deep linking, and multi-style theming.

## 🚀 Features

### ✅ Authentication & Authorization
- **Firebase Authentication** with email/password and Google Sign-In
- **Role-based Authorization** with 6 user roles:
  - `super_admin` - Full system access
  - `admin` - User and content management
  - `moderator` - Content management
  - `user` - Standard user access
  - `parent` - Parent account with child management
  - `child` - Restricted child account
- **Account Management** - Profile creation, password reset, email verification

### 🔔 Push Notifications
- **Firebase Cloud Messaging (FCM)** integration
- **Topic-based notifications** for different user roles
- **Deep link payload support** - notifications open specific app screens
- **Foreground, background, and terminated state handling**

### 🔗 Deep Linking
- **Firebase Dynamic Links** for sharing content
- **Custom app scheme** support (`fluttertask://`)
- **Universal link handling** for iOS and Android
- **Deep link navigation** to specific screens with parameters

### 🎨 Multi-Style Theming
- **Light Theme** - Modern, clean design
- **Dark Theme** - Full dark mode support
- **Kids Theme** - Special mode with:
  - Larger fonts and touch targets
  - Simplified navigation
  - Playful colors and animations
  - Content restrictions for child safety
- **Runtime theme switching** without app restart
- **Persistent theme preferences**

### 🏗️ Architecture
- **GetX State Management** for reactive programming
- **GetCLI Structure** for organized codebase
- **Repository Pattern** for data management
- **Provider Pattern** for business logic
- **Clean Architecture** principles

### 🍽️ Dining Features
- **Restaurant listings** with filtering and search
- **Role-based content access** control
- **Kids-friendly restaurant filtering**
- **Deep linking** to specific restaurants
- **Admin restaurant management** (for moderators/admins)

## 📱 App Structure

### Navigation
- **Bottom Navigation Bar** with 3 main screens:
  - **Home** - Welcome screen with role-based content
  - **Dining** - Restaurant listings and management
  - **Profile** - User profile and theme settings

### Screens
1. **Splash Screen** - App initialization and auth check
2. **Authentication** - Sign in/up with role selection
3. **Home** - Dashboard with quick actions and notifications
4. **Dining** - Restaurant discovery and management
5. **Profile** - User settings and theme selection

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (3.5.4 or higher)
- Dart SDK
- Firebase project
- Android Studio / VS Code
- Git

### 1. Clone the Repository
```bash
git clone <repository-url>
cd fluttertask
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named `fluttertask-app`
3. Enable the following services:
   - Authentication
   - Firestore Database
   - Cloud Storage
   - Cloud Messaging
   - Dynamic Links

#### Configure Authentication
1. In Firebase Console → Authentication → Sign-in method
2. Enable **Email/Password** authentication
3. Enable **Google** authentication
4. Configure OAuth consent screen

#### Configure Firestore
1. In Firebase Console → Firestore Database
2. Create database in production mode
3. Deploy the security rules from `firestore.rules`

#### Configure Cloud Storage
1. In Firebase Console → Storage
2. Create storage bucket
3. Deploy the security rules from `storage.rules`

#### Configure Cloud Messaging
1. In Firebase Console → Cloud Messaging
2. Note down the Server Key for sending notifications

#### Configure Dynamic Links
1. In Firebase Console → Dynamic Links
2. Create a domain (e.g., `fluttertask.page.link`)
3. Configure Android and iOS app settings

### 4. Platform Configuration

#### Android Setup
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/` directory
3. Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```
4. Update `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

#### iOS Setup
1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to `ios/Runner/` in Xcode
3. Update `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>fluttertask</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fluttertask</string>
        </array>
    </dict>
</array>
```

### 5. Update Firebase Configuration
1. Update `firebase_options.dart` with your actual Firebase configuration
2. Replace placeholder values with your project's actual values

### 6. Run the App
```bash
flutter run
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📦 Build & Deploy

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:
```env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
GOOGLE_SIGN_IN_CLIENT_ID=your-client-id
```

### Deep Link Configuration
Update deep link URLs in:
- `lib/app/utils/deep_link_handler.dart`
- Firebase Dynamic Links console
- Platform-specific configuration files

## 📚 API Documentation

### Authentication Endpoints
- `POST /auth/signup` - User registration
- `POST /auth/signin` - User login
- `POST /auth/google` - Google Sign-In
- `POST /auth/reset` - Password reset

### User Management
- `GET /users` - Get all users (admin only)
- `GET /users/{id}` - Get user by ID
- `PUT /users/{id}` - Update user
- `DELETE /users/{id}` - Delete user (admin only)

### Notifications
- `POST /notifications` - Send notification (moderator+)
- `GET /notifications` - Get user notifications
- `PUT /notifications/{id}/read` - Mark as read

## 🚨 Security

### Firestore Security Rules
- Role-based access control
- User data protection
- Admin-only operations
- Parent-child relationship management

### Storage Security Rules
- File size limits
- Content type restrictions
- User-specific access control
- Admin moderation capabilities

## 🐛 Troubleshooting

### Common Issues

#### Firebase Connection Issues
- Verify `google-services.json` and `GoogleService-Info.plist` are correctly placed
- Check Firebase project configuration
- Ensure all required services are enabled

#### Authentication Issues
- Verify OAuth client IDs are correctly configured
- Check SHA-1 fingerprints for Android
- Ensure bundle IDs match Firebase configuration

#### Push Notification Issues
- Verify FCM token generation
- Check notification permissions
- Test with Firebase Console messaging

#### Deep Link Issues
- Verify URL schemes are registered
- Check Firebase Dynamic Links configuration
- Test with different app states (foreground/background/terminated)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- Email: support@fluttertask.com
- Documentation: [Wiki](https://github.com/your-repo/wiki)
- Issues: [GitHub Issues](https://github.com/your-repo/issues)

## 🎯 Roadmap

### Upcoming Features
- [ ] Real-time chat support
- [ ] Advanced analytics dashboard
- [ ] Multi-language support
- [ ] Offline mode
- [ ] Social media integration
- [ ] Payment integration
- [ ] Advanced search filters
- [ ] User reviews and ratings
- [ ] Restaurant booking system
- [ ] Loyalty program

### Performance Improvements
- [ ] Image caching optimization
- [ ] Lazy loading implementation
- [ ] Memory usage optimization
- [ ] Battery usage optimization

---

**Built with ❤️ using Flutter, GetX, and Firebase**#   d i n n i n g - a p p  
 