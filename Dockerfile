FROM php:5.4-fpm
MAINTAINER David Parrish <daveparrish@tutanota.com>

# Update Debian (so additional software can be installed with apt-get)
RUN apt-get -y update

# Install required PHP extensions.
# gd
RUN apt-get -y --no-install-recommends install libpng12-dev libjpeg-dev && \
docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr && \
docker-php-ext-install gd
# MySQL
RUN docker-php-ext-install mysqli mysql
# mbstring
RUN docker-php-ext-configure mbstring --enable-mbstring && \
docker-php-ext-install mbstring
# pcntl (required by drush 7.x)
RUN docker-php-ext-install pcntl
# zip (required by drush 7.x)
RUN docker-php-ext-install zip

# Install msmtp
RUN apt-get -y --no-install-recommends install msmtp

# Install mariadb client (required for 'drush sqlc')
RUN apt-get -y --no-install-recommends install mariadb-client

# http://docs.drush.org/en/master/install/
# Install Composer for installing Drush
RUN curl -sS https://getcomposer.org/installer | php && \
mv composer.phar /usr/local/bin/composer && \
ln -s /usr/local/bin/composer /usr/bin/composer

# Install Drush (latest)
RUN apt-get -y --no-install-recommends install git && \
git clone https://github.com/drush-ops/drush.git /usr/local/src/drush && \
cd /usr/local/src/drush && \
git checkout 7.x && \
ln -s /usr/local/src/drush/drush /usr/bin/drush && \
composer install

# Clean up apt
RUN apt-get clean && \
rm -r /var/lib/apt/lists/*
