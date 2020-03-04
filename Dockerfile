FROM ubuntu:18.04
MAINTAINER Simon Wild <simonwild@protonmail.com>

# Install packages and PHP 7.4
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:ondrej/php

RUN apt-get update -y
RUN apt-get upgrade -y

RUN apt-get install -y wget openssl python python-pip \
  git composer nginx php7.4-fpm php7.4-intl php7.4-mbstring \
  php7.4-zip php7.4-gmp php7.4-gd php7.4-zip php7.4-intl php7.4-simplexml php7.4-xml \
  php7.4-pdo php7.4-curl php7.4-gmagick php7.4-bcmath pkg-config \
  php7.4-mysql php-dev libmcrypt-dev gcc make autoconf libc-dev

RUN wget https://github.com/drush-ops/drush/releases/download/8.3.2/drush.phar
RUN chmod +x drush.phar
RUN mv drush.phar /usr/local/bin/drush

# Add Nginx Conf
RUN mkdir -p /var/www/html/

RUN openssl genrsa 2048 > localhost.key
RUN chmod 400 localhost.key
RUN openssl req -new -x509 -nodes -sha256 -days 365 -key localhost.key -out localhost.crt -subj "/C=US/ST=Virginia/L=Reston/O=720/OU=IT Department/CN=720strategies.com"

RUN mv localhost.key /etc/nginx/localhost.key
RUN mv localhost.crt /etc/nginx/localhost.crt

COPY site.conf /etc/nginx/sites-available/default


WORKDIR /var/www/html/


ENTRYPOINT service php7.4-fpm start && service nginx start && /bin/bash
