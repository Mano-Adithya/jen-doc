#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately
set -o pipefail  # Return the exit status of the last command in the pipe that failed

# Function to log messages
log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_message "Starting before_install script..."

# Add swap space to the system to handle memory-intensive operations
if ! swapon --show | grep -q '/swapfile'; then
  log_message "Creating swap space..."
  sudo fallocate -l 1G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
else
  log_message "Swap space already set up."
fi

# Install Docker if not installed
if ! [ -x "$(command -v docker)" ]; then
  log_message 'Docker is not installed. Installing Docker...'
  apt-get update
  apt-get install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
else
  log_message 'Docker is already installed.'
fi

# Cleanup old Docker containers and images (optional)
docker system prune -af

log_message "before_install script completed."
