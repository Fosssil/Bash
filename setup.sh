#!/bin/bash

# Color variables
red="\033[31m\033[1m"
green="\033[0;32m\033[1m"
yellow="\033[0;33m\033[1m"
reset="\033[0m"

# Hardcoded defaults (configurable via env vars)
git_username="Fosssil"
token_file="$HOME/token"

# Trap to clean up on exit or interruption
cleanup() {
  unset git_token
  print_section "Cleaned up sensitive data ^_^"
}
trap cleanup EXIT INT TERM

# Printing functions
print_section() {
  printf "\n"
  echo -e "${green}${1}${reset}"
}

print_warning() {
  echo -e "${red}${1}${reset}"
}

print_success() {
  echo -e "${yellow}${1}${reset}"
}

# Prompt for sudo password if not already cached
print_warning "This script requires sudo privileges.\nPlease enter your password if prompted."
if ! sudo -v; then
  print_warning "Error: Sudo authentication failed. Exiting."
  exit 1
fi

# Read GitHub token from file
print_section "Getting token file provided by $git_username from $token_file"
if [[ ! -f "$token_file" ]]; then
  print_warning "Error: $token_file not found. Please create it with your GitHub token."
  exit 1
else
  print_success "Got it..."
fi
git_token=$(tr -d '[:space:]' <"$token_file")
if [[ -z "$git_token" ]]; then
  print_warning "Error: $token_file is empty. Please add your GitHub token to it."
  exit 1
fi

# Purge lock files
print_section "Purging lock files..."
if sudo rm -rf /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock /var/cache/apt/archives/; then
  print_success "Purged"
else
  print_warning "Warning: Failed to purge lock files, continuing..."
fi

# Update apt repositories
print_section "Updating Repos..."
if sudo apt-get update && sudo apt-get autoremove -y >/dev/null && sudo apt-get autoclean >/dev/null; then
  print_success "Repositories updated"
else
  print_warning "Warning: Repository update failed, continuing..."
fi

# Getting number of upgradable packages
print_section "Checking upgradable packages"
number_of_upgradable="$(sudo apt list --upgradable 2>/dev/null | grep -vc "^Listing...")"
print_success "$number_of_upgradable packages are upgradable"

# Add unstable Neovim PPA
print_section "Adding unstable Neovim PPA..."
if find /etc/apt/keyrings -maxdepth 1 -type f -regex ".*/neovim.*" | grep -q .; then
  print_success "Neovim PPA already exist"
else
  command sudo add-apt-repository ppa:neovim-ppa/unstable -y || print_warning "Warning: Failed to add PPA, continuing..."
fi

# Add nodejs latest version
print_section "Adding Node.js source setup (v23.x)"
if [[ -f /etc/apt/sources.list.d/nodesource.list ]]; then
  print_success "Nodesource is already available"
else
  if curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh 2>/dev/null; then
    (
      sudo -E bash nodesource_setup.sh >/dev/null &
      pid=$!
      while kill -0 $pid 2>/dev/null; do
        printf "."
        sleep 1
      done
      echo ""
    ) &&
      print_success "Done"
    rm -f nodesource_setup.sh # removing temporary file
  else
    print_warning "Warning: Failed to download Node.js setup script, continuing..."
  fi
fi

# Install required packages
print_section "Installing required packages:"
packages=("git" "curl" "dialog" "ansible-core" "neovim" "nodejs")
printf "${yellow}+ %s\n${reset}" "${packages[@]}"
if sudo apt-get install -y "${packages[@]}" >/dev/null; then
  print_success "[*] Done"
else
  print_warning "Warning: Some packages failed to install, continuing..."
fi

# Node version
print_section "Node version on your system is..."
if command -v node >/dev/null 2>&1; then
  print_success "$(node -v)"
else
  print_warning "Warning: Node.js not found"
fi

# Clone Neovim config
print_section "Cloning the Nvim Configs"
nvim_dir="$HOME/.config/nvim"
if [[ -d "$nvim_dir" ]]; then
  print_success "Neovim config already exists, skipping clone"
elif git clone https://github.com/Fosssil/nvim.git "$nvim_dir" 2>/dev/null; then
  print_success "Cloned Neovim configs"
else
  print_warning "Warning: Failed to clone Neovim configs, continuing..."
fi

# Ansible language server
print_section "Installing ansible language server"
if sudo npm install -g @ansible/ansible-language-server; then
  print_success "Done"
else
  print_warning "Error: Failed to install als, continuing..."
fi

# Clone Migration Playbook
print_section "Cloning the Migration Playbook..."
playbook_dir="$HOME/migration_playbook"
clone_url="https://${git_username}:${git_token}@github.com/${git_username}/migration_playbook.git"
if [[ -d "$playbook_dir" ]]; then
  print_success "Migration Playbook already exists, skipping clone"
elif git clone "$clone_url" "$playbook_dir" 2>/dev/null; then
  print_success "Cloned Migration Playbook"
else
  print_warning "Warning: Failed to clone Migration Playbook, continuing..."
fi

# Install Neovim Lazy packages
print_section "Installing packages into Neovim..."
if command -v nvim >/dev/null 2>&1; then
  if [[ ! -d ~/.local/share/nvim/lazy ]]; then
    (
      nvim --headless -c "Lazy install" -c "qa" >/dev/null &
      pid=$!
      while kill -0 $pid 2>/dev/null; do
        printf "."
        sleep 1
      done
      echo ""
    ) &&
      print_success "Lazy packages installed"
  else
    print_success "Lazy packages already installed"
  fi
else
  print_warning "Error: Neovim not found, skipping Lazy install"
fi
