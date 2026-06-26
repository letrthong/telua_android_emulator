#!/bin/bash

# Màu sắc cho Terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Kiểm tra xem file docker-compose.yml có tồn tại không
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}[LỖI] Không tìm thấy file docker-compose.yml trong thư mục này.${NC}"
    exit 1
fi

# Hàm hiển thị hướng dẫn sử dụng
show_help() {
    echo -e "${BLUE}===============================================${NC}"
    echo -e "${GREEN}    📱 ANDROID EMULATOR DOCKER CLI 📱        ${NC}"
    echo -e "${BLUE}===============================================${NC}"
    echo -e "Cách sử dụng: ./start_docker.sh [lệnh]"
    echo -e ""
    echo -e "Các lệnh hỗ trợ:"
    echo -e "  ${YELLOW}start${NC}   : Khởi động máy ảo Android (chạy ngầm)"
    echo -e "  ${YELLOW}stop${NC}    : Tắt và xóa Container máy ảo"
    echo -e "  ${YELLOW}logs${NC}    : Xem log trực tiếp quá trình boot"
    echo -e "  ${YELLOW}status${NC}  : Kiểm tra trạng thái máy ảo"
    echo -e "${BLUE}===============================================${NC}"
}

# Xử lý các tham số dòng lệnh (CLI arguments)
case "$1" in
    start)
        echo -e "${YELLOW}Đang khởi động Android Emulator...${NC}"
        docker-compose up -d
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[THÀNH CÔNG] Máy ảo đang boot!${NC}"
            echo -e "-> Mở trình duyệt xem tại: ${BLUE}http://localhost:6080${NC}"
            echo -e "-> Kết nối ADB qua cổng: ${BLUE}5555${NC}"
        else
            echo -e "${RED}[THẤT BẠI] Có lỗi xảy ra khi khởi động Docker.${NC}"
        fi
        ;;
    stop)
        echo -e "${YELLOW}Đang tắt Android Emulator và giải phóng RAM...${NC}"
        docker-compose down
        echo -e "${GREEN}[THÀNH CÔNG] Đã tắt máy ảo.${NC}"
        ;;
    logs)
        echo -e "${YELLOW}Đang hiển thị Log (Nhấn Ctrl+C để thoát)...${NC}"
        docker-compose logs -f
        ;;
    status)
        echo -e "${YELLOW}Trạng thái Container:${NC}"
        docker ps -a | grep android-emulator
        ;;
    *)
        # Nếu gõ sai lệnh hoặc không có lệnh nào, hiển thị bảng Help
        show_help
        ;;
esac