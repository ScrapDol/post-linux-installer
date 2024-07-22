#!/bin/bash


command_exists() {
    command -v "$1" >/dev/null 2>&1
}


install_neovim() {
    if command_exists nvim; then
        echo "Neovim уже установлен."
    else
        echo "Установка Neovim..."
        if command_exists pacman; then
            sudo pacman -Syu neovim
        else
            echo "Не удалось определить менеджер пакетов. Пожалуйста, установите Neovim вручную."
            exit 1
        fi
    fi
}



create_config() {
    config_dir="$HOME/.config/nvim"

    mkdir -p "$config_dir"

    echo "Создание базовой конфигурации Neovim..."
	

	git clone https://github.com/ScrapDol/nvim-config.git ~/.config/nvim

    echo "Базовая конфигурация Neovim создана в $config_file"

}






install_neovim

git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

create_config
install_plugins

echo "Настройка Neovim завершена. Вы можете запустить Neovim командой 'nvim'."


