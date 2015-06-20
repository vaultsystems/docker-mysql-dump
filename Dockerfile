FROM ubuntu:trusty

RUN apt-get update && apt-get install -y mysql-client python-swiftclient --no-install-recommends && apt-get clean && rm -rf /var/lib/apt/lists/* 

RUN echo Australia/Sydney > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

ADD *.sh /
ENTRYPOINT ["/entrypoint.sh"]
