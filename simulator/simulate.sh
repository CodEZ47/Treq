#!/bin/bash

while true; do
    curl -s -x http://treq-hacker:8080 -X POST http://treq-frontend/login \
  -d "username=admin&password=ushudntbeseeingthis"
    sleep 2
done

    