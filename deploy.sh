#!/bin/bash

# check openssl command is installed
if ! command -v openssl &> /dev/null
then
    echo "openssl could not be found"
    exit
fi

# create mongodb ssl key
## Check if the key file already exists
if [ -f ${HOME}/.ssh/mongodb.key ]; then
    echo "MongoDB SSL key already exists."
else
    echo "Creating MongoDB SSL key..."
    sudo openssl rand -base64 756 > ${HOME}/.ssh/mongodb.key
    sudo chmod 400 ${HOME}/.ssh/mongodb.key
    cat ${HOME}/.ssh/mongodb.key
    echo "MongoDB SSL key created successfully."
fi

# write environment variables
## Check if the environment variables already exist
if [ -f .env ]; then
  echo "Environment variables already exist."
else
  echo "Writing environment variables..."
  echo "MONGO_PRIMARY_PORT=27017" >> .env
  echo "MONGO_SECONDARY_READ_PORT=27018" >> .env
  echo "MONGO_SECONDARY_RW_PORT=27019" >> .env
  echo "MONGO_INITDB_ROOT_USERNAME=root" >> .env
  echo "MONGO_INITDB_ROOT_PASSWORD=1234" >> .env
  echo "MONGO_INITDB_DATABASE=product" >> .env
  echo "Environment variables written successfully."
  cat .env
fi

# run mongodb with ssl
docker compose up -d

# check if mongodb is running
docker ps | grep mongodb

# check if mongodb docker containers is running
# Wait for MongoDB containers to be ready
echo "Waiting for MongoDB containers to start..."
for i in {1..30}; do
    if docker ps | grep -q "mongodb-primary" && \
       docker ps | grep -q "mongodb-secondary-read" && \
       docker ps | grep -q "mongodb-secondary-rw"; then
        echo "All MongoDB containers are running"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "Error: MongoDB containers failed to start"
        docker ps
        exit 1
    fi
    echo "Waiting... ($i/30)"
    sleep 2
done

# Initialize the Replica Set with authentication
echo "Initializing replica set..."
sleep 5s
source .env
docker exec mongodb-primary mongosh --username ${MONGO_INITDB_ROOT_USERNAME} --password ${MONGO_INITDB_ROOT_PASSWORD} --authenticationDatabase admin --eval "
try {
  rs.initiate({
    _id: 'rs0',
    members: [
      {_id: 0, host: 'mongodb-primary:27017'},
      {_id: 1, host: 'mongodb-secondary-read:27017'},
      {_id: 2, host: 'mongodb-secondary-rw:27017'}
    ]
  });
  print('Replica set initialized successfully');
} catch(e) {
  if (e.message.includes('already initialized')) {
    print('Replica set already initialized');
  } else {
    throw e;
  }
}
"

# Check the status of the Replica Set
docker exec mongodb-primary mongosh --username root --password 1234 --authenticationDatabase admin --eval "
rs.status()
"