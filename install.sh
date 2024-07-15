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


#TODO: Добавить установку драйверов Nvidia






#Запуск Hyprland
yay -S hyprland

exec Hyprland
