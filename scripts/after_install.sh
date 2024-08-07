#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately
set -o pipefail  # Return the exit status of the last command in the pipe that failed

# Ensure Docker is running
echo "Starting Docker..."
sudo systemctl start docker

# Function to build and run Docker container
run_docker_container() {
    local app_name=$1
    local app_dir=$2
    local port=$3
    
    echo "Building Docker image for $app_name..."
    docker build -t "${app_name}-app" "${app_dir}" || {
      echo "Failed to build ${app_name}-app image"
      exit 1
    }

    # Remove existing container if it exists
    if docker ps -a --format '{{.Names}}' | grep -q "${app_name}-app"; then
      echo "Removing existing ${app_name}-app container..."
      docker stop "${app_name}-app" || true
      docker rm "${app_name}-app" || true
    fi

    # Check if the port is already in use and kill the process using it
    if lsof -i:"${port}" -t >/dev/null; then
      echo "Port ${port} is already in use, killing the process..."
      fuser -k "${port}/tcp"
    fi

    echo "Running Docker container for $app_name on port ${port}..."
    docker run -d -p "${port}:80" --name "${app_name}-app" "${app_name}-app" || {
      echo "Failed to run ${app_name}-app container"
      exit 1
    }
}

# Run Docker containers
run_docker_container "simple-html" "/var/www/myapp/simple-html" 8081
run_docker_container "new-html" "/var/www/myapp/new-html" 8082

# Ensure correct permissions and ownership
APP_DIR="/var/www/myapp"
echo "Setting permissions and ownership..."
sudo chown -R www-data:www-data "$APP_DIR"
sudo chmod -R 755 "$APP_DIR"

# Validate Nginx configuration
echo "Validating Nginx configuration..."
if sudo nginx -t; then
  echo "Nginx configuration is valid, restarting Nginx..."
  sudo systemctl restart nginx || {
    echo "Failed to restart Nginx, checking status..."
    sudo systemctl status nginx.service
    sudo journalctl -xeu nginx.service
    exit 1
  }
else
  echo "Nginx configuration is invalid, cannot restart Nginx."
  sudo nginx -t
  exit 1
fi

echo "AfterInstall script completed successfully."
