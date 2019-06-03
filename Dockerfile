#!/bin/bash
FROM ubuntu:bionic

    #variables
ENV DEBIAN_FRONTEND="noninteractive" \
  	TZ="Europe/Paris" \
    DOMAIN="localhost" \
    EMAIL="admin@localhost" \
    SHFILE="/scripts/custom.sh" \
    PAGESPEED="true" \
    LIBMOD="re2c,bsdiff" \
    APAMOD="cache,rewrite,ssl,headers" \
    APDMOD="autoindex" \
    PEAMOD="xdiff-beta,parallel-beta" \
    PHPVER="7.2.19" \
    PHPCNF="--prefix=/etc/php7 --without-pear --with-bz2 --with-zlib --enable-zip --disable-cgi --enable-soap --enable-intl --with-openssl --with-readline --with-curl --enable-ftp --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-sockets --enable-pcntl --with-pspell --with-enchant --with-gettext --with-gd --enable-exif --with-jpeg-dir --with-png-dir --with-freetype-dir --with-xsl --enable-bcmath --enable-mbstring --enable-calendar --enable-simplexml --enable-json --enable-hash --enable-session --enable-xml --enable-wddx --enable-opcache --with-pcre-regex --with-config-file-path=/etc/php7/cli --with-config-file-scan-dir=/etc/php7/etc --enable-cli --enable-maintainer-zts --with-tsrm-pthreads --enable-debug --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data"

WORKDIR /

    #set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \

    #update repo
    apt-get update && apt-get upgrade -y && \

    #install dependencies
    apt-get install software-properties-common apt-utils wget -y

    #install apache
RUN apt-get install apache2 -y && \
    service apache2 stop && \

    #install php dependencies for compilation
    apt install -y libzip-dev bison autoconf build-essential pkg-config git-core \
        libltdl-dev libbz2-dev libxml2-dev libxslt1-dev libssl-dev libicu-dev \
        libpspell-dev libenchant-dev libmcrypt-dev libpng-dev libjpeg8-dev \
        libfreetype6-dev libmysqlclient-dev libreadline-dev libcurl4-openssl-dev && \

    #download php source
    wget https://github.com/php/php-src/archive/php-${PHPVER}.tar.gz && \
    #extract php source
    tar --extract --gzip --file php-${PHPVER}.tar.gz && \
    cd php-src-php-${PHPVER} && \
    #build configuration
    ./buildconf --force && \
    ./configure $PHPCNF && \

    #compilation
    make && make install && \

    #install additional packages for php
    apt-get install php-dev php-pear libapache2-mod-php -y && \

    #install certbot, sendmail and ssmtp for ssl and mails
    add-apt-repository ppa:certbot/certbot -y && \
    apt-get update && \
    apt-get install python-certbot-apache -y

COPY ./scripts /scripts
COPY ./entrypoint-custom /
RUN chmod +x /entrypoint-custom
RUN chmod +x /scripts/*
ENTRYPOINT ["/entrypoint-custom"]
CMD ["run"]
