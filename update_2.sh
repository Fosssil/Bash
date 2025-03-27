#!/bin/bash
echo -e "\033[31m\033[1mPurging lock files...\033[0m"
sudo rm -rf /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock /var/cache/apt/archives/

echo -e "\033[31m\033[1mUpdating Repos...\033[0m"
echo ""
sudo apt autoremove -y &&
  sudo apt autoclean &&
  sudo apt update &&
  sudo add-apt-repository ppa:neovim-ppa/unstable -y

echo ""
echo -e "\033[0;32mChecking for required packages...\033[0m"
package=("git" "dialog" "ansible-core" "neovim")
echo ""

for pkg in "${package[@]}"; do
  echo -e "+ $pkg"
  package_to_install+=("$pkg")
done

function install {
  for package_install in "${package_to_install[@]}"; do
    echo "$package_install"
  done
}

sudo apt install "${package_to_install[@]}" -y
wait

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
