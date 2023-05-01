#!/bin/bash

#version=26
#appid=1042420
#dayz_id=221100
#stable=223350
#exp_branch=1042420

export LD_LIBRARY_PATH="$HOME/lib:$HOME/Steam/linux32:$HOME/Steam/linux64:$HOME/dayzserver:$LD_LIBRARY_PATH"
export PATH="$HOME/lib:$HOME/Steam/linux32:$HOME/Steam/linux64:$HOME/dayzserver:$PATH"

# Function to check if Server is running
is_app_running() {
  pgrep -f "DayZServer" > /dev/null
}

# Loop indefinitely
while true; do
  # Check if ./app is running
  if ! is_app_running; then
    echo "Update Server"
    box64 /home/ubuntu/Steam/linux32/steamcmd +force_install_dir /home/ubuntu/dayzserver +login anonymous +app_update 1042420 +quit
    echo "Restarting Server"
    box64 DayZServer -config=serverDZ.cfg -profiles=profile -port=2302 -cpuCount=4 -freezecheck
  fi

  # Sleep for 15 seconds
  sleep 15
done
