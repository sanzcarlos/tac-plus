# Compile tac_plus
FROM alpine:3.7 as build

MAINTAINER Carlos Sanz <carlos.sanzpenas@gmail.com>

LABEL Name=tac_plus
LABEL Version=1.0.0

ARG SRC_VERSION=201712190728
ARG SRC_HASH=c7a8dbc5e6561a2fbc608142520a88e05fda22e9a664f3184ffe2f8b4821cf2c

ADD http://www.pro-bono-publico.de/projects/src/DEVEL.$SRC_VERSION.tar.bz2 /tac_plus.tar.bz2

RUN echo "${SRC_HASH}  /tac_plus.tar.bz2" | sha256sum -c -

RUN apk update && \
    apk add build-base bzip2 perl perl-digest-md5 perl-ldap && \
    tar -xjf /tac_plus.tar.bz2 && \
    cd /PROJECTS && \
    ./configure --prefix=/tacacs && \
    make && \
    make install && \
    rm -fr tac_plus.tar.bz2

# Move to a clean, small image
FROM alpine:3.7

COPY --from=build /tacacs /tacacs
COPY tac_plus.cfg /etc/tac_plus/tac_plus.cfg
COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 49

ENTRYPOINT ["/docker-entrypoint.sh"]
