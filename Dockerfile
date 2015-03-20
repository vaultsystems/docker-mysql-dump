FROM mysql:5.7

RUN apt-get update && apt-get install -y python-pip python-dev gcc g++ --no-install-recommends && rm -rf /var/lib/apt/lists/* && pip install python-swiftclient python-keystoneclient 

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
