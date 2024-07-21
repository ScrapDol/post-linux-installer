#!/bin/sh


# Обновление системы
sudo pacman -Syu

sudo pacman -S --needed base-devel git

# Установка Yay
git clone https://aur.archlinux.org/yay.git

cd yay

makepkg -si

cd ..

rm -rf yay

# Установка Nvidia драйверов
./drivers-install.sh





#Запуск Hyprland
yay -S hyprland

exec Hyprland
