#!/bin/bash

echo "🛠 Отключение автоматических обновлений..."
AUTO_UPGRADES_FILE="/etc/apt/apt.conf.d/20auto-upgrades"

sudo bash -c "cat > $AUTO_UPGRADES_FILE <<EOF
APT::Periodic::Update-Package-Lists \"0\";
APT::Periodic::Unattended-Upgrade \"0\";
EOF"

echo "✅ Автообновления отключены."

echo "🚀 Отключение ожидания сети при загрузке..."
sudo systemctl mask systemd-networkd-wait-online.service
echo "✅ Ожидание сети отключено."

echo "🔋 Отключение режима сна и гибернации..."
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
echo "✅ Система не будет засыпать."

echo "🔄 Перезагрузка Raspberry Pi..."
sudo reboot
