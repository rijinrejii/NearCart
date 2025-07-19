# Use Ubuntu as base image
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

# Set environment variables
ENV FLUTTER_HOME=/usr/local/flutter
ENV ANDROID_SDK_ROOT=/usr/local/android-sdk
ENV PUB_CACHE=/usr/local/flutter/.pub-cache
ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}"

# Install system dependencies including Chrome
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        curl \
        git \
        unzip \
        xz-utils \
        zip \
        libglu1-mesa \
        openjdk-17-jdk \
        wget \
        clang \
        cmake \
        ninja-build \
        pkg-config \
        libgtk-3-dev \
        liblzma-dev \
        libstdc++-12-dev \
        software-properties-common \
        gnupg \
        mesa-utils \
    # Install Chrome
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Android SDK
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/cmdline-tools.zip \
    && unzip /tmp/cmdline-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools \
    && mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest \
    && rm /tmp/cmdline-tools.zip

# Accept licenses and install Android SDK components
RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME \
    && chown -R vscode:vscode $FLUTTER_HOME \
    && chmod -R 755 $FLUTTER_HOME

# Git trust fix
RUN git config --global --add safe.directory $FLUTTER_HOME

# Precache and configure Flutter
RUN flutter precache \
    && flutter config --android-sdk $ANDROID_SDK_ROOT \
    && flutter doctor

# Set permissions for everything
RUN chown -R vscode:vscode $FLUTTER_HOME $ANDROID_SDK_ROOT $PUB_CACHE \
    && chmod -R 755 $FLUTTER_HOME $ANDROID_SDK_ROOT

# Switch to vscode user
USER vscode

# Final check
RUN flutter --version && dart --version
