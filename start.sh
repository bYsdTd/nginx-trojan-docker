#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found."
    exit 1
fi

# Process Trojan config template
echo "Configuring Trojan..."
cat trojan/config.json | envsubst > trojan/config.json.tmp
mv trojan/config.json.tmp trojan/config.json

# Check for SSL certificates
if [ ! -f ssl/cert.pem ] || [ ! -f ssl/key.pem ]; then
    echo "SSL certificates not found. Run ./init-cert.sh first."
    exit 1
fi

# Start the services
echo "Starting services..."
docker-compose up -d

echo "Setup completed. Service should be running at https://$DOMAIN" 