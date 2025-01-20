#!/bin/sh

git clone https://github.com/cossacklabs/acra-engineering-demo
cd ./acra-engineering-demo
git checkout ecc16187da0d4cd6a89d3340f7e492af04d2b45a

git clone https://github.com/cossacklabs/acra 
cd ./acra
git checkout 8843776e9f3a18a1a07375b9ce4ec14b2d6002ed

# Patch here
cd ..
sed -i -e "s/extended_encryptor_config.yaml:/extended_example_encryptor_config.yaml:/g" ./python-mysql-postgresql/docker-compose.python-mysql-postgresql.yml
cd ..

export ACRA_DOCKER_IMAGE_TAG=0.95.0

export MYSQL_USER=test
export MYSQL_PASSWORD=test
export MYSQL_DATABASE=test

export POSTGRES_USER=test
export POSTGRES_PASSWORD=test
export POSTGRES_DB=test

export PGADMIN_DEFAULT_EMAIL=test@test.test
export PGADMIN_DEFAULT_PASSWORD=test

docker run --rm -v $(pwd):/keys/  cossacklabs/acra-keymaker:${ACRA_DOCKER_IMAGE_TAG} --keystore=v1 --generate_master_key=/keys/master.key
sudo chown $(whoami) ./master.key
export ACRA_MASTER_KEY=$(cat master.key | base64)


cp ./short_deploy.yaml ./acra-engineering-demo/python-mysql-postgresql
docker-compose -f ./acra-engineering-demo/python-mysql-postgresql/short_deploy.yaml pull
docker-compose -f ./acra-engineering-demo/python-mysql-postgresql/short_deploy.yaml up --build


