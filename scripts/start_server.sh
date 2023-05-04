#!/bin/bash

# Set variables
APPID=1042420
STEAMCMD_DIR="$HOME/steamcmd"
SERVER_DIR="$HOME/dayzserver"
SERVER_CONFIG="$SERVER_DIR/serverDZ.cfg"
SERVER_PROFILE="$SERVER_DIR/profile"
SERVER_PORT=2302
SERVER_CPU_COUNT=4
SERVER_FPS=60

# Check if SERVER_DIR exists and create it if it doesn't exist
if [ ! -d "$SERVER_DIR" ]; then
  echo "Creating server directory: $SERVER_DIR"
  mkdir -p "$SERVER_DIR"
  $STEAMCMD_DIR/steamcmdmod.sh +login anonymous +force_install_dir $SERVER_DIR +app_update $APPID +quit
fi

cd "$SERVER_DIR"

export LD_LIBRARY_PATH="$SERVER_DIR:$STEAMCMD_DIR/linux32:$LD_LIBRARY_PATH"

# Function to check if Server is running
is_app_running() {
  pgrep -f "DayZServer" > /dev/null
}

# Function to validate the server
validate_server() {
  $STEAMCMD_DIR/steamcmdmod.sh +login anonymous +force_install_dir $SERVER_DIR +app_update $APPID validate +quit
}

# Function to update the server
update_server() {
  $STEAMCMD_DIR/steamcmdmod.sh +login anonymous +force_install_dir $SERVER_DIR +app_update $APPID +quit
}

# Function to start the server
start_server() {
  box64 "$SERVER_DIR/DayZServer" -config="$SERVER_CONFIG" -profiles="$SERVER_PROFILE" -port="$SERVER_PORT" -cpuCount="$SERVER_CPU_COUNT" -limitFPS="$SERVER_FPS" -adminLog -freezecheck
}

# Loop indefinitely
while true; do
  # Check if Server is running
  if ! is_app_running; then
    echo "$(date) Validating server files..."
    validate_server
    echo "$(date) Updating server..."
    update_server
    echo "$(date) Starting server..."
    start_server
  fi

  # Sleep for 30 seconds
  sleep 30
  echo "$(date) Server is running ..."
done
