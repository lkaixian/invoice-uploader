FROM debian:bullseye-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa openjdk-11-jdk \
    && apt-get clean

# Android SDK V35 setup
ENV ANDROID_HOME=/opt/android-sdk
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"

RUN mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && curl -Lo commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    && unzip commandlinetools.zip -d ${ANDROID_HOME}/cmdline-tools \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm commandlinetools.zip

RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "platforms;android-35" "build-tools;35.0.0"

# Flutter SDK clone (stable)
RUN git clone https://github.com/flutter/flutter.git -b stable ${FLUTTER_HOME}

WORKDIR /app

COPY . .

RUN flutter doctor
RUN flutter upgrade
RUN flutter pub upgrade && flutter pub get

CMD ["flutter", "doctor"]
