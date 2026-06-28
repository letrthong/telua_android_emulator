# Sử dụng JDK 17 làm base image (hệ điều hành nền là Ubuntu Jammy)
FROM eclipse-temurin:17-jdk-jammy

# Cài đặt các công cụ cơ bản cần thiết
RUN apt-get update && apt-get install -y \
    unzip \
    wget \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Cấu hình biến môi trường cho Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/33.0.2

# Tải và cài đặt Android Command Line Tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d /tmp/cmdline-tools-extracted && \
    mv /tmp/cmdline-tools-extracted/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm -rf /tmp/cmdline-tools.zip /tmp/cmdline-tools-extracted

# Chấp nhận tất cả licenses của Android SDK
RUN yes | sdkmanager --licenses

# Cài đặt Platform Tools, Build Tools 33.0.2 và Platform API 33 (khớp với compileSdk 33 trong ứng dụng mẫu)
RUN sdkmanager "platform-tools" "build-tools;33.0.2" "platforms;android-33"

# Thiết lập thư mục làm việc mặc định trong container
WORKDIR /workspace/sample-ipc-app

# Mặc định mở bash shell để tương tác
CMD ["/bin/bash"]
