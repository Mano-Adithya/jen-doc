# Use the official Nginx image from Docker Hub
FROM nginx:alpine

# Copy the HTML file into the Nginx HTML directory
COPY index2.html /usr/share/nginx/html/index.html
COPY script.js /usr/share/nginx/html/script.js

# Expose port 80 (Nginx default)
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
