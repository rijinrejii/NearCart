#!/bin/bash

echo "🚀 Starting Flutter development environment setup..."

# Set up Flutter path permanently
echo 'export PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH"' >> ~/.bashrc
echo 'export FLUTTER_HOME="/usr/local/flutter"' >> ~/.bashrc
echo 'export ANDROID_SDK_ROOT="/usr/local/android-sdk"' >> ~/.bashrc

# Source the bashrc to make changes available immediately
source ~/.bashrc

# Check if we're in a Flutter project directory
if [ -f "pubspec.yaml" ]; then
    echo "📦 Flutter project detected! Installing dependencies..."
    flutter pub get
    
    # Check if it's a Flutter app (not just a package)
    if grep -q "flutter:" pubspec.yaml && grep -q "sdk: flutter" pubspec.yaml; then
        echo "🔧 Running flutter doctor to check setup..."
        flutter doctor
        
        echo "✅ Development environment is ready!"
        echo "📱 You can now run 'flutter run' to start your app"
        echo "🌐 For web development, use 'flutter run -d web-server --web-port 8080'"
    else
        echo "📚 Flutter package detected. Dependencies installed."
    fi
else
    echo "ℹ️  No pubspec.yaml found. This might not be a Flutter project yet."
    echo "🆕 To create a new Flutter project, run: flutter create my_app"
fi

echo "🎉 Setup complete! Your Flutter development environment is ready."
echo ""
echo "Quick commands:"
echo "  flutter doctor          - Check Flutter installation"
echo "  flutter create my_app   - Create a new Flutter project"
echo "  flutter pub get         - Install dependencies"
echo "  flutter run             - Run your app"
echo "  flutter run -d web-server --web-port 8080  - Run web app"
echo ""