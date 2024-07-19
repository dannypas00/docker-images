ARG FRANK_VERSION=1.2
ARG PHP_VERSION=8.3

FROM dunglas/frankenphp:${FRANK_VERSION}-php${PHP_VERSION}-alpine
LABEL authors="dannypas00"

ARG USER=app
ARG USER_ID=1000

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
    memcached

RUN set-eux; apk add --update npm

# Create custom user
RUN set -eux; \
	adduser -u ${USER_ID} -h /home/${USER} -D ${USER}; \
	# Add additional capability to bind to port 80 and 443
	setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/frankenphp; \
	# Give write access to /data/caddy and /config/caddy
	chown -R ${USER_ID}:${USER_ID} /data/caddy && chown -R ${USER_ID}:${USER_ID} /config/caddy; \
    npm config --global set cache=/home/${USER}/.npm; \
    mkdir /home/${USER}/.npm || true; \
    mkdir /app || true; \
    chown -R ${USER_ID}:${USER_ID} /home/${USER}/.npm /app;

# Very basic health check because frankenphp's healthcheck to metrics endpoint sometimes breaks when changing ports
HEALTHCHECK CMD php -v

USER ${USER}

WORKDIR /app
