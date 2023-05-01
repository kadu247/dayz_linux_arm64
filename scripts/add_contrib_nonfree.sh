#!/bin/bash

# Backup the sources.list file
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# Check if "contrib" and "non-free" components are already present in sources.list
if grep -q "contrib\|non-free" /etc/apt/sources.list; then
  echo "The 'contrib' and 'non-free' components are already present in sources.list"
else
  # Add "contrib" and "non-free" components to the existing repository lines in sources.list
  sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list

  # Update the package lists
  sudo apt update

  echo "The 'contrib' and 'non-free' components have been added to sources.list"
fi
