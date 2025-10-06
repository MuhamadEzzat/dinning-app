# In-App Notifications System

This document explains how the in-app notification system works in the Flutter app.

## Overview

The in-app notification system displays toast-like notifications when the app is in the foreground and receives Firebase Cloud Messaging (FCM) messages. These notifications appear as overlays on top of the current screen and automatically dismiss after a specified duration.

## Features

- **Automatic Display**: Shows notifications when FCM messages are received in foreground
- **Manual Display**: Can be triggered programmatically
- **Multiple Types**: Support for different notification types (success, info, warning, error, general)
- **Animations**: Smooth slide-in and fade animations
- **Auto-dismiss**: Automatically disappears after a configurable duration
- **Tap Actions**: Tappable notifications that can trigger deep links or other actions
- **Manual Dismiss**: Users can manually dismiss notifications with the close button

## Components

### 1. InAppNotification Widget (`lib/app/widgets/in_app_notification.dart`)

The main widget that displays the notification overlay with:
- Animated slide-in from the right
- Fade-in animation
- Notification icon based on type
- Title and body text
- Close button
- Tap handling

### 2. InAppNotificationOverlay Class

Static class that manages the overlay system:
- `show()`: Displays a notification overlay
- `dismiss()`: Removes the current overlay

### 3. NotificationProvider Integration

The `NotificationProvider` automatically handles FCM foreground messages and displays in-app notifications.

## Usage

### Automatic (FCM Foreground Messages)

When the app receives an FCM message while in the foreground, the notification is automatically displayed:

```dart
// This happens automatically in NotificationProvider._handleForegroundMessage()
void _handleForegroundMessage(RemoteMessage message) {
  // Creates notification model and shows in-app notification
  _showInAppNotification(message);
}
```

### Manual Display

You can manually show in-app notifications:

```dart
// Get the notification provider
final notificationProvider = Get.find<NotificationProvider>();

// Show a notification
notificationProvider.showInAppNotification(
  title: 'Success!',
  body: 'Your order has been placed successfully.',
  type: NotificationType.success,
  duration: const Duration(seconds: 4),
);
```

### Test the System

There's a test button in the home screen that demonstrates different notification types:

1. Go to the Home tab
2. Tap the "Test Notification" button in the Quick Actions section
3. A random notification will appear with different types and messages

## Notification Types

The system supports the following notification types:

- `NotificationType.general` - Default blue notification
- `NotificationType.info` - Blue info notification
- `NotificationType.success` - Green success notification
- `NotificationType.warning` - Orange warning notification
- `NotificationType.error` - Red error notification
- `NotificationType.roleBased` - Role-based notifications
- `NotificationType.topicBased` - Topic-based notifications
- `NotificationType.deepLink` - Notifications with deep links

## Customization

### Styling

The notification appearance can be customized by modifying the `InAppNotification` widget:

- Colors are determined by notification type
- Icons are automatically selected based on type
- Animations can be adjusted in the `AnimationController`
- Duration can be set per notification

### Behavior

- **Auto-dismiss duration**: Default is 4 seconds, can be customized
- **Animation duration**: 300ms slide and fade animations
- **Position**: Appears at the top of the screen with safe area padding

## Integration with FCM

The system automatically integrates with Firebase Cloud Messaging:

1. **Foreground messages**: Automatically displayed as in-app notifications
2. **Background messages**: Handled normally (system notification)
3. **Token management**: FCM tokens are saved to Firestore for targeted messaging
4. **Deep links**: Notifications can contain deep links for navigation

## Error Handling

The system includes robust error handling:

- Graceful handling of missing notification data
- Fallback to default values for title/body
- Safe overlay management (prevents multiple overlays)
- Proper cleanup of animation controllers

## Best Practices

1. **Keep messages concise**: Notifications should be brief and clear
2. **Use appropriate types**: Choose the right notification type for the message
3. **Set reasonable durations**: Don't make notifications too long or too short
4. **Handle deep links**: Provide meaningful actions when notifications are tapped
5. **Test thoroughly**: Use the test button to verify different notification types

## Troubleshooting

### Notifications not appearing
- Check if FCM is properly initialized
- Verify notification permissions are granted
- Ensure the app is in the foreground

### Multiple notifications
- The system automatically dismisses previous notifications before showing new ones
- Only one notification overlay is shown at a time

### Animation issues
- Ensure the widget is properly mounted before showing animations
- Check for proper disposal of animation controllers

