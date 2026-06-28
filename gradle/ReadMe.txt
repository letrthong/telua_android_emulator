📱 Hướng dẫn sử dụng môi trường build Gradle trong Docker:

Bước 1: Khởi động container
Chạy file script khởi động từ thư mục `gradle/`:
./start_docker.sh

Bước 2: Truy cập vào terminal của container
Khi container đang chạy, mở một Terminal mới và truy cập vào container bằng lệnh:
docker exec -it ubuntu_java bash

Bước 3: Thực hiện build dự án và gencode AIDL
Khi đã ở trong container (thư mục hiện hành mặc định là /workspace/sample-ipc-app):
- Cấp quyền thực thi cho gradlew (chỉ cần làm ở lần đầu tiên):
  chmod +x gradlew
- Chạy lệnh build sinh code AIDL:
  ./gradlew compileDebugAidl
- Hoặc build ra file APK:
  ./gradlew assembleDebug

Bước 4: Dừng container
Để dừng và tắt container:
docker compose down
