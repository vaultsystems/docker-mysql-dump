FROM ubuntu:trusty

RUN apt-get update && apt-get install -y mysql-client python-swiftclient --no-install-recommends && apt-get clean && rm -rf /var/lib/apt/lists/* 

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
