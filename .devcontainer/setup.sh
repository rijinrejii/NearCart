#!/bin/bash
set -e

echo "🚀 Starting Flutter development environment setup..."

# Skip DNS fixes in container environments - they're usually handled by the host
echo "🔧 Checking DNS configuration..."
if [ -w /etc/resolv.conf ]; then
    echo "✅ DNS configuration is writable, proceeding with fix..."
    sudo rm -f /etc/resolv.conf 2>/dev/null || true
    sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf 2>/dev/null || echo "⚠️ DNS symlink failed — using existing configuration"
else
    echo "ℹ️ DNS configuration managed by container host — skipping manual DNS setup"
fi

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

# Source the updated bashrc
source ~/.bashrc || true

# Skip redundant Chrome installation since it's already in Dockerfile
echo "🌐 Chrome already installed via Dockerfile — skipping reinstallation"

# Install Java certs with better error handling
echo "📜 Installing Java CA certificates..."
sudo apt-get update -y || echo "⚠️ apt-get update failed, continuing..."
sudo apt-get install -y ca-certificates-java || echo "⚠️ CA certificates installation failed, continuing..."

# Detect and install Flutter project dependencies
if [ -f "pubspec.yaml" ]; then
    echo "📦 pubspec.yaml found — installing Flutter dependencies..."
    flutter pub get || echo "⚠️ flutter pub get failed, you may need to run it manually"

    if grep -q "flutter:" pubspec.yaml && grep -q "sdk: flutter" pubspec.yaml; then
        echo "🩺 Running 'flutter doctor'..."
        flutter doctor || echo "⚠️ flutter doctor had issues, but continuing..."
        echo "✅ Flutter setup completed!"
    else
        echo "📚 Dart project dependencies installed."
    fi
else
    echo "ℹ️ No pubspec.yaml found — not a Flutter project yet."
fi

echo "🎉 Setup completed! You're ready to code."