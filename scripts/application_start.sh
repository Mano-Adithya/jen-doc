#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately
set -o pipefail  # Return the exit status of the last command in the pipe that failed

# Print a message to indicate the start of the script
echo "Starting the application..."

# For simple-html application
if ! docker ps | grep -q simple-html-app; then
  docker start simple-html-app
fi

# For new-html application
if ! docker ps | grep -q new-html-app; then
  docker start new-html-app
fi

# Print a message indicating that the application has started
echo "Application started successfully."
