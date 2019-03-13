#!/bin/bash

alias_file=~/.docker_alias
bash_file=~/.bash_profile

mkdir -p ~/data/data/mysql
mkdir -p ~/data/data/xhporf
mkdir -p ~/data/data/core
mkdir -p ~/data/logs/nginx

cp -r ./nginx/vhosts_example ./nginx/vhosts
cp ./nginx/nginx.conf-example ./nginx/nginx.conf

cp ./php5/php-fpm.conf-example ./php5/php-fpm.conf
cp ./php5/php.ini-example ./php5/php.ini

cp ./php7/php-fpm.conf-example ./php7/php-fpm.conf
cp ./php7/php.ini-example ./php7/php.ini

cp ./.env-example ./.env
cp ./docker-compose.yml-example ./docker-compose.yml

echo "source ${alias_file}" >> ${bash_file}

echo '' > ${alias_file}

link="--link php_dev_docker_nginx_1:nginx --link php_dev_docker_redis_1:redis --link php_dev_docker_mysql_1:mysql --link php_dev_docker_mongo_1:mongo --net php_dev_docker_default"

echo "
alias php='docker run --rm -v $(pwd):/data ${link} -it php_dev_docker_php5 php'

alias php7='docker run --rm -v $(pwd):/data ${link} -it php_dev_docker_php7 php'

alias composer='docker run --rm -v $(pwd):/data ${link} -it php_dev_docker_php5 composer'

alias composer7='docker run --rm -v $(pwd):/data ${link} -it php_dev_docker_php7 composer'

alias phpunit='docker run --rm -v $(pwd):/data ${link} -it php_dev_docker_php5 phpunit'

alias phpunit7='docker run --rm -v $(pwd):/data ${link} -it php_dev_docker_php7 phpunit'

alias redis-cli='docker run -it php_dev_docker_redis redis-cli'

docker-enter() {
	CONTAINER=\$1
	shift 1
		docker exec -it \"\$CONTAINER\" su - root -c 'script -q /dev/null'
}
" >> ${alias_file}

source ${bash_file}

# build docker
#docker-compose build
