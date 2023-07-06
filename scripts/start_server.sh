#!/bin/bash

set -e

# Set variables
APPID=1042420
STEAMCMD_DIR="$HOME/steamcmd"
SERVER_DIR="$HOME/dayzserver"
SERVER_CONFIG="$SERVER_DIR/serverDZ.cfg"
SERVER_PROFILE="$SERVER_DIR/profile"
SERVER_PORT=2302
SERVER_CPU_COUNT=4
SERVER_FPS=60
SERVER_IP="0.0.0.0"

CUSTOM_INIT="$HOME/scripts/init.c"
USE_CUSTOM_INIT="1"

# Check if SERVER_DIR exists and create it if it doesn't exist
if [ ! -d "$SERVER_DIR" ]; then
  echo "Creating server directory: $SERVER_DIR"
  mkdir -p "$SERVER_DIR"
  "$STEAMCMD_DIR/steamcmd_arm.sh" +login anonymous +force_install_dir "$SERVER_DIR" +app_update "$APPID" +quit
fi

cd "$SERVER_DIR"

export LD_LIBRARY_PATH="$SERVER_DIR:$STEAMCMD_DIR/linux32:$HOME/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"

# Function to check if Server is running
is_app_running() {
  pgrep -f "DayZServer" > /dev/null
}

# Function to update the server
update_server() {
  "$STEAMCMD_DIR/steamcmd_arm.sh" +login anonymous +force_install_dir "$SERVER_DIR" +app_update "$APPID" +quit
}

# Function to validate the server
validate_server() {
  "$STEAMCMD_DIR/steamcmd_arm.sh" +login anonymous +force_install_dir "$SERVER_DIR" +app_update "$APPID" validate +quit
}

# Function to start the server
start_server() {
  box64 "$SERVER_DIR/DayZServer" -ip="$SERVER_IP" -port="$SERVER_PORT" -config="$SERVER_CONFIG" -profiles="$SERVER_PROFILE" -mod= -servermod= -bepath= -limitFPS="$SERVER_FPS" -adminLog -freezecheck
}

# Loop indefinitely
while true; do
  # Check if Server is running
  if ! is_app_running; then
    echo "$(date) Updating server..."
    update_server
    echo "$(date) Validating server files..."
    validate_server
    if [[ "$USE_CUSTOM_INIT" == "1" ]]; then
      echo "$(date) Use custom init.c..."
      # Remove the existing init.c file
      rm "$SERVER_DIR/mpmissions/dayzOffline.chernarusplus/init.c" || true
      # Copy the custom init.c file to the server directory
      cp "$CUSTOM_INIT" "$SERVER_DIR/mpmissions/dayzOffline.chernarusplus/init.c"
    elif [[ "$USE_CUSTOM_INIT" == "0" ]]; then
      echo "$(date) Custom init.c not used."
    fi
    echo "$(date) Starting server..."
    start_server
  fi

  # Sleep for 60 seconds
  sleep 60
  echo "$(date) Server is running ..."
done
