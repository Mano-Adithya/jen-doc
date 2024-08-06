#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately
set -o pipefail  # Return the exit status of the last command in the pipe that failed

# Add swap space to the system to handle memory-intensive operations
if ! swapon --show | grep -q '/swapfile'; then
  echo "Creating swap space..."
  sudo fallocate -l 1G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
else
  echo "Swap space already set up."
fi

# Navigate to the application directory
APP_DIR="/var/www/myapp"
if [ -d "$APP_DIR" ]; then
  cd "$APP_DIR"
else
  echo "Directory $APP_DIR not found, cannot proceed."
  exit 1
fi

# Clean up node_modules to avoid potential conflicts
echo "Removing existing node_modules..."
rm -rf node_modules

# Install npm dependencies if package.json is present
if [ -f package.json ]; then
  echo "Running npm install..."
  npm install
  echo "npm install completed"
else
  echo "package.json not found, npm install skipped"
fi

# Ensure correct permissions and ownership
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

echo "AfterInstall script completed successfully"
