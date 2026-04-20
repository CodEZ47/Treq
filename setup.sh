#!/bin/bash
set -e

# Check if openssl is installed
if which openssl > /dev/null 2>&1 ; then
    echo "OpenSSL found..."
else
    echo "Please install openssl"
    exit 1
fi

# Create ssl directory if it doesn't exist
mkdir -p nginx/ssl


# Create key, cert and diffie hellman param file if they don't exisit
if [[ -f nginx/ssl/treq.key && -f nginx/ssl/treq.crt  && -f nginx/ssl/dhparam.pem ]]; then
    echo "Key & Cert & Param-File already exists, if you want a fresh start empty out nginx/ssl"
else
    echo "Generating Private Keys..."
    openssl genrsa -out frontend/nginx/ssl/treq.key 2048
    echo "Private Key Generated!"
    echo "Generating Certificate (valid for 365 days)..."
    openssl req -new -x509 -key frontend/nginx/ssl/treq.key -out nginx/ssl/treq.crt -days 365\
    -subj "/C=US/ST=Utah/L=Lehi/O=TREQ{certificate_decoded}, Inc./OU=IT/CN=treq.test"
    echo "Generated Certificate!"
    echo "Generating Diffie Hellman Parameter File..."
    openssl dhparam -out frontend/nginx/ssl/dhparam.pem 2048
    echo "Generated Diffie Hellman Parameter File!"
fi


# Start Container
echo "Starting Container For You...."
docker compose up -d 
echo "Container up and running"


echo "Treq is running!"
echo "Add this to your /etc/hosts file:"
echo "  127.0.0.1 treq.test"
echo "Then visit http://treq.test or https://treq.test"
echo "Have fun!"

