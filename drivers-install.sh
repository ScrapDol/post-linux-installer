#!/bin/bash

# Функция для проверки наличия команды
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Проверка на root права
if [ "$(id -u)" != "0" ]; then
   echo "Этот скрипт должен быть запущен с правами root" 1>&2
   exit 1
fi

# Проверка, является ли система Arch Linux
if [ ! -f /etc/arch-release ]; then
    echo "Этот скрипт предназначен только для Arch Linux"
    exit 1
fi

# Обновление системы
echo "Обновление системы..."
pacman -Syu --noconfirm

# Установка необходимых пакетов
echo "Установка необходимых пакетов..."
pacman -S --noconfirm linux-headers dkms

# Определение модели GPU NVIDIA
gpu_model=$(lspci | grep -i nvidia | awk '{print $10}')

# Выбор подходящего пакета драйвера
if [[ $gpu_model == *"3060"* ]] && [[ $gpu_model != *"GTX 750"* ]] && [[ $gpu_model != *"GTX 760"* ]]; then
    driver_package="nvidia"
else
    driver_package="nvidia-470xx-dkms"
fi

echo "Устанавливаем пакет драйвера: $driver_package"
pacman -S --noconfirm "$driver_package"

# Установка утилит NVIDIA и egl-wayland
echo "Установка утилит NVIDIA и поддержки Wayland..."
pacman -S --noconfirm nvidia-utils nvidia-settings egl-wayland

# Включение сервиса persistenced
systemctl enable nvidia-persistenced.service

# Настройка переменных окружения для Wayland
echo "Настройка переменных окружения для Wayland..."
echo "export LIBVA_DRIVER_NAME=nvidia" >> /etc/environment
echo "export XDG_SESSION_TYPE=wayland" >> /etc/environment
echo "export GBM_BACKEND=nvidia-drm" >> /etc/environment
echo "__GLX_VENDOR_LIBRARY_NAME=nvidia" >> /etc/environment

# Обновление конфигурации начального RAM-диска
echo "Обновление конфигурации initramfs..."
sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
mkinitcpio -P

echo "Установка драйверов NVIDIA для Wayland завершена. Пожалуйста, перезагрузите систему."
