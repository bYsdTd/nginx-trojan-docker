#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found."
    exit 1
fi

# Create directories if they don't exist
mkdir -p ssl acme acme.sh

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

# Check if ACME server URL is set
if [ -z "$ACME_SERVER" ]; then
    echo "Error: ACME_SERVER is not set in .env file."
    exit 1
fi

# Set WWW subdomain
WWW_DOMAIN="www.$DOMAIN"

# Initialize certificate using FreeSSL.cn
echo "Initializing SSL certificate for $DOMAIN and $WWW_DOMAIN using FreeSSL.cn..."
docker-compose run --rm acme --issue -d $DOMAIN -d $WWW_DOMAIN --dns dns_dp --server $ACME_SERVER --email $EMAIL --force

# Check if certificate files exist in the acme.sh directory
if [ -d "acme.sh/${DOMAIN}_ecc" ]; then
    echo "Certificate files found. Copying to ssl directory..."
    cp "acme.sh/${DOMAIN}_ecc/${DOMAIN}.key" ssl/key.pem
    cp "acme.sh/${DOMAIN}_ecc/fullchain.cer" ssl/cert.pem
    echo "Certificate files copied successfully."
else
    echo "Certificate files not found in acme.sh/${DOMAIN}_ecc directory."
    echo "Trying to deploy using acme.sh..."
    
    # Try to deploy using acme.sh
    docker-compose run --rm acme --install-cert -d $DOMAIN --ecc \
        --key-file       /ssl/key.pem \
        --fullchain-file /ssl/cert.pem
fi

# Set proper permissions
chmod -R 755 ssl acme acme.sh

echo "SSL certificate setup completed."
echo "You can start the proxy service by running: docker-compose up -d" 