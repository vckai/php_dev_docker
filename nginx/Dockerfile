FROM openresty/openresty:alpine

RUN rm -f /usr/local/openresty/nginx/conf/nginx.conf
RUN rm -f /etc/nginx/nginx.conf

ADD nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
#ADD ./vhosts/ /usr/local/openresty/nginx/conf/vhosts/

RUN addgroup -g 1000 www-data
RUN adduser -u 1000 -S www-data
RUN mkdir -p /data/www && mkdir -p /data/logs && mkdir -p /data/logs/nginx
RUN chown -R www-data:www-data /data/www /data/logs

EXPOSE 80

VOLUME ["/data"]
