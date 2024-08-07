#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately
set -o pipefail  # Return the exit status of the last command in the pipe that failed

# Ensure Docker is running
echo "Starting Docker..."
sudo systemctl start docker

# Build and run the Docker containers

# For simple-html application
echo "Building Docker image for simple-html..."
docker build -t simple-html-app /var/www/myapp/simple-html || {
  echo "Failed to build simple-html-app image"
  exit 1
}

# Remove existing container if it exists
if docker ps -a --format '{{.Names}}' | grep -q 'simple-html-app'; then
  echo "Removing existing simple-html-app container..."
  docker stop simple-html-app || true
  docker rm simple-html-app || true
fi

echo "Running Docker container for simple-html..."
docker run -d -p 8083:80 --name simple-html-app simple-html-app || {
  echo "Failed to run simple-html-app container"
  exit 1
}

# For new-html application
echo "Building Docker image for new-html..."
docker build -t new-html-app /var/www/myapp/new-html || {
  echo "Failed to build new-html-app image"
  exit 1
}

# Remove existing container if it exists
if docker ps -a --format '{{.Names}}' | grep -q 'new-html-app'; then
  echo "Removing existing new-html-app container..."
  docker stop new-html-app || true
  docker rm new-html-app || true
fi

echo "Running Docker container for new-html..."
docker run -d -p 8084:80 --name new-html-app new-html-app || {
  echo "Failed to run new-html-app container"
  exit 1
}

# Ensure correct permissions and ownership
APP_DIR="/var/www/myapp"
echo "Setting permissions and ownership..."
sudo chown -R www-data:www-data "$APP_DIR"
sudo chmod -R 755 "$APP_DIR"

# Restart Nginx to ensure it picks up any changes
echo "Restarting Nginx..."
if command -v nginx > /dev/null; then
  sudo systemctl restart nginx
else
  echo "Nginx service not found, cannot restart."
  exit 1
fi

echo "AfterInstall script completed successfully."
