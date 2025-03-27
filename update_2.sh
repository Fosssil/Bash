#!/bin/bash
echo -e "\033[31m\033[1m Purging lock files...\033[0m"
sudo rm -rf /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock /var/cache/apt/archives/
sudo apt autoremove -y &&
  sudo apt autoclean &&
  sudo apt update &&
  sudo add-apt-repository ppa:neovim-ppa/unstable -y

echo -e "\033[0;32mChecking for required packages...\033[0m"
package=("git" "dialog" "ansible-core" "neovim")

for pkg in "${package[@]}"; do
  not
  if [ "$(command -v "$pkg")" ]; then
    echo -e "+ $pkg"
  else
    package_to_install+=("$pkg")
  fi
done

function install {
  for package_install in "${package_to_install[@]}"; do
    echo "$package_install"
  done
}
packagesNeeded=$(install)
length=${#package_to_install[@]}
echo ""
if [ "$length" -eq 0 ]; then
  echo -e "All packages are installed"
  echo ""
else
  echo "Not Installed: "
  echo "$packagesNeeded"
  echo ""
  sudo apt install "${package_to_install[@]}" -y
fi
wait

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=5
BACKTITLE="by SAGAR DAHIYA"
TITLE="Made by Sagar Dahiya"
MENU="Choose one of the following options:"

OPTIONS=(
  1 "Upgrade System"
  2 "Reboot"
  3 "Exit"
)

CHOICE=$(
  dialog --clear \
    --backtitle "$BACKTITLE" \
    --title "$TITLE" \
    --menu "$MENU" \
    $HEIGHT $WIDTH $CHOICE_HEIGHT \
    "${OPTIONS[@]}" \
    2>&1 >/dev/tty
)
clear

case $CHOICE in
1)
  sudo apt full-upgrade -y
  ;;
2)
  sudo reboot now
  ;;
3)
  exit
  ;;
esac
