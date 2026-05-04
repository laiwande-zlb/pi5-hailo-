#!/bin/bash
echo "=== 纯离线部署 开始 ==="

# 备份原有源
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo cp /etc/apt/sources.list.d/raspi.list /etc/apt/sources.list.d/raspi.list.bak

# 写入国内镜像源
sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian trixie main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian trixie-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security trixie-security main contrib non-free non-free-firmware
EOF

sudo tee /etc/apt/sources.list.d/raspi.list >/dev/null <<EOF
deb https://mirrors.tuna.tsinghua.edu.cn/raspberrypi trixie main
EOF

sudo apt update
sudo apt install -y curl gpg ca-certificates

# 本地离线安装所有驱动包
sudo dpkg -i ./*.deb
sudo apt install -f -y

# 识别AI HAT+2
echo "=== 检测NPU硬件 ==="
hailortcli device info

echo "=== 全部部署完成，无外网依赖 ==="