#!/bin/bash

# Màu sắc cho Terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Chuyển thư mục làm việc về thư mục chứa script này để có thể chạy từ bất cứ đâu
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit 1

# Tự động phát hiện docker compose (V2) hoặc docker-compose (V1)
if docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
elif docker-compose --version >/dev/null 2>&1; then
    DOCKER_COMPOSE="docker-compose"
else
    echo -e "${RED}[LỖI] Không tìm thấy lệnh docker compose hoặc docker-compose.${NC}"
    echo -e "Vui lòng cài đặt Docker và Docker Compose trước khi chạy script này."
    exit 1
fi

# Kiểm tra xem file docker-compose.yml có tồn tại không
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}[LỖI] Không tìm thấy file docker-compose.yml tại thư mục: $SCRIPT_DIR${NC}"
    exit 1
fi

# Hàm hiển thị hướng dẫn sử dụng
show_help() {
    echo -e "${BLUE}===============================================${NC}"
    echo -e "${GREEN}    📱 ANDROID EMULATOR DOCKER CLI 📱        ${NC}"
    echo -e "${BLUE}===============================================${NC}"
    echo -e "Cách sử dụng: ./${0##*/} [lệnh]"
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
        $DOCKER_COMPOSE up -d
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
        $DOCKER_COMPOSE down
        echo -e "${GREEN}[THÀNH CÔNG] Đã tắt máy ảo.${NC}"
        ;;
    logs)
        echo -e "${YELLOW}Đang hiển thị Log (Nhấn Ctrl+C để thoát)...${NC}"
        $DOCKER_COMPOSE logs -f
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
