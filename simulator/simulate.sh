#!/bin/bash

while true; do

    curl -s -X POST http://treq-frontend/login -d "username=admin&password=ushudntbeseeingthis"
    sleep 2
done

    