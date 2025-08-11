# MongoDB-setup

## Description
This project uses MongoDB 5.0 docker image and is designed to easily operate a MongoDB cluster using Docker.

# Environment
|Key| Type   | Default                                             | Description |
|---|--------|-----------------------------------------------------|-------------|
|MONGO_PRIMARY_PORT| number | 27017                                               |Mongo db primary cluster external port|
|MONGO_SECONDARY_READ_PORT| number |27018| Mongo db secondary read cluster external port       |
|MONGO_SECONDARY_RW_PORT| number | 27019  | Mongo db secondary read/write cluster external port |
|MONGO_INITDB_ROOT_USERNAME| string | root   |Mongo db root username|
|MONGO_INITDB_ROOT_PASSWORD|string|1234|Mongo db root user default password|
|MONGO_INITDB_DATABASE|string|product|Mongo db test database name|

# Start
## Write Environment
```shell
$ copy .env.example .env
```

# How to Use

## 1. Create Environment Variables File
Create `.env` file by copying `.env.example` and modify the values for each key as needed:

```shell
$ cp .env.example .env
```

## 2. Set Script Permissions 
Give execution permissions to all shell scripts:

```shell
$ chmod +x deploy.sh
```

## 3. Deploy MongoDB Cluster
Run `deploy.sh` to start MongoDB cluster:

```shell
$ ./deploy.sh
```

This will:
- Create MongoDB SSL key if not exists
- Write environment variables if not exists
- Start MongoDB containers
- Initialize replica set
- Check replica set status

## 4. Stop Containers
To stop the MongoDB containers:

```shell
$ ./shutdown.sh
```

## 5. Clean Up
To remove all containers and data:

```shell
$ ./clean-up.sh
```

This will remove:
- All MongoDB containers
- All MongoDB data volumes
- Environment files