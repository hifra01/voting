FROM php:7.4-apache
RUN apt update \
        && apt install -y \
            g++ \
            libicu-dev \
            libpq-dev \
            libzip-dev \
            zip \
            zlib1g-dev \
        && docker-php-ext-install \
            intl \
            opcache \
            pdo \
            pdo_pgsql \
            pgsql
WORKDIR /var/www/html

COPY . .

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN a2enmod rewrite
RUN a2enmod headers
RUN composer install
RUN mkdir -p storage/app/public/user-verification
RUN mkdir -p storage/app/public/candidate
RUN php artisan storage:link
RUN chown -R www-data:www-data /var/www/html
