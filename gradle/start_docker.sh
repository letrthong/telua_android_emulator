#!/bin/bash
# Dừng script ngay lập tức nếu có lỗi xảy ra
set -e

# Dừng và xóa container cũ nếu có
docker compose down

# Đảm bảo container cũ bị xóa sạch
docker rm -f ubuntu_java 2>/dev/null || true

# Build image mới không dùng cache để tránh lỗi
docker compose build --no-cache

# Khởi chạy container
docker compose up
