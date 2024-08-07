#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately
set -o pipefail  # Return the exit status of the last command in the pipe that failed

# Ensure Docker is running
sudo systemctl start docker

# Build and run the Docker containers

# For simple-html application
docker build -t simple-html-app /var/www/myapp/simple-html
docker run -d -p 8081:80 --name simple-html-app simple-html-app

# For new-html application
docker build -t new-html-app /var/www/myapp/new-html
docker run -d -p 8082:80 --name new-html-app new-html-app

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
