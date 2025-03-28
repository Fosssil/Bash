#!/bin/bash
red="\033[31m\033[1m"
green="\033[0;32m\033[1m"
reset="\033[0m"

read -rp "$(echo -e "${green}Enter your Github Username: ${reset}")" git_username

token_file="$HOME/token"
echo -e "${green}Getting token file from $token_file${reset}"
if [[ -f "$token_file" ]]; then
  git_token=$(tr -d '[:space:]' <"$token_file") # Read and trim whitespace
  if [[ -z "$git_token" ]]; then
    echo -e "${red}Error: $token_file is empty. Please add your GitHub token to it.${reset}"
    exit 1
  fi
else
  echo -e "${red}Error: $token_file not found. Please create it with your GitHub token.${reset}"
  exit 1
fi

printf "\n"
echo -e "${red}Purging lock files...${reset}"
sudo rm -rf /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock /var/cache/apt/archives/ && echo "Purged"

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
git clone https://github.com/Fosssil/nvim.git "$HOME/.config/nvim" 2>/dev/null && echo "[*] Cloned successfully" || echo "[*] No need to clone"

printf "\n"
echo -e "${green}Cloning the Migration Playbook...${reset}"
git clone "https://${git_username}:${git_token}@github.com/${git_username}/migration_playbook.git" "$HOME/migration_playbook" 2>/dev/null && echo "[*] Cloned successfully" || echo "[*] No need to clone"

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
