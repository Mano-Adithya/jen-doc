
# Use the official Nginx image from the Docker Hub
FROM nginx:alpine

# Copy the HTML file into the Nginx HTML directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 8080
EXPOSE 8081

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
