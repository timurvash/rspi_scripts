#!/bin/bash

echo "🔄 Обновление системы..."
sudo apt update && sudo apt upgrade -y

echo "🛠 Установка зависимостей..."
sudo apt install -y curl gnupg2 lsb-release

echo "🌍 Настройка локализации..."
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

echo "🔑 Добавление ключа ROS..."
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt install -y curl
curl -sSL 'https://raw.githubusercontent.com/ros/rosdistro/master/ros.key' | sudo apt-key add -

echo "📦 Установка ROS Noetic..."
sudo apt update
sudo apt install -y ros-noetic-ros-base

echo "🔧 Настройка переменных окружения..."
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "🛠 Установка инструментов сборки..."
sudo apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential

echo "🔄 Инициализация rosdep..."
sudo apt install -y python3-rosdep
sudo rosdep init
rosdep update

echo "🐢 Установка пакетов TurtleBot3..."
sudo apt install -y ros-noetic-dynamixel-sdk ros-noetic-turtlebot3-msgs ros-noetic-turtlebot3

echo "📄 Настройка переменных окружения для TurtleBot3..."
echo "export TURTLEBOT3_MODEL=burger" >> ~/.bashrc
echo "export LDS_MODEL=LDS-02" >> ~/.bashrc
source ~/.bashrc

echo "🛑 Отключение автообновлений..."
AUTO_UPGRADES_FILE="/etc/apt/apt.conf.d/20auto-upgrades"
sudo bash -c "cat > $AUTO_UPGRADES_FILE <<EOF
APT::Periodic::Update-Package-Lists \"0\";
APT::Periodic::Unattended-Upgrade \"0\";
EOF"

echo "🚀 Отключение ожидания сети при загрузке..."
sudo systemctl mask systemd-networkd-wait-online.service

echo "🔋 Отключение режима сна и гибернации..."
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

echo "🔄 Перезагрузка Raspberry Pi..."
sudo reboot
