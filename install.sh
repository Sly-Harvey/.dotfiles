#!/bin/bash

echo "[*] Cloning submodules..."
git submodule update --init

set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOT_FOLDERS="bin,alacritty,cava,dunst,gwe,hypr,kitty,lf,MangoHud,neofetch,ranger,rofi,swww,tmux,neovim,zsh"

if ! command -v stow &> /dev/null; then
    if command -v apt &> /dev/null; then
        sudo apt install -y stow
    else
        sudo pacman -S stow
    fi
fi

for folder in $(echo $DOT_FOLDERS | sed "s/,/ /g"); do
    echo "[+] Folder :: $folder"

    stow -t $HOME -D $folder \
        --ignore=README.md --ignore=LICENSE 
    stow -t $HOME $folder
done

# Reload shell once installed
echo "[*] Reloading shell..."
exec $SHELL -l
