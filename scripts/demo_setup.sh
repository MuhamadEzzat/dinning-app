#!/bin/bash

# FlutterTask Demo Setup Script
# This script helps set up the demo environment

echo "🚀 FlutterTask Demo Setup"
echo "========================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1)
echo "📱 $FLUTTER_VERSION"

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Check for any issues
echo "🔍 Checking for issues..."
flutter doctor

# Run tests
echo "🧪 Running tests..."
flutter test

# Build the app
echo "🔨 Building the app..."
flutter build apk --debug

echo ""
echo "🎉 Demo setup complete!"
echo ""
echo "Next steps:"
echo "1. Set up Firebase project"
echo "2. Configure firebase_options.dart"
echo "3. Run: flutter run"
echo ""
echo "For detailed setup instructions, see README.md"

