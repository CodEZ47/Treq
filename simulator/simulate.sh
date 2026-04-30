#!/bin/bash

# Random credentials function
random_str() {
    cat /dev/urandom | tr -dc 'a-z' | fold -w 8 | head -1
}


while true; do
    # 1 in 2 chance of sending the real credentials
    if (( RANDOM % 2 == 0 )); then
        username="admin"
        password="ushudntbeseeingthis"
    else
        username=$(random_str)
        password=$(random_str)
    fi
    
    # Send over HTTP (interceptable)
    curl -s -x http://treq-hacker:8080 -X POST http://treq-frontend/login \
        -d "username=$username&password=$password"
    
    # Send over HTTPS (encrypted)
    curl -s -x http://treq-hacker:8080 -X POST https://treq-frontend/login \
        -d "username=$username&password=$password"
    
    sleep 2
done

    