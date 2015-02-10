FROM ubuntu:14.04
MAINTAINER Dmytro Kovalov <dmytro.kovalov@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get update && apt-get install -y mysql-server \
    &&   rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/lib/mysql/*

ADD my.cnf /etc/my.cnf
ADD *.sh /

#
# Set user's for MySQL
#
ENV MYSQL_ROOT_PASS "secret"

ENV MYSQL_USER      ""
ENV MYSQL_USER_PASS ""

VOLUME /var/lib/mysql

EXPOSE 3306
CMD ["/run.sh"]
