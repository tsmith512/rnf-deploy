# PHP + Apache
FROM php:7.4-apache

# Update OS and install common dev tools
RUN apt-get update
RUN apt-get install -y curl libcurl4-openssl-dev wget vim git zip unzip zlib1g-dev libzip-dev libpng-dev ssl-cert libonig5 libonig-dev libxml2-dev

RUN apt-get install -y libmagickwand-dev --no-install-recommends

# Install PHP extensions needed
RUN docker-php-ext-install -j$(nproc) mysqli pdo_mysql gd zip pcntl exif intl curl json mbstring opcache xml zip

# Install the PHP ImageMagick extension
RUN printf "\n" | pecl install imagick
RUN docker-php-ext-enable imagick

# Enable common Apache modules
RUN a2enmod headers expires rewrite ssl

RUN a2ensite default-ssl

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp-cli
RUN chmod +x /usr/local/bin/wp-cli

RUN git config --system --add safe.directory /var/www/html

# Set working directory to workspace
WORKDIR /var/www
