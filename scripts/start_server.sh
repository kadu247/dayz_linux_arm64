#!/bin/bash

# Set variables
APPID=1042420
STEAMCMD_DIR="$HOME/steamcmd"
SERVER_DIR="$HOME/dayzserver"
SERVER_CONFIG="$SERVER_DIR/serverDZ.cfg"
SERVER_PROFILE="$SERVER_DIR/profile"
SERVER_PORT=2302
SERVER_CPU_COUNT=4

# Check if server files exists, create and install dayz server if it doesn't exist
if [ ! -d "$SERVER_DIR" ]; then
  echo "Creating server directory: $SERVER_DIR"
  mkdir -p "$SERVER_DIR"
  $STEAMCMD_DIR/steamcmd_arm.sh +login anonymous +force_install_dir $SERVER_DIR +app_update $APPID +quit
fi

cd "$SERVER_DIR"

export LD_LIBRARY_PATH="$SERVER_DIR:$LD_LIBRARY_PATH"

# Function to check if Server is running
is_app_running() {
  pgrep -f "DayZServer" > /dev/null
}

# Function to get the latest version number from Steam
get_latest_version() {
  $STEAMCMD_DIR/steamcmd_arm.sh +login anonymous +app_info_print $APPID +quit | grep -m1 -Po '"buildid" "\K\d+'
}

# Function to validate the server
validate_server() {
  $STEAMCMD_DIR/steamcmd_arm.sh +login anonymous +force_install_dir $SERVER_DIR +app_update $APPID validate +quit
}

# Function to update the server
update_server() {
  $STEAMCMD_DIR/steamcmd_arm.sh +login anonymous +force_install_dir $SERVER_DIR +app_update $APPID +quit
}

# Function to start the server
start_server() {
  box64 "$SERVER_DIR/DayZServer" -config="$SERVER_CONFIG" -profiles="$SERVER_PROFILE" -port="$SERVER_PORT" -cpuCount="$SERVER_CPU_COUNT" -freezecheck
}

# Loop indefinitely
while true; do
  # Check if Server is running
  if ! is_app_running; then
    echo "Checking for updates..."
    current_version=$(cat "$SERVER_DIR/steamapps/appmanifest_$APPID.acf" | grep -Po '"buildid" "\K\d+')
    latest_version=$(get_latest_version)

    if [ "$current_version" != "$latest_version" ]; then
      echo "An update is available. Validating server files..."
      validate_server
      echo "Updating server..."
      update_server
    else
      echo "Server is up to date."
    fi

    echo "Starting server..."
    start_server
  fi

  # Sleep for 15 seconds
  sleep 15
done
