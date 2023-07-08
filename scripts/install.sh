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
clear
if [ "$PWD" != "$HOME" ]; then
  echo "Moving to home directory..."
  sleep 4
  cd ~
fi

# install some needed tools
clear
echo "Installing needed tools..."
sleep 4
sudo apt update
sudo apt install -y nano wget curl git tmux gpg

# enable arch needed to run box86
clear
echo "Enabling armhf, i386 and amd64 architectures..."
sleep 4
sudo dpkg --add-architecture armhf
sudo dpkg --add-architecture i386
sudo dpkg --add-architecture amd64
sudo apt update

# Add contrib" and "non-free to debian sources
# Backup the sources.list file
clear
echo "Add contrib and non-free to debian sources..."
sleep 4
# Check if "contrib" and "non-free" components are already present in sources.list
if grep -q "contrib\|non-free" /etc/apt/sources.list; then
  echo "The 'contrib' and 'non-free' components are already present in sources.list"
else
  # Backup the sources.list file
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
  # Add "contrib" and "non-free" components to the existing repository lines in sources.list
  sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
  # Update the package lists
  sudo apt update
  echo "The 'contrib' and 'non-free' components have been added to sources.list"
fi

# install box86
clear
echo "Installing box86..."
sleep 4
sudo wget https://itai-nelken.github.io/weekly-box86-debs/debian/box86.list -O /etc/apt/sources.list.d/box86.list
wget -qO- https://itai-nelken.github.io/weekly-box86-debs/debian/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg
sudo apt update && sudo apt install -y box86

# needed to start box86
clear
echo "Installing libraries needed to run Box86..."
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
clear
echo "Moving to steamcmd directory..."
sleep 4
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
curl -sqL "https://raw.githubusercontent.com/kadu247/dayz_linux_arm64/main/scripts/steamcmd_arm.sh" -o steamcmd_arm.sh
chmod +x steamcmd_arm.sh

# download start_server.sh script file
clear
cd ~
echo "Downloading script to start Dayz Server emulated by box64..."
sleep 4
curl -sqL "https://raw.githubusercontent.com/kadu247/dayz_linux_arm64/main/scripts/start_server.sh" -o start_server.sh
chmod +x start_server.sh

# needed to start dayz server
clear
echo "Installing libraries needed to run Dayz Server..."
sleep 4
sudo apt install -y libcap2:amd64
sudo apt install -y libsdl2-2.0-0

# Delete unneeded scripts
clear
echo "Delete unneeded install scripts..."
sleep 4
rm install.sh

clear
echo "All done!"
echo "Don't forget to configure serverDZ.cfg file. Also the startdayz.sh file with, for example, the number of cores your machine has."
echo "Run ./startdayz.sh to start the server"
