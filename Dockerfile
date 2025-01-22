# build stage
FROM node:lts-alpine AS build-stage
RUN apk update && apk add --no-cache
RUN apk add --upgrade brotli
WORKDIR /app
COPY . .
RUN npm ci 
RUN npm run build
RUN cd ./dist/spa && find . -type f -exec brotli {} \;

# Brotli module builder
FROM alpine:latest AS builder
ARG NGINX_VERSION=1.25.4
ARG NGINX_PKG_RELEASE=1
ARG MODULE_NAME=ngx_brotli

RUN apk add --no-cache --virtual .build-deps \
    alpine-sdk \
    linux-headers \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    libxslt-dev \
    gd-dev \
    geoip-dev \
    git \
    mercurial 

RUN git clone https://github.com/google/ngx_brotli.git /ngx_brotli && \
    cd /ngx_brotli && \
    git submodule update --init

RUN hg clone https://hg.nginx.org/pkg-oss
RUN printf "#!/bin/sh\\nSETFATTR=true /usr/bin/abuild -F \"\$@\"\\n" > /usr/local/bin/abuild \
    && chmod +x /usr/local/bin/abuild

WORKDIR /pkg-oss
RUN ./build_module.sh --force-dynamic -v $NGINX_VERSION -n $MODULE_NAME -o /tmp/pkg /ngx_brotli
RUN mkdir -p /tmp/modules && mv /tmp/pkg/*.apk /tmp/modules/

# production stage
FROM nginx:1.25.4-alpine3.18 AS production-stage

COPY --from=builder /tmp/modules/*.apk /tmp/
RUN apk add --allow-untrusted /tmp/*.apk && rm -rf /tmp/*.apk

COPY --from=build-stage /app/dist/spa /usr/share/nginx/html
RUN { \
    echo 'load_module modules/ngx_http_brotli_filter_module.so;'; \
    echo 'load_module modules/ngx_http_brotli_static_module.so;'; \
    cat /etc/nginx/nginx.conf; \
} > temp && mv temp /etc/nginx/nginx.conf

# Configuration Nginx avec Brotli activé
RUN echo $'\n\
server {\n\
    listen       80;\n\
    listen  [::]:80;\n\
    server_name  localhost;\n\
    brotli on;\n\
    brotli_comp_level 6;\n\
    brotli_static on;\n\
    brotli_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;\n\
\n\
    location / {\n\
        set $root_path /usr/share/nginx/html;\n\
        root   $root_path;\n\
        index  index.html index.htm;\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
\n\
    error_page   500 502 503 504  /50x.html;\n\
    location = /50x.html {\n\
        root   /usr/share/nginx/html;\n\
    }\n\
}' > /etc/nginx/conf.d/default.conf

# Script pour injecter la variable API_URL
RUN echo $'#!/bin/sh\n\
if [ -n "$API_URL" ]; then\n\
    echo "Injecting API_URL=$API_URL";\n\
    find /usr/share/nginx/html -type f -name "*.js" -exec sed -i "s|http://localhost:8080|$API_URL|g" {} +;\n\
fi\n\
exec nginx -g "daemon off;"\n' > /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 80
CMD ["/entrypoint.sh"]
