#!/bin/sh

sudo pacman -Syu

sudo pacman -S --needed base-devel git

git clone https://aur.archlinux.org/yay.git

cd yay

makepkg -si

cd ..

rm -rf yay










yay -S hyprland

exec Hyprland
