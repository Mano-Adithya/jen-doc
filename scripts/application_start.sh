#!/bin/bash

# Print a message to indicate the start of the script
echo "Starting the application..."

# Navigate to the application directory
cd /var/www/myapp

# Start the application
/usr/bin/npm start 

# Print a message indicating that the application has started
echo "Application started successfully."
