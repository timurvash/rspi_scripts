#!/bin/bash

echo "🔄 Обновление системы..."
sudo apt update && sudo apt upgrade -y

echo "🛠 Установка зависимостей..."
sudo apt install -y curl gnupg2 lsb-release build-essential python3-argcomplete python3-colcon-common-extensions libboost-system-dev libudev-dev

echo "🔑 Добавление ключа ROS 2..."
sudo curl -sSL 'https://raw.githubusercontent.com/ros/rosdistro/master/ros.key' | sudo apt-key add -
sudo sh -c 'echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros2-latest.list'

echo "📦 Установка ROS 2 Humble (Base)..."
sudo apt update
sudo apt install -y ros-humble-ros-base

echo "🔧 Настройка окружения..."
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "🐢 Установка пакетов TurtleBot3..."
sudo apt install -y ros-humble-hls-lfcd-lds-driver ros-humble-turtlebot3-msgs ros-humble-dynamixel-sdk

echo "📂 Создание рабочей области..."
mkdir -p ~/turtlebot3_ws/src && cd ~/turtlebot3_ws/src

echo "⬇️ Клонирование TurtleBot3 и LDS-08 драйвера..."
git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3.git
git clone -b humble https://github.com/ROBOTIS-GIT/ld08_driver.git

echo "🗑 Удаление ненужных пакетов (cartographer и navigation2)..."
cd ~/turtlebot3_ws/src/turtlebot3
rm -r turtlebot3_cartographer turtlebot3_navigation2

echo "🔨 Компиляция пакетов (это может занять более часа)..."
cd ~/turtlebot3_ws/
colcon build --symlink-install --parallel-workers 1

echo "🔗 Добавление рабочей области в bashrc..."
echo "source ~/turtlebot3_ws/install/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "🔌 Настройка USB-порта для OpenCR..."
sudo cp `ros2 pkg prefix turtlebot3_bringup`/share/turtlebot3_bringup/script/99-turtlebot3-cdc.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "🌍 Установка ROS_DOMAIN_ID для связи (30)..."
echo "export ROS_DOMAIN_ID=30 #TURTLEBOT3" >> ~/.bashrc
source ~/.bashrc

echo "✅ Установка завершена! Перезагрузка..."
sudo reboot
