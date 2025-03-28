#!/bin/bash

# Color variables
red="\033[31m\033[1m"
green="\033[0;32m\033[1m"
reset="\033[0m"

# Hardcoded username (consider making this configurable if needed)
git_username="Fosssil"
token_file="$HOME/token"

# Function to print section headers
print_section() {
  printf "\n"
  echo -e "${green}${1}${reset}"
}

warning_print_section() {
  echo -e "${red}${1}${reset}"
}

# Read GitHub token from file
print_section "Getting token file provided by $git_username from $token_file"
if [[ ! -f "$token_file" ]]; then
  warning_print_section "Error: $token_file not found. Please create it with you Github token."
  exit 1
fi
git_token=$(tr -d '[:space:]' <"$token_file")
if [[ -z "$git_token" ]]; then
  warning_print_section "Error: $token_file is empty. Please add your GitHub token to it."
  exit 1
fi

# Purge lock files
print_section "Purging lock files..."
if sudo rm -rf /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock /var/cache/apt/archives/; then
  echo "Purged"
else
  warning_print_section "Warning: Failed to purge lock files, continuing..."
fi

# Update apt repositories
print_section "Updating Repos..."
if ! sudo apt autoremove -y || ! sudo apt autoclean || ! sudo apt update; then
  warning_print_section "Warning: Repository update failed, continuing..."
fi

# Add unstable Neovim PPA
print_section "Adding unstable neovim PPA..."
sudo add-apt-repository ppa:neovim-ppa/unstable -y || warning_print_section "Warning: Failed to add PPA, continuing..."

# Install required packages
print_section "Installing required packages..."
packages=("git" "dialog" "ansible-core" "neovim" "hhh")
for pkg in "${packages[@]}"; do
  echo -e "+ $pkg"
done
if ! sudo apt install -y "${packages[@]}"; then
  warning_print_section "Warning: Some packages failed to install, continuing..."
fi

successfully_cloned() {
  echo "[*] Cloned successfully"
}

already_cloned() {
  echo "[*] Clone already exists, continuing..."
}
# Clone Neovim config
print_section "Cloning the Nvim Configs"
if git clone https://github.com/Fosssil/nvim.git "$HOME/.config/nvim" 2>/dev/null; then
  successfully_cloned
else
  already_cloned
fi

# Clone Migration Playbook
print_section "Cloning the Migration Playbook..."
clone_url="https://${git_username}:${git_token}@github.com/${git_username}/migration_playbook.git"
if git clone "$clone_url" "$HOME/migration_playbook" 2>/dev/null; then
  successfully_cloned
else
  already_cloned
fi
unset git_token # Clean up sensitive variable

# Install Neovim Lazy packages
print_section "Installing packages into Neovim..."
if command -v nvim >/dev/null 2>&1; then
  nvim --headless -c "Lazy install" -c "qa" 2>/dev/null && echo "[*] Lazy packages installed" || echo -e "${red}Warning: Lazy install failed${reset}"
else
  warning_print_section "Error: Neovim not found, skipping Lazy install"
fi

# Optional dialog menu (uncomment to enable)
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
# CHOICE=$(dialog --clear \
#   --backtitle "$BACKTITLE" \
#   --title "$TITLE" \
#   --menu "$MENU" \
#   $HEIGHT $WIDTH $CHOICE_HEIGHT \
#   "${OPTIONS[@]}" \
#   2>&1 >/dev/tty)
# clear
#
# case $CHOICE in
# 1) sudo apt full-upgrade -y ;;
# 2) sudo reboot now ;;
# 3) exit 0 ;;
# esac
