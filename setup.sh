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
mkdir -p frontend/nginx/ssl

# Create flags directory if it doesn't exist
mkdir -p backend/flags


# Create key, cert and diffie hellman param file if they don't exisit
if [[ -f frontend/nginx/ssl/treq.key && -f frontend/nginx/ssl/treq.crt  && -f frontend/nginx/ssl/dhparam.pem && -f backend/flags/org.hash ]]; then
    echo "Key & Cert & Param-File already exists, if you want a fresh start empty out frontend/nginx/ssl"
else
    
    organization="TREQ{$(cat /dev/urandom | tr -dc 'a-z' | fold -w 8 | head -1)_dontsendthisoverhttp?}"
    echo -n "$organization" | sha256sum | cut -d ' ' -f1 > backend/flags/org.hash

    echo "Generating Private Keys..."
    openssl genrsa -out frontend/nginx/ssl/treq.key 2048
    echo "Private Key Generated!"
    echo "Generating Certificate (valid for 365 days)..."
    openssl req -new -x509 -key frontend/nginx/ssl/treq.key -out frontend/nginx/ssl/treq.crt -days 365\
    -subj "//C=US\ST=Utah\L=Lehi\O=$organization, Inc.\OU=IT\CN=treq.test"
    echo "Generated Certificate!"
    echo "Generating Diffie Hellman Parameter File..."
    openssl dhparam -out frontend/nginx/ssl/dhparam.pem 2048
    echo "Generated Diffie Hellman Parameter File!"
fi


# Start Container
echo "Starting Containers For You...."
docker compose up --build -d > /dev/null 2>&1


if curl http://localhost/health > /dev/null 2>&1; then
    echo " "
    echo "Containers up and running!"
    echo "Treq is running!"
    echo "Add this to your /etc/hosts file:"
    echo "  127.0.0.1 treq.test"
    echo "Then visit http://treq.test or https://treq.test"
    echo "You can also hack! Use this Command in Bash:"
    echo "docker exec -it treq-hacker bash"
    echo "Have fun!"
else
    echo " Oops! Something Failed"
fi

