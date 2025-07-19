#!/bin/bash

echo "🚀 Starting Flutter development environment setup..."

# Set up paths
echo 'export PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH"' >> ~/.bashrc
echo 'export FLUTTER_HOME="/usr/local/flutter"' >> ~/.bashrc
echo 'export ANDROID_SDK_ROOT="/usr/local/android-sdk"' >> ~/.bashrc

# Reload env
source ~/.bashrc

# Setup project if pubspec exists
if [ -f "pubspec.yaml" ]; then
    echo "📦 Flutter project detected! Installing dependencies..."
    flutter pub get

    if grep -q "flutter:" pubspec.yaml && grep -q "sdk: flutter" pubspec.yaml; then
        echo "🔧 Running flutter doctor to check setup..."
        flutter doctor
        echo "✅ Development environment is ready!"
    else
        echo "📚 Flutter package detected. Dependencies installed."
    fi
else
    echo "ℹ️  No pubspec.yaml found. This might not be a Flutter project yet."
fi

echo "🎉 Setup complete!"
