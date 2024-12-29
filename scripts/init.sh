#!/bin/bash

# Enable error checking
set -e

# Function for logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a /var/log/user-data.log
}

log "Starting initialization script"

# Update the system
log "Updating system packages"
sudo yum update -y

# Install Docker
log "Installing Docker"
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

# Install Docker Compose
log "Installing Docker Compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone the application repository
log "Cloning application repository"
git clone https://github.com/yourusername/TerraWebStack.git /home/ec2-user/TerraWebStack

# Change to the application directory
cd /home/ec2-user/TerraWebStack

# Build and start the Docker containers
log "Building and starting Docker containers"
docker-compose up -d

log "Initialization complete"