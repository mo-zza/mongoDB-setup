#!/bin/bash

# Check if mongo docker is exists
if [ ! "$(docker ps -q -f name=mongo)" ]; then
    echo "MongoDB is not running. Starting MongoDB..."
else
    echo "MongoDB is already running."
    docker compose down
fi