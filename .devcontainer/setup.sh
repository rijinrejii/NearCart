#!/bin/bash

echo "🚀 Starting Flutter development environment setup..."

# Set up paths
echo 'export PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH"' >> ~/.bashrc
echo 'export FLUTTER_HOME="/usr/local/flutter"' >> ~/.bashrc
echo 'export ANDROID_SDK_ROOT="/usr/local/android-sdk"' >> ~/.bashrc
echo 'export CHROME_EXECUTABLE="/usr/bin/google-chrome"' >> ~/.bashrc

# Reload env
source ~/.bashrc

# Install Google Chrome
echo "🌐 Installing Google Chrome for Flutter Web..."
sudo apt-get update
sudo apt-get install -y wget gnupg
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/google.gpg
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update
sudo apt-get install -y google-chrome-stable

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
