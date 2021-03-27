#!/bin/bash -l

# lib/scripts/docker-db-setup.sh

# use from Rails.root with: ./lib/scripts/docker-db-setup.sh

set -e

# colors for output
txRed='\033[0;31m'
txRedBold='\033[1;31m'
txGreen='\033[0;32m'
txGreenBold='\033[1;32m'
txYellow='\33[0;33m'
txYellowBold='\33[1;33m'
txBlue='\33[0;34m'
txBlueBold='\33[1;34m'
txReset='\033[0m'

function info() {
  local msg="$*"
  printf "${txBlueBold}[INFO]${txBlue} ${msg}${txReset} \n"
}
function success() {
  local msg="$*"
  printf "${txGreenBold}[SUCCESS]${txGreen} ${msg}${txReset} \n"
}
function error() {
  local msg="$*"
  printf "${txRedBold}[ERROR]${txRed} ${msg}${txReset} \n"
}

# general env vars are loaded via direnv: https://github.com/direnv/direnv

dev_db_name="${APP_NAME}_development"
dev_user="${APP_NAME}_development"
dev_pass=$(rails runner -e development "puts Rails.application.credentials.database[:password]")
test_db_name="${APP_NAME}_test"
test_user="${APP_NAME}_test"
test_pass=$(rails runner -e test "puts Rails.application.credentials.database[:password]")

info "checking for existing containers"
if [[ "$(docker container ls -a | grep -c "$develop_container_name")" == "1" ]];
then
  info "removing old container: $develop_container_name"
  docker container rm -f $develop_container_name
fi

if [[ "$(docker container ls -a | grep -c "$test_container_name")" == "1" ]];
then
  info "removing old container: $test_container_name"
  docker container rm -f $test_container_name
fi

info "cleaning volumes"
docker volume prune -f

info "starting new container $develop_container_name with database $dev_db_name"
docker container run -d -e MYSQL_ROOT_PASSWORD="$dev_pass" \
  -e MYSQL_USER="$dev_user" -e MYSQL_PASSWORD="$dev_pass" -e MYSQL_DATABASE=${dev_db_name} \
  --restart unless-stopped \
  --name $develop_container_name -P mariadb:10.4 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

DOCKER_DEV_DB_PORT=$(docker inspect --format="{{(index (index .NetworkSettings.Ports \"3306/tcp\") 0).HostPort}}" ${develop_container_name})

info "starting new container $test_container_name with database $test_db_name"
docker container run -d -e MYSQL_ROOT_PASSWORD="$test_pass" \
  -e MYSQL_USER="$test_user" -e MYSQL_PASSWORD="$test_pass" -e MYSQL_DATABASE=${test_db_name} \
  --restart unless-stopped \
  --name $test_container_name -P mariadb:10.4 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

DOCKER_TEST_DB_PORT=$(docker inspect --format="{{(index (index .NetworkSettings.Ports \"3306/tcp\") 0).HostPort}}" ${test_container_name})

info "dev port > $DOCKER_DEV_DB_PORT"
info "test port > $DOCKER_TEST_DB_PORT"
info "waiting 60s for containers to start"
sleep 60


rm -f db/schema.rb

# we need to hand in both ports since the env vars are not exported and loaded yet
DOCKER_DEV_DB_PORT=$DOCKER_DEV_DB_PORT DOCKER_TEST_DB_PORT=$DOCKER_TEST_DB_PORT rails db:migrate
DOCKER_DEV_DB_PORT=$DOCKER_DEV_DB_PORT DOCKER_TEST_DB_PORT=$DOCKER_TEST_DB_PORT RAILS_ENV=test rails db:migrate
DOCKER_DEV_DB_PORT=$DOCKER_DEV_DB_PORT DOCKER_TEST_DB_PORT=$DOCKER_TEST_DB_PORT rails db:seed

# remove old port definitions from .envrc based on the OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux
  sed -i '/DOCKER_DEV_DB_PORT/d' .envrc
  sed -i '/DOCKER_TEST_DB_PORT/d' .envrc
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  sed -i '' '/DOCKER_DEV_DB_PORT/d' .envrc
  sed -i '' '/DOCKER_TEST_DB_PORT/d' .envrc
else
  error "cannot run sed - cannot determine OSTYPE"
fi

# setting port numbers and allow the changed .envrc to be loaded
echo "export DOCKER_DEV_DB_PORT=${DOCKER_DEV_DB_PORT}" >> .envrc
echo "export DOCKER_TEST_DB_PORT=${DOCKER_TEST_DB_PORT}" >> .envrc
direnv allow

success "DONE! Happy coding!"