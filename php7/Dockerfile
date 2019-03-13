FROM php:7.1.3-fpm

ADD sources.list    /etc/apt/sources.list

ADD php.ini         /usr/local/etc/php/php.ini
ADD php-fpm.conf    /usr/local/etc/php-fpm.conf
ADD ./.gdbinit      /opt/.gdbinit

COPY pkg/redis-3.0.0.tgz /tmp/redis.tgz
COPY pkg/yaf-3.0.7.tgz /tmp/yaf.tgz
COPY pkg/phpng-xhprof.tar.gz /tmp/phpng-xhprof.tar.gz
COPY pkg/freetype-2.7.1.tar.gz /tmp/freetype.tar.gz
COPY pkg/libpng-1.6.28.tar.gz /tmp/libpng.tar.gz
COPY pkg/libjpeg-turbo-1.5.1.tar.gz /tmp/libjpeg.tar.gz
COPY pkg/swoole-1.9.8.tgz /tmp/swoole.tgz
COPY pkg/mongodb-1.3.1.tgz /tmp/mongodb.tgz

RUN apt-get update && apt-get install -y \
	libfreetype6-dev \
	libjpeg62-turbo \ 
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libpng12-dev \
	libmcrypt-dev \
	libltdl-dev \
	libssl-dev \
	gdb \
	git \
	strace \
	mcrypt \
	libmhash-dev \
	libmhash2

# 编译安装gd库依赖
#RUN cd /tmp \
#	&& tar xfz /tmp/freetype.tar.gz \
#	&& cd /tmp/freetype-2.7.1 \ 
#	#&& ./configure --prefix=/usr && make && make install && make clean \ 
#	&& cd /tmp \
#	&& tar xfz /tmp/libpng.tar.gz \
#	&& cd /tmp/libpng-1.6.28 \ 
#	#&& ./configure --prefix=/usr && make && make install && make clean \ 
#	&& cd /tmp \
#	&& tar xfz /tmp/libjpeg.tar.gz \
#	&& cd /tmp/libjpeg-turbo-1.5.1 \ 
#	#&& ./configure --prefix=/usr && make && make install && make clean \ 
#	&& mkdir -p /usr/src/php/ext

# 安装php扩展
RUN docker-php-source extract \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include --with-jpeg-dir=/usr/include \
	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install -j$(nproc) zip \
	&& docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) bcmath \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && pecl install apcu-5.1.5 \
    && docker-php-ext-enable apcu \ 
	&& tar xfz /tmp/redis.tgz \
    && mv redis-3.0.0 /usr/src/php/ext/redis \
    && docker-php-ext-install -j$(nproc) redis \
	&& tar xfz /tmp/yaf.tgz \
    && mv yaf-3.0.7 /usr/src/php/ext/yaf \
    && docker-php-ext-install -j$(nproc) yaf \
	&& tar xfz /tmp/swoole.tgz \
    && mv swoole-1.9.8 /usr/src/php/ext/swoole \
    && docker-php-ext-install -j$(nproc) swoole \
	&& tar xfz /tmp/mongodb.tgz \
    && mv mongodb-1.3.1 /usr/src/php/ext/mongodb \
    && docker-php-ext-install -j$(nproc) mongodb \
	&& tar xfz /tmp/phpng-xhprof.tar.gz \
    && mv phpng-xhprof /usr/src/php/ext/phpng-xhprof \
    && docker-php-ext-install -j$(nproc) phpng-xhprof

# 清理安装包
#RUN  rm -rf /tmp/freetype* \ 
#	&& rm -rf /tmp/libpng* \
#	&& rm -rf /tmp/libjpeg*

RUN rm -rf /tmp/redis.tgz  \
	&& rm -rf /tmp/swoole.tgz \ 
	&& rm -rf /tmp/phpng-xhprof.tgz \ 
	&& rm -rf /tmp/yaf.tgz \ 
	&& rm -rf /tmp/mongodb.tgz

# 添加composer包
ADD pkg/composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

# 添加phpunit包
ADD pkg/phpunit.phar /usr/local/bin/phpunit
RUN chmod 755 /usr/local/bin/phpunit

#RUN /sbin/sysctl -w kernel.core_pattern="/data/data/core/php7_core.%p"

WORKDIR /data
RUN usermod -u 1000 www-data

EXPOSE 9002

VOLUME ["/data"]
