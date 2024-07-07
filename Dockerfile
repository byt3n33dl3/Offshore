FROM alpine:3.11

COPY . offshore
RUN apk add --no-cache --virtual .build-deps \
        build-base \
        cmake \
        boost-dev \
        openssl-dev \
        mariadb-connector-c-dev \
    && (cd offshore && cmake . && make -j $(nproc) && strip -s offshore \
    && mv offshore /usr/local/bin) \
    && rm -rf offshore \
    && apk del .build-deps \
    && apk add --no-cache --virtual .offshore-rundeps \
        libstdc++ \
        boost-system \
        boost-program_options \
        mariadb-connector-c

WORKDIR /config
CMD ["offshore", "config.json"]
