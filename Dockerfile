FROM php:5-fpm
MAINTAINER David Parrish <daveparrish@tutanota.com>

# Update Debian (so additional software can be installed with apt-get)
RUN apt-get -y update && \

# Install required PHP extensions.
# gd
apt-get -y --no-install-recommends install libpng12-dev libjpeg-dev && \
docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr && \
docker-php-ext-install gd && \
# MySQL
docker-php-ext-install pdo pdo_mysql && \
# mbstring
docker-php-ext-configure mbstring --enable-mbstring && \
docker-php-ext-install mbstring && \
# pcntl (required by drush 7.x)
# zip (required by drush 7.x)
# opcache
docker-php-ext-install pcntl zip opcache && \

# Install msmtp
apt-get -y --no-install-recommends install msmtp && \

# Install mariadb client (required for 'drush sqlc')
apt-get -y --no-install-recommends install mariadb-client && \

# http://docs.drush.org/en/master/install/
# Install Composer for installing Drush
curl -sS https://getcomposer.org/installer | php && \
mv composer.phar /usr/local/bin/composer && \
ln -s /usr/local/bin/composer /usr/bin/composer && \

# Install Drush (latest)
apt-get -y --no-install-recommends install git && \
git clone https://github.com/drush-ops/drush.git /usr/local/src/drush && \
cd /usr/local/src/drush && \
git checkout 7.x && \
ln -s /usr/local/src/drush/drush /usr/bin/drush && \
composer install && \

# Clean up apt
apt-get clean && \
rm -r /var/lib/apt/lists/* && \

# Extract php source files files for use downstream
tar -C "/usr/src" -xvf "/usr/src/php.tar.xz" && \
mv /usr/src/php-$PHP_VERSION /usr/src/php
