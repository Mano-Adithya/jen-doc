#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately
set -o pipefail  # Return the exit status of the last command in the pipe that failed

# Ensure Docker is running
sudo systemctl start docker

# Remove any existing Docker containers with the same names to avoid conflicts
docker rm -f simple-html-app || true
docker rm -f new-html-app || true

# Build and run the Docker containers

# For simple-html application
docker build -t simple-html-app /var/www/myapp/simple-html
docker run -d -p 8083:80 --name simple-html-app simple-html-app

# For new-html application
docker build -t new-html-app /var/www/myapp/new-html
docker run -d -p 8084:80 --name new-html-app new-html-app

# Ensure correct permissions and ownership
APP_DIR="/var/www/myapp"
echo "Setting permissions and ownership..."
sudo chown -R www-data:www-data "$APP_DIR"
sudo chmod -R 755 "$APP_DIR"

# Check and update Nginx configuration if necessary
NGINX_CONF="/etc/nginx/nginx.conf"
if grep -q "listen 8083;" "$NGINX_CONF" || grep -q "listen 8084;" "$NGINX_CONF"; then
  echo "Updating Nginx configuration to avoid port conflicts..."
  sudo sed -i '/listen 8083;/d' "$NGINX_CONF"
  sudo sed -i '/listen 8084;/d' "$NGINX_CONF"
  sudo nginx -t
fi

# Restart Nginx to ensure it picks up any changes
echo "Restarting Nginx..."
if command -v nginx > /dev/null; then
  sudo systemctl restart nginx || { 
    echo "Failed to restart Nginx, checking status..."; 
    sudo systemctl status nginx.service; 
    exit 1; 
  }
else
  echo "Nginx service not found, cannot restart."
  exit 1
fi

echo "AfterInstall script completed successfully."
