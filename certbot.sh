#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "Error: This script should be run as root"
    exit 1
fi

OPTIND=1
conf_file="aws-config"
operation="certonly"

while getopts "h?rc:d:" opt; do
    case "$opt" in
        h|\?)
            show_help
            exit 0 ;;
        r)  operation="renew" ;;
        c)  conf_file=$OPTARG ;;
        d)  domains+=("-d $OPTARG") ;;
    esac
done
shift $((OPTIND -1))

echo "Using config file \`${conf_file}'"
echo "Performing operation \`${operation}'"
echo "Validating domains \`${domains[@]}'"

if [ ! -f "${conf_file}" ]; then
    echo "Error: Configuration file \`\`${conf_file}'' not found."
    exit 1
fi

docker pull certbot/dns-route53

echo "Running Certbot"
docker run -it --rm --name certbot \
    --env AWS_CONFIG_FILE=/etc/aws-config \
    -v "${PWD}/${conf_file}:/etc/aws-config" \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    certbot/dns-route53 \
    $operation \
    ${domains[@]} \
    --dns-route53 \
    --server https://acme-v02.api.letsencrypt.org/directory
