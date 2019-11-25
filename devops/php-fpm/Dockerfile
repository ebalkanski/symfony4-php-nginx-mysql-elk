FROM php:7.3-fpm

ARG TIMEZONE
ARG USER_ID
ARG GROUP_ID

ENV COMPOSER_HOME /.composer

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
    git \
    ssh-client \
    bash-completion \
  && rm -rf /var/lib/apt/lists/*

# Install various PHP extensions
RUN docker-php-ext-configure bcmath --enable-bcmath \
  && docker-php-ext-configure pcntl --enable-pcntl \
  && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
  && docker-php-ext-configure pdo_pgsql --with-pgsql \
  && docker-php-ext-configure mbstring --enable-mbstring \
  && docker-php-ext-configure soap --enable-soap \
  && docker-php-ext-install \
    bcmath \
    intl \
    mbstring \
    mysqli \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    soap \
    sockets \
    zip \
  && docker-php-ext-configure gd \
    --enable-gd-native-ttf \
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
  && docker-php-ext-enable redis \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo ${TIMEZONE} > /etc/timezone \
  && printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini \
  && "date"

# Copy php configuration
COPY ./conf/php.ini /usr/local/etc/php/conf.d/custom-php.ini

# Copy opcache configration
COPY ./conf/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Copy xdebug configration for remote debugging
COPY ./conf/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
     --install-dir=/usr/bin \
     --filename=composer \
  && composer self-update \
  && composer global require "hirak/prestissimo:^0.3" \
  && chown -R www-data:www-data /.composer

# Deal with user permissions and create www-data user
RUN if [ ${USER_ID} -ne 0 ] && [ ${GROUP_ID} -ne 0 ]; then \
    userdel -f www-data &&\
    if getent group www-data ; then groupdel www-data; fi &&\
    groupadd -g ${GROUP_ID} www-data &&\
    useradd -l -u ${USER_ID} -g www-data www-data &&\
    install -d -m 0755 -o www-data -g www-data /home/www-data &&\
    chown --changes --silent --no-dereference --recursive \
          --from=33:33 ${USER_ID}:${GROUP_ID} \
        /home/www-data \
        /.composer \
;fi

# Custom .bashrc
ADD ./bashrc/.bashrc /custom-bashrc
RUN cat /custom-bashrc >> /home/www-data/.bashrc

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

USER www-data