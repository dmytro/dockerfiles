FROM ubuntu:14.04

MAINTAINER Dmytro Kovalov <dmytro.kovalov@gmail.com>

RUN apt-get update && apt-get install -y nginx

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

COPY "nginx.conf" "/etc/nginx/nginx.conf"
COPY "default.conf" "/etc/nginx/conf.d/default.conf"

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
