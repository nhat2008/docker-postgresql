FROM ubuntu:14.04

MAINTAINER Nhat Nguyen <nminhnhat2008@gmail.com>

# Add postgres user/group with fixed ID
RUN mkdir /data &&\
    addgroup --gid=1000 postgres && adduser --system --uid=1000 --gid=1000 --home /home/postgres --shell /bin/bash postgres &&\
    chown -R postgres:postgres /data

# Create data folder and serve it for usage of other postgresql container
VOLUME ["/data"]