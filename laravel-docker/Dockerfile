FROM php:8.2-fpm

RUN apt-get update && apt-get install -y     zip unzip git curl libpng-dev libonig-dev libxml2-dev     libzip-dev cron supervisor     && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
