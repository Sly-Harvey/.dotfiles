#!/bin/bash

echo "[*] Cloning submodules..."
git submodule update --init

set -e
# SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOT_FOLDERS="bin,alacritty,cava,dunst,gwe,hypr,kitty,lf,MangoHud,neofetch,ranger,rofi,swww,tmux,neovim,bash,zsh"

if ! command -v stow &> /dev/null; then
    if command -v apt &> /dev/null; then
        sudo apt install -y stow
    else
        sudo pacman -S stow
    fi
fi

for folder in $(echo $DOT_FOLDERS | sed "s/,/ /g"); do
    # echo "[+] SYMLINK :: $folder"

    stow -t $HOME -D $folder -v \
        --ignore=README.md --ignore=LICENSE \
        2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2)
    stow -t $HOME $folder -v \
        2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2)
done

# Reload shell once installed
echo "[*] Reloading shell..."
exec $SHELL -l
echo "[*] Done!"
