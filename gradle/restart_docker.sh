#!/bin/bash
set -e

# Khởi động lại container nhanh không cần build lại image
docker compose down
docker rm -f ubuntu_java 2>/dev/null || true
docker compose up
