# How to Deploy Acra?

To know how to run python app, please read `README.md` in `./python` folder.

## What OS to use?
Please, use any linux or MacOS. 
Kali, Ubuntu, Debian, Arch, CentOS and MacOS should deploy those services without problems.

## What OS did you use on presentation?
We used `Kali` or `Ubuntu`. Those scripts should 100% work on those OSes

## Easiest way:

```
chmod +x ./acra_deploy.sh
chmod +x ./ssl_gen.sh
chmod +x ./short_deploy.yaml
./acra_deploy
```

## Detailed listing of commands

### Clone `acra-engineering-demo` repo
This repository contains files related to acra's demo deployment.

```
git clone https://github.com/cossacklabs/acra-engineering-demo
cd ./acra-engineering-demo
git checkout ecc16187da0d4cd6a89d3340f7e492af04d2b45a
```
We need to do checkout just to be sure that nothing has changed in the repo and will not change.

### Clone `acra` repo

This repository contains files related to acra. We need to clone `acra` inside of `./acra-engineering-demo` folder.
```
git clone https://github.com/cossacklabs/acra 
cd ./acra
git checkout 8843776e9f3a18a1a07375b9ce4ec14b2d6002ed
```
Need to do checkout for the same reason as `acra-engineering-demo`

### Patch 
Apply patch to `docker-compose.python-mysql-postgresql.yml` file. Rename file from `extended_encryptor_config.yaml` to `extended_example_encryptor_config.yaml`
Because newest version of Acra decided to rename this file in `examples` folder:
```
# Patch here
sed -i -e "s/extended_encryptor_config.yaml:/extended_example_encryptor_config.yaml:/g" ./python-mysql-postgresql/docker-compose.python-mysql-postgresql.yml
cd ..
```

### Environmental Variables
Here you can change the DB name, user, pass, etc.

```
export ACRA_DOCKER_IMAGE_TAG=0.95.0

export MYSQL_USER=test
export MYSQL_PASSWORD=test
export MYSQL_DATABASE=test

export POSTGRES_USER=test
export POSTGRES_PASSWORD=test
export POSTGRES_DB=test

export PGADMIN_DEFAULT_EMAIL=test@test.test
export PGADMIN_DEFAULT_PASSWORD=test
```

### Generate Acra's master key
Be carefull, some systems may ask user input here!
```
docker run --rm -v $(pwd):/keys/  cossacklabs/acra-keymaker:${ACRA_DOCKER_IMAGE_TAG} --keystore=v1 --generate_master_key=/keys/master.key
sudo chown $(whoami) ./master.key
export ACRA_MASTER_KEY=$(cat master.key | base64)
```

### Generate your own certificates

You can generate your own ssl certificates by uncommenting those commands in `./acra_deploy.sh`
```
# Generate own ssl certificates
cd ./acra-engineering-demo/_common/ssl
rm -rf ./*
./../../../ssl_gen.sh
cd ./../../../
```
You can look inside `./ssl_gen.sh` to get more knowledge about certificate generation.

### Acra's deployment

By default we have decided to leave short deploy as the default one:
```
# Short deploy here
cp ./short_deploy.yaml ./acra-engineering-demo/python-mysql-postgresql
docker-compose -f ./acra-engineering-demo/python-mysql-postgresql/short_deploy.yaml pull
docker-compose -f ./acra-engineering-demo/python-mysql-postgresql/short_deploy.yaml up --build
```

If you want full deploy, please comment short deploy and uncomment lines with `docker-compose.python-mysql-postgresql.yml`:
```
# Full deploy here
docker-compose -f ./acra-engineering-demo/python-mysql-postgresql/docker-compose.python-mysql-postgresql.yml pull
docker-compose -f ./acra-engineering-demo/python-mysql-postgresql/docker-compose.python-mysql-postgresql.yml up --build
```

# Continue to Python folder and Read `README.md` there