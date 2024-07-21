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
    config_file="$config_dir/init.lua"

    mkdir -p "$config_dir"
    touch "$config_file"

    echo "Создание базовой конфигурации Neovim на Lua..."
    cat << EOF > "$config_file"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.mouse = 'a'

-- Установка клавиши leader
vim.g.mapleader = " "

vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':q!<CR>', { noremap = true, silent = true })


vim.cmd('syntax enable')



vim.opt.laststatus = 2





vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

end)

EOF

    echo "Базовая конфигурация Neovim на Lua создана в $config_file"

}






install_neovim

git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

create_config
install_plugins

echo "Настройка Neovim завершена. Вы можете запустить Neovim командой 'nvim'."


