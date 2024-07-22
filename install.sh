#!/bin/bash

echo "GIT: Cloning submodules..."
git submodule update --init

# Find package manager
if command -v brew &> /dev/null; then
    package_manager="brew install"
else
    declare -A osInfo;
    osInfo[/etc/arch-release]="pacman --noconfirm -S"
    osInfo[/etc/fedora-release]="dnf install -y"
    osInfo[/etc/centos-release]="yum install -y"
    osInfo[/etc/gentoo-release]="emerge"
    osInfo[/etc/SuSE-release]="zypper install"
    osInfo[/etc/debian_version]="apt-get install -y"
    osInfo[/etc/alpine-release]="apk --update add"
    for f in ${!osInfo[@]}
    do
        if [[ -f $f ]];then
            package_manager=${osInfo[$f]}
        fi
    done
fi

if ! command -v stow &> /dev/null; then
    sudo $package_manager "stow"
fi

# sddm theme
sudo cp -r ./system/auto/sddm-astronaut-theme /usr/share/sddm/themes
sudo cp ./system/auto/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf

# gtk themes
sudo cp -r ./system/auto/catppuccin-macchiato-mauve-compact /usr/share/themes
sudo cp -r ./system/auto/Tokyonight-Dark-BL-LB /usr/share/themes
sudo cp -r ./system/auto/Tokyonight-Light-B-LB /usr/share/themes

set -e

for folder in configs/*; do
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
