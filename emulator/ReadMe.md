# 📱 Android Emulator Docker Test Environment

Dự án này cung cấp môi trường máy ảo Android chạy ngầm bên trong Docker (có hỗ trợ KVM), phục vụ cho việc build và test tự động (CI/CD), đặc biệt là test luồng giao tiếp IPC (AIDL/Binder).

## 🛠 1. Yêu cầu hệ thống (Prerequisites)
- Hệ điều hành Linux (Ubuntu/Debian...). Nếu chạy qua VirtualBox, **BẮT BUỘC** phải bật tính năng `Nested VT-x/AMD-V` trong Settings của VirtualBox.
- Đã cài đặt **Docker** và **Docker Compose**.
- Đã cài đặt công cụ **ADB** (`android-tools-adb`).
- Máy chủ hỗ trợ KVM (Kiểm tra bằng lệnh: `egrep -c '(vmx|svm)' /proc/cpuinfo` phải > 0).

---

## 🚀 2. Hướng dẫn sử dụng Mini-CLI (start_docker.sh)

Dự án đi kèm một script quản lý nhanh máy ảo. Hãy chắc chắn bạn đã cấp quyền thực thi cho file:
\`chmod +x start_docker.sh\`

Các lệnh hỗ trợ:
* `./start_docker.sh start`  : Khởi động máy ảo (chạy background).
* `./start_docker.sh logs`   : Xem log trực tiếp để biết máy ảo đã boot xong chưa.
* `./start_docker.sh status` : Xem trạng thái container đang chạy.
* `./start_docker.sh stop`   : Tắt hoàn toàn và xóa container để giải phóng RAM.

---

## 🔌 3. Cách truy cập và Tương tác với Máy ảo

Sau khi chạy lệnh khởi động (`./start_docker.sh start`), máy ảo sẽ mất khoảng 2-3 phút để khởi động hoàn tất. Bạn có thể tương tác với máy ảo qua 2 cách:

### Cách A: Xem giao diện trực quan (Web VNC)
Mở trình duyệt web và truy cập vào địa chỉ:
👉 **http://localhost:6080**
*(Nếu bạn chạy Docker trên máy ảo VirtualBox, hãy thay `localhost` bằng địa chỉ IP của máy ảo Ubuntu).*

### Cách B: Truy cập qua ADB (Android Debug Bridge)
Để cài app hoặc chạy test từ Terminal, bạn cần kết nối ADB vào cổng `5555` của container:

1. **Kết nối ADB:**
   \`adb connect localhost:5555\`

2. **Kiểm tra trạng thái thiết bị:**
   \`adb devices\`
   *(Trạng thái trả về phải là `device`. Nếu báo `offline`, hãy chờ thêm một chút cho máy ảo boot xong).*

3. **Truy cập shell của Android:**
   \`adb -s localhost:5555 shell\`

---

## 🧪 4. Hướng dẫn chạy Test (AIDL / Instrumented Test)

Khi máy ảo đã được kết nối ADB thành công, bạn có thể đứng ở thư mục source code Android (nơi chứa code `.aidl` và `gradlew`) để bắn test sang máy ảo:

\`\`\`bash
# 1. Đảm bảo ADB đã kết nối
adb connect localhost:5555

# 2. Build code và chạy file Test lên Emulator
./gradlew connectedAndroidTest
\`\`\`

Kết quả kiểm thử sẽ được Gradle trả về trực tiếp trên Terminal và xuất báo cáo HTML tại:
\`app/build/reports/androidTests/connected/index.html\`

---

## ⚠️ Lưu ý quan trọng về Hiệu năng
- Máy ảo yêu cầu RAM trống khá lớn. Hãy đảm bảo tắt các ứng dụng không cần thiết trước khi khởi động.
- Để dọn dẹp dung lượng ổ cứng bị chiếm dụng bởi cache của Docker, thỉnh thoảng hãy chạy: \`docker system prune -a\`