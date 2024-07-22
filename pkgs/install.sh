# Detect the AUR wrapper
if pacman -Qi paru &>/dev/null ; then
   aurhelper="paru -S --skipreview"
elif pacman -Qi yay &>/dev/null ; then
   aurhelper="yay -S"
fi

# for x in $(cat arch_minimal.txt); do sudo pacman -S $x --noconfirm --needed; done
$aurhelper $(cat arch_minimal.txt)
