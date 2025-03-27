#!/bin/bash
sudo rm -rf /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock /var/cache/apt/archives/
sudo apt autoremove -y
sudo apt autoclean
sudo apt update
sudo apt full-upgrade



HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=5
BACKTITLE="by SAGAR DAHIYA"
TITLE="Made by Sagar Dahiya"
MENU="Choose one of the following options:"

OPTIONS=(1 "Reboot"
  2 "Exit"

CHOICE=$(dialog --clear \
  --backtitle "$BACKTITLE" \
  --title "$TITLE" \
  --menu "$MENU" \
  $HEIGHT $WIDTH $CHOICE_HEIGHT \
  "${OPTIONS[@]}" \
  2>&1 >/dev/tty)

clear
case $CHOICE in
1)
  sudo reboot now
  ;;
2)
  exit
  ;;
esac

My name is Sagar
