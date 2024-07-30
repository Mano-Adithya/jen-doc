# Use an official Nginx image
FROM nginx:alpine

# Copy the HTML file to the Nginx directory
COPY index2.html /usr/share/nginx/html/index.html

# Expose a different port, e.g., 8081
EXPOSE 8082

# Command to run Nginx and serve the file on the exposed port
CMD ["nginx", "-g", "daemon off;"]
