#!/bin/bash

echo "🔄 Обновление списка пакетов..."
sudo apt update && sudo apt upgrade -y

echo "🛠 Установка зависимостей..."
sudo apt install -y curl gnupg2 lsb-release

echo "🌍 Настройка локализации..."
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

echo "🔑 Добавление ключа ROS 2..."
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | sudo apt-key add -

echo "📦 Добавление репозитория ROS 2..."
echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list

echo "🔄 Обновление списка пакетов..."
sudo apt update

echo "🚀 Установка ROS 2 Humble..."
sudo apt install -y ros-humble-ros-base

echo "🛠 Установка инструментов сборки colcon..."
sudo apt install -y python3-colcon-common-extensions

echo "🔧 Настройка переменных окружения..."
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "🐢 Установка пакетов TurtleBot3..."
sudo apt install -y ros-humble-dynamixel-sdk ros-humble-turtlebot3-msgs ros-humble-turtlebot3

echo "📄 Добавление переменных окружения TurtleBot3..."
echo "export TURTLEBOT3_MODEL=burger" >> ~/.bashrc
source ~/.bashrc

echo "✅ Установка завершена!"
echo "📌 Проверьте установку, запустив:"
echo "ros2 run turtlebot3_teleop teleop_keyboard"
