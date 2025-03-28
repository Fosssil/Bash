#!/bin/bash
red="\033[31m\033[1m"
green="\033[0;32m\033[1m"
yellow="\033[33m\033[1m"
reset="\033[0m"

read -rp "$(echo -e "${green}Enter your ${yellow}Github Username${green}: ${reset}")" git_username
read -rsp "${green}Enter your Github Token: ${reset}" git_token
printf "\n"

echo -e "${red}Purging lock files...${reset}"
sudo rm -rf /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock /var/cache/apt/archives/

printf "\n"
echo -e "${green}Updating Repos...${reset}"
sudo apt autoremove -y &&
  sudo apt autoclean &&
  sudo apt update &&
  printf "\n"

echo -e "${green}Adding unstable neovim PPA...${reset}"
sudo add-apt-repository ppa:neovim-ppa/unstable -y

printf "\n"
echo -e "${green}Checking for required packages...${reset}"
package=("git" "dialog" "ansible-core" "neovim")
for pkg in "${package[@]}"; do
  echo -e "+ $pkg"
  package_to_install+=("$pkg")
done

printf "\n"
function install {
  for package_install in "${package_to_install[@]}"; do
    echo "$package_install"
  done
}

sudo apt install "${package_to_install[@]}" -y
wait

printf "\n"
echo -e "${green}Cloning the Nvim Configs${reset}"
git clone https://github.com/Fosssil/nvim.git "$HOME/.config/nvim" 2>/dev/null || echo -e "[*] Cloned"

printf "\n"
echo -e "${green}Cloning the Migration Playbook...${reset}"
git clone "https://${git_username}:${git_token}@github.com/${git_username}/migration_playbook.git" "$HOME/migration_playbook" 2>/dev/null || echo "[*] Cloned"

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
