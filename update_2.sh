#!/bin/bash
red="\033[31m\033[1m"
green="\033[0;32m\033"
reset="\033[0m"

echo -e "${red}Purging lock files...${reset}"
sudo rm -rf /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock /var/cache/apt/archives/

echo ""
echo -e "${green} Updating Repos...${reset}"
sudo apt autoremove -y &&
  sudo apt autoclean &&
  sudo apt update &&
  echo ""
echo -e "${green} Adding unstable neovim PPA...${reset}"
sudo add-apt-repository ppa:neovim-ppa/unstable -y

echo ""
echo -e "${green} Checking for required packages...${reset}"
package=("git" "dialog" "ansible-core" "neovim")
for pkg in "${package[@]}"; do
  echo -e "+ $pkg"
  package_to_install+=("$pkg")
done
echo ""

function install {
  for package_install in "${package_to_install[@]}"; do
    echo "$package_install"
  done
}

sudo apt install "${package_to_install[@]}" -y
wait

printf "\n"
echo -e "${green} Cloning the Nvim Configs${reset}"
git clone https://github.com/Fosssil/nvim.git "$HOME/.config/nvim" || true

# HEIGHT=15
# WIDTH=40
# CHOICE_HEIGHT=5
# BACKTITLE="by SAGAR DAHIYA"
# TITLE="Made by Sagar Dahiya"
# MENU="Choose one of the following options:"
#
# OPTIONS=(
#   1 "Upgrade System"
#   2 "Reboot"
#   3 "Exit"
# )
#
# CHOICE=$(
#   dialog --clear \
#     --backtitle "$BACKTITLE" \
#     --title "$TITLE" \
#     --menu "$MENU" \
#     $HEIGHT $WIDTH $CHOICE_HEIGHT \
#     "${OPTIONS[@]}" \
#     2>&1 >/dev/tty
# )
# clear
#
# case $CHOICE in
# 1)
#   sudo apt full-upgrade -y
#   ;;
# 2)
#   sudo reboot now
#   ;;
# 3)
#   exit
#   ;;
# esac
