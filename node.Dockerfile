FROM nodejs:21.7.3
LABEL authors="dannypas00"

ARG USER=app
ARG USER_ID=1000

# Create custom user
RUN set -eux; useradd -u ${CUSTOM_USER_ID} -m ${USER}; \
    npm config --global set cache=/home/${USER}/.npm; \
    mkdir /home/${USER}/.npm || true; \
    mkdir /app || true; \
    chown -R ${CUSTOM_USER_ID}:${CUSTOM_USER_ID} /home/${USER}/.npm /app

HEALTHCHECK CMD node -v

USER ${USER}

WORKDIR /app
