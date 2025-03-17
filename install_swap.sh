#!/bin/bash

echo "🔄 Проверка наличия существующего swap-файла..."
if sudo swapon --show | grep -q "file"; then
    echo "⚠️ Swap-файл уже существует! Отмена операции."
    exit 1
fi

echo "🛠 Создание swap-файла (4 ГБ)..."
sudo fallocate -l 4G /swapfile

echo "🔒 Настройка прав доступа..."
sudo chmod 600 /swapfile

echo "📦 Форматирование файла как swap..."
sudo mkswap /swapfile

echo "🚀 Активация swap-файла..."
sudo swapon /swapfile

echo "🔧 Добавление в fstab для автозагрузки..."
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab

echo "✅ Swap-файл на 4 ГБ успешно создан и активирован!"
swapon --show
free -h
