ARG NODE_VERSION=22.11.0

FROM node:${NODE_VERSION}-alpine
LABEL authors="dannypas00"

# Create custom user
RUN npm config --global set cache=/home/node/.npm; \
    mkdir /home/node/.npm || true; \
    mkdir /app || true; \
    chown -R 1000:1000 /home/node/.npm /app

HEALTHCHECK CMD node -v

USER node

WORKDIR /app
