#!/bin/sh

docker run -it --rm --name certbot \
    --env AWS_CONFIG_FILE=/etc/aws-config \
    -v "${PWD}/aws-config:/etc/aws-config" \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    certbot/dns-route53 certonly --dns-route53 --server https://acme-v02.api.letsencrypt.org/directory
