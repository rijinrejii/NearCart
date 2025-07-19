# Use Ubuntu as base image
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

# Set environment variables
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"
ENV PUB_CACHE=/usr/local/flutter/.pub-cache
ENV FLUTTER_ROOT=$FLUTTER_HOME
ENV ANDROID_SDK_ROOT=/usr/local/android-sdk
ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH"

# Install dependencies
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
    && apt-get autoremove -y && apt-get clean -y

# Install Android SDK
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/cmdline-tools.zip \
    && unzip /tmp/cmdline-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools \
    && mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest \
    && rm /tmp/cmdline-tools.zip

# Accept Android licenses and install components
RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME \
    && chown -R vscode:vscode $FLUTTER_HOME \
    && chmod -R 755 $FLUTTER_HOME

# Trust Flutter directory for git to avoid "dubious ownership"
RUN git config --global --add safe.directory $FLUTTER_HOME

# Pre-download Flutter dependencies
RUN flutter precache \
    && flutter config --android-sdk $ANDROID_SDK_ROOT \
    && flutter doctor

# Set permissions
RUN chown -R vscode:vscode $FLUTTER_HOME $ANDROID_SDK_ROOT $PUB_CACHE \
    && chmod -R 755 $FLUTTER_HOME $ANDROID_SDK_ROOT

# Switch to vscode user
USER vscode

# Verify installation
RUN flutter --version && dart --version
