#FROM php:5.5.36-fpm
FROM daocloud.io/library/php:5.4.38-fpm

ADD sources.list    /etc/apt/sources.list

ADD php.ini			/usr/local/etc/php/php.ini
ADD php-fpm.conf    /usr/local/etc/php-fpm.conf

COPY pkg/memcached-2.2.0.tgz /tmp/memcached.tgz
COPY pkg/redis-2.2.8.tgz /tmp/redis.tgz
COPY pkg/igbinary-1.2.1.tgz /tmp/igbinary.tgz
COPY pkg/mongo-1.6.14.tgz /tmp/mongo-1.6.14.tgz
COPY pkg/xhprof.tgz /tmp/xhprof.tgz

# 设置时区
RUN echo "Asia/shanghai" > /etc/timezone \ 
	&& cp -af /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN apt-get update && apt-get install -y \
		freetype* \ 
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
		libmemcached-dev \
		libssl-dev \
		graphviz \ 
		gdb \
		git \
		strace

RUN tar xf /tmp/xhprof.tgz \
	&& rm -r /tmp/xhprof.tgz \ 
	&& mv xhprof_new/extension /usr/src/php/ext/xhprof \
    && docker-php-ext-install xhprof

RUN ln -s /usr/local/Cellar/openssl/1.0.2d_1/include/openssl /usr/local/include/openssl

RUN tar xfz /tmp/igbinary.tgz \
	&& rm -r /tmp/igbinary.tgz \ 
	&& mv igbinary-1.2.1 /usr/src/php/ext/igbinary \
	&& docker-php-ext-install igbinary

RUN tar xfz /tmp/mongo-1.6.14.tgz \
	&& rm -r /tmp/mongo-1.6.14.tgz \ 
	&& mv mongo-1.6.14 /usr/src/php/ext/mongo \
	&& docker-php-ext-install mongo

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install zip \
	&& docker-php-ext-install gd \
    && docker-php-ext-install mysql \
    && docker-php-ext-install pdo_mysql \
	&& docker-php-ext-install mbstring \
	&& docker-php-ext-install mcrypt \
	&& docker-php-ext-install pcntl \
	&& tar xfz /tmp/redis.tgz \
    && rm -r /tmp/redis.tgz \
    && mv redis-2.2.8 /usr/src/php/ext/redis \
	&& docker-php-ext-configure redis --enable-redis-igbinary \
    && docker-php-ext-install redis

RUN tar xfz /tmp/memcached.tgz \ 
	&& rm -f /tmp/memcaced.tgz \ 
	&& mv memcached-2.2.0 /usr/src/php/ext/memcached \
	&& docker-php-ext-install memcached

ADD pkg/composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer
#RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com
RUN composer config -g repo.packagist composer https://packagist.laravel-china.org

ADD pkg/phpunit-4.8.phar /usr/local/bin/phpunit
RUN chmod +x /usr/local/bin/phpunit

#RUN /sbin/sysctl -w kernel.core_pattern="/data/data/core/php5_core.%p"

WORKDIR /data
RUN usermod -u 1000 www-data

EXPOSE 9000 9001

VOLUME ["/data"]
