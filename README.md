# Cebus
Docker image with php, pear, xdiff, pagespeed, apache and certbot. Based on ubuntu:bionic

Docker hub : [monkeycompany/cebus](https://hub.docker.com/r/monkeycompany/cebus/)

Github project : [monkey-company/cebus](https://github.com/monkey-company/cebus/)

## Global check

[![Monkey Company](https://img.shields.io/badge/Monkey-Company-red.svg?longCache=true&style=flat)](https://themonkey.co/)
![GitHub](https://img.shields.io/github/license/monkey-company/cebus.svg)
[![Build Status](https://travis-ci.org/monkey-company/cebus.svg?branch=master)](https://travis-ci.org/monkey-company/cebus)
![GitHub last commit](https://img.shields.io/github/last-commit/monkey-company/cebus.svg)
[![GitHub release](https://img.shields.io/github/release/monkey-company/cebus.svg)](https://github.com/monkey-company/cebus/releases/latest)
![GitHub repo size in bytes](https://img.shields.io/github/repo-size/monkey-company/cebus.svg)
[![Docker Pulls](https://img.shields.io/docker/pulls/monkeycompany/cebus.svg)](https://hub.docker.com/r/monkeycompany/cebus/)
![GitHub language count](https://img.shields.io/github/languages/count/monkey-company/cebus.svg)

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fmonkey-company%2Fcebus.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fmonkey-company%2Fcebus?ref=badge_large)

## Builds

- **STANDARD** : php, pear, xdiff, pagespeed, apache, certbot
  - Last stable : ```monkeycompany/cebus:latest```
  - Last testing : ```monkeycompany/cebus:testing```
- **NGINX** : php, pear, xdiff, pagespeed, nginx, certbot **(Coming soon !)**
  - Last stable : ```monkeycompany/cebus:nginx```
  - Last testing : ```monkeycompany/cebus:nginx-testing```
- **MULTI-THREADING** : php-zts, pear, xdiff, pagespeed, apache, certbot, parallel **(Coming soon !)**
  - Last stable : ```monkeycompany/cebus:mt```
  - Last testing : ```monkeycompany/cebus:mt-testing```
- **MULTI-THREADING NGINX** : php-zts, pear, xdiff, pagespeed, nginx, certbot, parallel **(Coming soon !)**
  - Last stable : ```monkeycompany/cebus:mt-nginx```
  - Last testing : ```monkeycompany/cebus:mt-nginx-testing```  

## Tag mechanism
Template : ```monkeycompany/cebus:[BUILD]-[VERSION]```

### Examples :
- Version 1.2.3 for **STANDARD** : ```monkeycompany/cebus:std-1.2.3```
- Version 1.0.2 for **MULTI-THREADING NGINX** : ```monkeycompany/cebus:mt-nginx-1.0.2```

# **/!\\ DOCUMENTATION FOR STANDARD BUILD /!\\**

## Variables

- DOMAIN : ```localhost``` domain for let's encrypt
- EMAIL : ``` admin@localhost ``` email for let's encrypt
- TZ : ``` Europe/Paris ``` timezone
- SHFILE : ``` /etc/apache2/file.sh ``` additionnal script for cron or other
- PAGESPEED : ``` false ``` install google pagespeed module apache
- LIBMOD : ``` re2c ``` additionnal dependencies
- APAMOD : ``` cache,rewrite,ssl,headers ``` apache2 modules
- ADPMOD : ``` autoindex ``` apache2 disable modules
- PHPMOD : ``` bcmath,bz2,intl,gd,mbstring,mysql,zip ``` php modules
- PEAMOD : ``` xdiff ``` pear packages

## Volumes
- Let's encrypt configuration : ```/etc/letsencrypt/```
- Apache configuration : ```/etc/apache2/```
- PHP configuration : ```/etc/php/```
- Apache webroot : ```/var/www/html/```

## Port
- HTTP : ```80```
- HTTPS : ```443```

## Tutorial

### Quick start

Run the ```docker run -d --restart=unless-stopped -p 80:80 -p 443:443 -v ${PWD}/path/letsencrypt-conf/:/etc/letsencrypt/ -v ${PWD}/path/apache-conf/:/etc/apache2/ -v ${PWD}/path/php-conf/:/etc/apache2/ -v ${PWD}/path/www/:/var/www/html/ -e DOMAINS='example.com' -e EMAIL='admin@example.com' monkeycompany/cebus:latest``` command.

#### Step one

Create a ```docker-compose.yml``` file or import yaml in Rancher.

```yaml
cebus:
  image: monkeycompany/cebus:latest
  ports:
    - '80:80'
    - '443:443'
  environment:
    DOMAINS: 'example.com'
    EMAIL: 'admin@example.com'
    PAGESPEED: 'true'
    LIBMOD: 're2c'
    APAMOD: 'cache,rewrite,ssl,headers'
    APDMOD: 'autoindex'
    PHPMOD: 'bcmath,bz2,intl,gd,mbstring,mysql,zip'
    PEAMOD: 'xdiff'

  volumes:
    - ${PWD}/path/letsencrypt-conf/:/etc/letsencrypt/
    - ${PWD}/path/apache-conf/:/etc/apache2/
    - ${PWD}/path/php-conf/:/etc/php/
    - ${PWD}/path/www/:/var/www/html/
```

#### Step two

Run the ```docker-compose up``` command in the same directory.

#### Step three

Run the ```certbot --apache --non-interactive --agree-tos --email $EMAIL --domains $DOMAINS certonly``` command in the container.

#### Step four (For k8s, rancher)

If you use Kubernetes or Rancher, regenerate all the containers to apply the configurations in volumes.

#### Step five (Optionnal)

If you need cron or additionnal commands, use the variable ``` SHFILE ``` for define a path and make script file :)
