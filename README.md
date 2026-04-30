<img width="1280" height="640" alt="treq" src="https://github.com/user-attachments/assets/94e5a3c5-495a-4c91-b608-632ae02c930b" />

# Treq — A Hands-On HTTPS & TLS Security Learning Lab

Treq is a self-contained, multi-container educational lab that teaches HTTP/HTTPS security concepts through real-world challenges. Users explore live network traffic, intercept credentials, decrypt encrypted payloads, and complete CTF-style flag challenges to learn how TLS, certificates, and reverse proxies actually work in production systems.

## What You'll Learn

- How the TLS handshake works and what certificates actually contain
- Why HTTP exposes credentials in plaintext and HTTPS doesn't
- How reverse proxies (nginx) sit in front of backend services
- How forward secrecy and Diffie-Hellman key exchange protect past sessions
- How to use real security tools — mitmproxy, openssl, tcpdump
- How modern systems handle secrets via separate cryptographic services

## Architecture

Treq is built as a microservices application with five containers communicating over a private Docker network:

- **treq-frontend** — nginx reverse proxy with TLS termination, serves static pages and routes API calls
- **treq-backend** — Go HTTP server handling flag validation and admin authentication
- **treq-crypto** — Python Flask service that encrypts and decrypts flags using Fernet symmetric encryption
- **treq-simulator** — Generates periodic HTTP traffic with credentials to demonstrate plaintext exposure
- **treq-hacker** — Interactive container with mitmproxy and other tools for the user to intercept traffic

**```**mermaid\*\*
**graph** TB
** User**[👤 User Browser]\*\*
** Hacker**[🔓 treq-hackermitmproxy + tools]\*\*
** Sim**[📡 treq-simulatorBackground traffic]\*\*

**subgraph** Frontend**["treq-frontend (nginx)"]**
** TLS**[TLS TerminationPort 443]\*\*
** HTTP**[HTTP ServerPort 80]\*\*
** Proxy**[Reverse Proxy]\*\*
**end**
\*\*
** Backend**[⚙️ treq-backendGo HTTP Server]\*\*
** Crypto**[🔐 treq-cryptoPython Flask + Fernet]\*\*

** User **-->**|HTTPS|** TLS
** User **-->**|HTTP|** HTTP
** Sim **-.->**|Plaintext credentials|** Hacker
** Hacker **-.->**|Intercepts|** Sim
** Hacker **-->**|Forwards|** Frontend
** TLS **-->** Proxy
** HTTP **-->** Proxy
** Proxy **-->**|/validate, /admin/login|** Backend
** Backend **-->**|/decrypt|** Crypto

**style** Crypto **fill**:**#ffe1e1**
**style** Hacker **fill**:**#fff4e1**
**style** Backend **fill**:**#e1f5ff**
**style** Frontend **fill**:**#e8ffe1**
**```**

## Tech Stack

- **Languages**: Go, Python, Bash, JavaScript
- **Infrastructure**: Docker, Docker Compose, nginx
- **Security**: OpenSSL, Fernet symmetric encryption, SHA-256
- **Tooling**: mitmproxy, curl

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Python 3
- OpenSSL

### Setup

1. Fork and clone this repo:

```bash
git clone https://github.com/<your-username>/treq.git
cd treq
```

2. Add `treq.test` to your hosts file:

```bash
# On Linux/macOS: /etc/hosts
# On Windows: C:\Windows\System32\drivers\etc\hosts
127.0.0.1 treq.test
```

3. Run the setup script:

```bash
chmod +x setup.sh
./setup.sh
```

This single command:

- Generates fresh TLS certificates
- Creates dynamic flag values
- Generates an encryption key in memory
- Spins up all five containers
- Encrypts the flags via the crypto service
- Validates everything is healthy

4. Visit `https://treq.test` in your browser. (You'll see a self-signed certificate warning — that's expected and part of the lesson.)

## The Challenges

### Flag 1 — Certificate Inspection

The server's certificate contains hidden information. Use OpenSSL to inspect it and find the flag.

**Hint**: `openssl s_client` is your friend.

### Flag 2 — HTTP Credential Interception

Background traffic is flowing across the network. Some of it shouldn't be transmitted in plaintext. Intercept it, find the credentials, and use them to access the admin panel.

**Hint**: Get inside the network with `docker exec -it treq-hacker bash` and use mitmproxy.

### Flags 3, 4, 5 — Coming Soon

Future challenges will explore:

- Information disclosure via robots.txt → leaked private keys → log decryption
- Access control bypass between HTTP and HTTPS
- Mixed content vulnerabilities

## Submitting Flags

Visit `https://treq.test/submit.html` to submit flags as you find them. The backend validates submissions by hashing them and comparing against pre-computed hashes — flags are never stored in plaintext.

## Project Structure

treq/
├── frontend/ # nginx config, static HTML, admin and submit pages
├── backend/ # Go HTTP server (flag validation, admin login)
├── crypto/ # Python Flask encryption service
├── simulator/ # Background traffic generator
├── hacker/ # User's tooling container
├── compose.yml # Multi-container orchestration
└── setup.sh # One-command setup

## Security Design Notes

- **Flags are dynamically generated** at setup time, never hardcoded
- **Encryption keys live in container memory only** — never written to disk
- **Encrypted flags on disk** — useless without the running crypto service
- **Backend validates via hash comparison** — plaintext flags are never stored
- **TLS certificates are gitignored** — fresh keys per environment

## Disclaimer

Treq is an educational lab, not a competitive CTF platform. Since you're running it on your own machine, perfect anti-cheat isn't possible but the goal is learning, not winning. The challenges are designed so that solving them properly teaches concepts that apply to real production security work.

## Author

Built by [CodEz47](https://github.com/codez47) as a hands-on way to deeply understand HTTPS, TLS, and modern infrastructure security.
