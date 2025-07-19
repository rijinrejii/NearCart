#!/bin/bash
set -e

echo "🚀 Starting Flutter development environment setup..."

# Prevent DNS errors
echo "🔧 Fixing DNS if needed..."
sudo rm -f /etc/resolv.conf
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf || echo "⚠️ DNS symlink failed — skipping..."

# Ensure common missing files don't break setup
echo "📁 Ensuring .bashrc exists..."
touch ~/.bashrc

# Set up environment variables and paths
echo "🔧 Configuring environment variables..."
grep -qxF 'export PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH"' ~/.bashrc || \
  echo 'export PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH"' >> ~/.bashrc

grep -qxF 'export FLUTTER_HOME="/usr/local/flutter"' ~/.bashrc || \
  echo 'export FLUTTER_HOME="/usr/local/flutter"' >> ~/.bashrc

grep -qxF 'export ANDROID_SDK_ROOT="/usr/local/android-sdk"' ~/.bashrc || \
  echo 'export ANDROID_SDK_ROOT="/usr/local/android-sdk"' >> ~/.bashrc

grep -qxF 'export CHROME_EXECUTABLE="/usr/bin/google-chrome"' ~/.bashrc || \
  echo 'export CHROME_EXECUTABLE="/usr/bin/google-chrome"' >> ~/.bashrc

source ~/.bashrc

# Install Java certs to fix Flutter web trust issues
echo "📜 Installing Java CA certificates..."
sudo apt-get update -y
sudo apt-get install -y ca-certificates-java

# Install Google Chrome (required for Flutter Web)
echo "🌐 Installing Google Chrome..."
sudo apt-get install -y wget gnupg
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/google.gpg
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update
sudo apt-get install -y google-chrome-stable

# Detect and install Flutter project dependencies
if [ -f "pubspec.yaml" ]; then
    echo "📦 pubspec.yaml found — installing Flutter dependencies..."
    flutter pub get

    if grep -q "flutter:" pubspec.yaml && grep -q "sdk: flutter" pubspec.yaml; then
        echo "🩺 Running 'flutter doctor'..."
        flutter doctor || true
        echo "✅ Flutter setup completed!"
    else
        echo "📚 Dart project dependencies installed."
    fi
else
    echo "ℹ️ No pubspec.yaml found — not a Flutter project yet."
fi

echo "🎉 All done! You're ready to code."
