#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found."
    exit 1
fi

# Create directories if they don't exist
mkdir -p ssl acme

# Check if domain is set
if [ -z "$DOMAIN" ]; then
    echo "Error: DOMAIN is not set in .env file."
    exit 1
fi

# Check if email is set
if [ -z "$EMAIL" ]; then
    echo "Error: EMAIL is not set in .env file."
    exit 1
fi

# Initialize certificate
echo "Initializing SSL certificate for $DOMAIN..."
docker-compose run --rm acme --issue --webroot /acme -d $DOMAIN --email $EMAIL --force

# Deploy certificate
echo "Deploying SSL certificate..."
docker-compose run --rm acme --install-cert -d $DOMAIN \
    --key-file       /ssl/key.pem \
    --fullchain-file /ssl/cert.pem

# Set proper permissions
chmod -R 755 ssl acme

echo "SSL certificate setup completed."
echo "You can start the proxy service by running: docker-compose up -d" 