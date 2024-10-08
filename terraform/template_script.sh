#!bin/bash

# Update package list and install prerequisites
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release -y

# Create keyrings directory for Docker's GPG key
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null

# Add Docker's official repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again after adding Docker repo
sudo apt-get update

# Install Docker Engine, CLI, containerd, and plugins
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Verify Docker installation
sudo docker --version

# Pull the Docker image and run the container
sudo docker pull pablop115/auth
sudo docker run -d -p 3001:3001 pablop115/auth