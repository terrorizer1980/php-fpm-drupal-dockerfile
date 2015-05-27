FROM php:fpm
MAINTAINER David Parrish <daveparrish@gmail.com>

# Update Debian (so additional software can be installed with apt-get)
RUN apt-get -y update && \
apt-get -y upgrade

# Install MySQL client (and Update Debian)
RUN apt-get -y install python-software-properties && \
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db && \
apt-get -y install software-properties-common && \
add-apt-repository 'deb http://mariadb.biz.net.id//repo/10.1/debian sid main' && \
apt-get -y update && \
apt-get -y install mariadb-client

# Turn on mysql client auto-complete
RUN sed -i 's/no-auto-rehash/auto-rehash/g' /etc/mysql/my.cnf

# Install required PHP extensions.
# gd
RUN apt-get -y install libgd-dev libjpeg62-turbo-dev && \
docker-php-ext-configure gd --with-jpeg-dir=/usr/include && \
docker-php-ext-install gd
# gettext and MySQL
RUN docker-php-ext-install gettext pdo_mysql
# mbstring
RUN docker-php-ext-configure mbstring --enable-mbstring && \
docker-php-ext-install mbstring
# zip (to install Drush)
RUN docker-php-ext-install zip

# Configure PHP
COPY php.ini /usr/local/etc/php/

# Install Composer for installing Drush
RUN curl -sS https://getcomposer.org/installer | php && \
mv composer.phar /usr/local/bin/composer && \
ln -s /usr/local/bin/composer /usr/bin/composer

# Install Drush
RUN apt-get -y install git && \
git clone https://github.com/drush-ops/drush.git /usr/local/src/drush && \
cd /usr/local/src/drush && \
composer global require drush/drush:6.* && \
git checkout 6.6.0 && \
ln -s /usr/local/src/drush/drush /usr/bin/drush && \
composer install

# Add script for running service
ADD start_php_fpm.sh /opt/start_php_fpm.sh

# Set working directory to Drupal
WORKDIR /srv/http/drupal

# vi: set tabstop=4 expandtab :
