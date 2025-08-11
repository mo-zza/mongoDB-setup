#!/bin/bash

# Check if
if [ ! "$(docker ps -q -f name=mongo)" ]; then
    echo "MongoDB is not running. Starting MongoDB..."
    exit 0
fi

# Confirm clean up
echo -n "Are you sure you want to clean up MongoDB? (y/n): "
read confirm

if [ "$confirm" != "y" ]; then
    echo "Cleanup cancelled."
    exit 0
fi

# Stop MongoDB
echo "Stopping MongoDB..."
docker compose down

# Remove MongoDB Network
echo "Removing MongoDB Network..."
docker network rm mongocluster

# Remove MongoDB data
echo "Removing MongoDB data..."
sudo rm -rf ./mongo ./mongo-secondary-read ./mongo-secondary-rw