#!/bin/bash

# Find package manager
if command -v brew &> /dev/null; then
    package_manager="brew install"
else
    declare -A osInfo;
    osInfo[/etc/arch-release]="sudo pacman --noconfirm -S"
    osInfo[/etc/fedora-release]="sudo dnf install -y"
    osInfo[/etc/centos-release]="sudo yum install -y"
    osInfo[/etc/gentoo-release]="sudo emerge"
    osInfo[/etc/SuSE-release]="sudo zypper install"
    osInfo[/etc/debian_version]="sudo apt-get install -y"
    osInfo[/etc/alpine-release]="sudo apk --update add"
    for f in ${!osInfo[@]}
    do
        if [[ -f $f ]];then
            package_manager=${osInfo[$f]}
        fi
    done
fi

if ! command -v stow &> /dev/null; then
    $package_manager "stow"
fi

echo "GIT: Cloning submodules..."
git submodule update --init

set -e
# SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOT_FOLDERS="bin,waybar,swww,rofi,swaylock,wlogout,swaync,hypr,alacritty,cava,dunst,gwe,kitty,lf,MangoHud,neofetch,ranger,tmux,neovim,bash,zsh"

for folder in $(echo $DOT_FOLDERS | sed "s/,/ /g"); do
    # echo "[+] SYMLINK :: $folder"

    stow -t $HOME -D $folder -v \
        --ignore=README.md --ignore=LICENSE \
        2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2)
    stow -t $HOME $folder -v \
        2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2)
done

# Reload shell once installed
echo "Reloading shell..."
echo "Done!"
exec $SHELL -l
