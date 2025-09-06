
<img width="1280" height="640" alt="treq" src="https://github.com/user-attachments/assets/94e5a3c5-495a-4c91-b608-632ae02c930b" />

# Treq - Test|Request|Encrypt|Query

A Pull-and-Play HTTPS Learning Lab in a Docker Container


## Project Overview
Treq is a self-contained, educational web environment that demonstrates how data is exposed over HTTP and protected with HTTPS. Users explore hidden flags, simulate man-in-the-middle (MITM) attacks using tools like mitmproxy, and inspect how credentials and secrets behave across HTTP and HTTPS.

Learning Goals:

Understand the TLS handshake and HTTPS

See real-time differences between HTTP and HTTPS traffic

Practice intercepting and analyzing plaintext HTTP requests

Explore security headers, access control, and log interception

## Requirements
Docker installed locally

Optional: mitmproxy for traffic inspection

## Getting Started

### Option 1: Clone & Build Locally


git clone https://github.com/your-username/treq.git

cd treq

Build the image:

docker build -t treq .

### Option 2: Pull Prebuilt Docker Image (if available)

docker pull 


## TLS Setup
Generate the required TLS files:


### Generate a private key
openssl genrsa -out treq.key 2048

### Generate a certificate (valid for 365 days)
openssl req -new -x509 -key treq.key -out treq.crt -days 365

### Generate a Diffie-Hellman parameter file
openssl dhparam -out dhparam.pem 2048

Place these files in the nginx/ssl/ folder:

nginx/ssl/
├── treq.key
├── treq.crt
└── dhparam.pem

# Run the Container
Use Docker to inject the TLS secrets without baking them into the image:

docker run -d \
  -p 80:80 -p 443:443 \
  -v $(pwd)/nginx/ssl/treq.key:/etc/nginx/ssl/treq.key:ro \
  -v $(pwd)/nginx/ssl/treq.crt:/etc/nginx/ssl/treq.crt:ro \
  -v $(pwd)/nginx/ssl/dhparam.pem:/etc/nginx/ssl/dhparam.pem:ro \
  --name treq-server treq


# Access the Lab
Hosts File Setup

To access via https://treq.test, map the container IP in your system’s hosts file:

# Edit /etc/hosts (Linux/macOS) or C:\Windows\System32\drivers\etc\hosts (Windows)
<your-server-ip> treq.test
Visit URLs

http://treq.test → insecure version (interceptable)

https://treq.test → secure version (TLS encrypted)

📋 Help & Log Inspection
/help.txt contains instructions for MITM testing using mitmproxy

/logs will show intercepted requests via HTTP (try: curl http://treq.test/logs)

Submit all discovered flags at /submit.html

