ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG USER_ID
ARG GROUP_ID

ENV COMPOSER_HOME /.composer

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    git \
    ssh-client \
    bash-completion \
    vim \
    nano \
  && rm -rf /var/lib/apt/lists/*

RUN pecl install xdebug \
  && docker-php-ext-enable xdebug

COPY config/php.ini /usr/local/etc/php/conf.d/zz-php.ini

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
COPY bashrc/.bashrc /home/www-data/.bashrc

USER www-data