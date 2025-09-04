#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status
set -o pipefail # Prevent errors in a pipeline from being masked
set -u # Treat unset variables as an error

export DEBIAN_FRONTEND=noninteractive

# Update package lists and upgrade installed packages
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold upgrade

# Install necessary packages
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold install nginx curl wget

# Install Node.js (LTS version) and npm
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold nodejs

# Create application directory and set ownership
sudo mkdir /opt/app
sudo chown -R "$USER":"$USER" /opt/app

# Install PM2 globally using npm
sudo npm install -g pm2

# nginx configuration
cat << EOF | sudo tee /etc/nginx/sites-available/default
upstream app_upstream {
  server 127.0.0.1:3000;
  keepalive 64;
}

server {
  listen 80 default_server;
  listen [::]:80 default_server;
  server_name _;

  location / {
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header Host \$http_host;

    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_pass http://app_upstream/;
    proxy_redirect off;
    proxy_read_timeout 240s;
  }
}
EOF

# Test Nginx configuration and restart the service
sudo nginx -t
sudo systemctl enable --now nginx
sudo systemctl restart nginx
