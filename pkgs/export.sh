pushd ~/.dotfiles/ &> /dev/null
rm ./pkgs/arch_packages_list.txt &> /dev/null
pacman -Qe | awk '{print $1}' > ./pkgs/arch_packages_list.txt
echo "Packages exported to arch_packages_list.txt"
popd &> /dev/null
