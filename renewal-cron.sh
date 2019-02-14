#!/bin/bash

for D in /etc/letsencrypt.d/*
do
    docker run -it --rm --name certbot \
        --env AWS_CONFIG_FILE=/etc/letsencrypt/aws-config \
        -v "${D}:/etc/letsencrypt" \
        -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
        certbot/dns-route53 \
        renew \
        --dns-route53 \
        --server https://acme-v02.api.letsencrypt.org/directory
done
