ARG PHP_VERSION=8.3

FROM php:${PHP_VERSION}-cli-alpine
LABEL authors="dannypas00"

ARG USER=app
ARG USER_ID=1000

COPY --from=mlocati/php-extension-installer --link /usr/bin/install-php-extensions /usr/local/bin/

RUN set -eux; install-php-extensions \
    exif \
    soap \
    pcntl \
    intl \
    gmp \
    zip \
    pdo_mysql \
    sockets \
    gd \
    redis \
    xdebug \
    memcached \
    @composer

RUN set-eux; apk add --update npm

RUN set -eux; \
	adduser -u ${USER_ID} -h /home/${USER} -D ${USER}; \
    npm config --global set cache=/home/${USER}/.npm; \
    mkdir /home/${USER}/.npm || true; \
    mkdir /app || true; \
    chown -R ${USER_ID}:${USER_ID} /home/${USER}/.npm /app

HEALTHCHECK CMD php -v

USER ${USER}

WORKDIR /app
