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


    
organization="TREQ{$(cat /dev/urandom | tr -dc 'a-z' | fold -w 8 | head -1)_dont_send_this_over_http?}"
admin="TREQ{$(cat /dev/urandom | tr -dc 'a-z' | fold -w 8 | head -1)_crawl_before_you_hack}"

# Generate hashes for validation
echo -n "$organization" | sha256sum | cut -d ' ' -f1 > backend/flags/org.hash
echo -n "$admin" | sha256sum | cut -d ' ' -f1 > backend/flags/admin.hash

# Create key, cert and diffie hellman param file
echo "Generating Private Keys..."
openssl genrsa -out frontend/nginx/ssl/treq.key 2048
echo "Private Key Generated!"
echo "Generating Certificate (valid for 365 days)..."
openssl req -new -x509 \
  -key frontend/nginx/ssl/treq.key \
  -out frontend/nginx/ssl/treq.crt \
  -days 365 \
  -subj "/C=US/ST=Utah/L=Lehi/O=$organization Inc/OU=IT/CN=treq.test"
echo "Generated Certificate!"
if [[ ! -f frontend/nginx/ssl/dhparam.pem ]]; then
    echo "Generating Diffie Hellman Parameter File..."
    openssl dhparam -out frontend/nginx/ssl/dhparam.pem 2048
    echo "Generated Diffie Hellman Parameter File!"
else
    echo "Diffie Hellman Parameter File already exists, skipping..."
fi


# Start Container
echo "Restarting Containers For You...."
export FERNET_KEY=$(python -c "import os, base64; print(base64.urlsafe_b64encode(os.urandom(32)).decode())")
docker compose down
docker compose up --build -d > /dev/null


while ! curl http://localhost:5000/health > /dev/null 2>&1; do
    sleep 0.5
done

# Encrypt flags
curl -s -X POST http://localhost:5000/encrypt \
  -H "Content-Type: application/json" \
  -d "{\"flag\": \"$admin\"}" > backend/flags/admin.enc

curl -s -X POST http://localhost:5000/encrypt \
  -H "Content-Type: application/json" \
  -d "{\"flag\": \"$organization\"}" > backend/flags/org.enc



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

