FROM debian:wheezy

MAINTAINER Nhat Nguyen <nminhnhat2008@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ENV PG_MAJOR 9.3
#ENV PG_VERSION 9.3.6-1.pgdg70+1

ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH

ENV PGDATA /data/postgresql

ENV LANG en_US.utf8

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd --gid=1000 postgres && useradd --system --uid=1000 --gid=1000 --home /home/postgres --shell /bin/bash postgres &&\
    mkdir -p ${PGDATA} && chown -R postgres:postgres ${PGDATA}

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && apt-get purge -y --auto-remove curl

# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Directory contains *.sh script execute when container start
RUN mkdir /docker-entrypoint-initdb.d

## Install PostgreSQL
# postgresql-contrib package
# directory of the PostgreSQL distribution.
# These include porting tools, analysis utilities, and plug-in features
# that are not part of the core PostgreSQL system, mainly because
# they address a limited audience or are too experimental to be part of the main source tree

# postgresql-common package
# provides a structure under which multiple versions of PostgreSQL
# may be installed and/or multiple clusters maintained at one time.
# This package will automatically create a (self-signed) certificate so that SSL connections are supported.

# CANNOT VERIFY postgresql-common, postgresql postgresql-contrib package signature, added --force-yes
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get install -y --force-yes postgresql-common \
    && sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf \
    && apt-get install -y --force-yes \
        postgresql-$PG_MAJOR \
        postgresql-contrib-$PG_MAJOR \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/postgresql && chown -R postgres:postgres /var/run/postgresql

COPY docker-entrypoint.sh /

EXPOSE 5432

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["postgres"]