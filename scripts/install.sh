#!/bin/bash

# display warning message
echo "WARNING: This script is still in development and may cause issues. Use at your own risk!"
echo "Do you want to continue? (y/n)"
read -r choice

if [ "$choice" != "y" ]; then
  echo "Script aborted."
  exit 1
fi

# check if script is running in home directory, go there if not
if [ "$PWD" != "$HOME" ]; then
  echo "Moving to home directory..."
  cd ~
fi

# install some needed tools
clear
echo "Installing nano, wget, curl, git, and gpg..."
sleep 4
sudo apt update
sudo apt install -y nano wget curl git gpg

# enable arch needed to run box86
clear
echo "Enabling armhf architecture..."
sleep 4
sudo dpkg --add-architecture armhf
sudo apt update

# install box86
clear
echo "Installing box86..."
sleep 4
sudo wget https://itai-nelken.github.io/weekly-box86-debs/debian/box86.list -O /etc/apt/sources.list.d/box86.list
wget -qO- https://itai-nelken.github.io/weekly-box86-debs/debian/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg
sudo apt update && sudo apt install -y box86

# needed to start box86
clear
echo "Installing libc6:armhf..."
sleep 4
sudo apt install -y libc6:armhf

# install box64
clear
echo "Installing box64..."
sleep 4
sudo wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list
wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg
sudo apt update
sudo apt install -y box64

# check if steamcmd folder exists, create it if it doesn't
clear
if [ ! -d "steamcmd" ]; then
  echo "Creating steamcmd folder..."
  sleep 4
  mkdir steamcmd
fi

# navigate to steamcmd folder
cd steamcmd

# download and extract steamcmd
clear
echo "Downloading steamcmd..."
sleep 4
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# download steamcmdmod.sh script file
clear
echo "Downloading modded steamcmd script file to launch steamcmd emulated by box86..."
sleep 4
curl -sqL "https://raw.githubusercontent.com/kadu247/dayz_linux_arm64/main/scripts/steamcmdmod.sh" -o steamcmdmod.sh

clear
echo "All done!"
echo "Don't forget to configure serverDZ.cfg file. Also the startdayz.sh file with, for example, the number of cores your machine has."
echo "Run ./startdayz.sh to start the server"
