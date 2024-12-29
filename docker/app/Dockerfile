# Use the official Nginx image as a parent image
FROM nginx:alpine

# Copy the static website files to the Nginx public folder
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]