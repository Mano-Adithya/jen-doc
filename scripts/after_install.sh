#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately
set -o pipefail  # Return the exit status of the last command in the pipe that failed

# Add swap space to the system to handle memory-intensive operations
if ! swapon --show | grep -q '/swapfile'; then
  sudo fallocate -l 1G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

# Navigate to the application directory
cd /var/www/myapp

# Clean up node_modules to avoid potential conflicts
rm -rf node_modules

# Install npm dependencies if package.json is present
if [ -f package.json ]; then
  npm install
  echo "npm install completed"
else
  echo "package.json not found, npm install skipped"
fi

# Ensure correct permissions and ownership
sudo chown -R www-data:www-data /var/www/myapp
sudo chmod -R 755 /var/www/myapp

# Restart Apache to ensure it picks up any changes
sudo systemctl restart apache2

echo "AfterInstall script completed successfully"
