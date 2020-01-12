FROM php:7.3-fpm

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    iputils-ping \
    libicu-dev \
    libmemcached-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    libxml2-dev \
    libbz2-dev \
    libjpeg62-turbo-dev \
    librabbitmq-dev \
    libzip-dev \
    curl \
    unzip \
  && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure bcmath --enable-bcmath \
  && docker-php-ext-configure pcntl --enable-pcntl \
  && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
  && docker-php-ext-configure mbstring --enable-mbstring \
  && docker-php-ext-configure soap --enable-soap \
  && docker-php-ext-install \
    bcmath \
    intl \
    mbstring \
    mysqli \
    pcntl \
    pdo_mysql \
    soap \
    sockets \
    zip \
  && docker-php-ext-configure gd \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 \
  && docker-php-ext-install gd \
  && docker-php-ext-install opcache \
  && docker-php-ext-enable opcache \
  && pecl install amqp \
  && docker-php-ext-enable amqp \
  && docker-php-ext-configure intl \
  && docker-php-ext-install intl \
  && pecl install redis \
  && docker-php-ext-enable redis

COPY config/php.ini /usr/local/etc/php/conf.d/z-php.ini

WORKDIR /var/www/app