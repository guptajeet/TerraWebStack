#!/bin/bash

# Enable error checking
set -e

# Function for logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a /var/log/user-data.log
}

log "Starting initialization script for app instance"

# Update the system
log "Updating system packages"
sudo yum update -y

# Install Docker
log "Installing Docker"
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user


log "Installing Docker Compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Git
log "Installing Git"
sudo yum install -y git

# Clone the application repository
log "Cloning application repository"
git clone https://github.com/guptajeet/TerraWebStack /home/ec2-user/TerraWebStack

#
sudo dnf install mariadb105 -y

# Change to the application directory
cd /home/ec2-user/TerraWebStack

# Build and start the app Docker container
log "Building and starting app Docker container"
docker-compose up -d app

log "App instance initialization complete"

