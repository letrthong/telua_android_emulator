# 1. Lấy Emulator làm nền móng
FROM budtmo/docker-android:emulator_11.0

# 2. (Tùy chọn) Chuyển qua quyền root để cài phần mềm
USER root

# 3. Cài thêm các công cụ mạng (ví dụ ping và curl)
RUN apt-get update && apt-get install -y iputils-ping curl