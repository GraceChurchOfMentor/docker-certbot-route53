#!/bin/bash

aws_config_file="aws-config"
operation="certonly"
config_path="/etc/letsencrypt"

usage() {
    echo "Usage: $0 [ -r ] [ -c AWS_CONFIG_FILE ] [ -p CONFIG_PATH ] [ -d DOMAIN [ -d DOMAIN [ ... ]]]" 1>&2
}

OPTS=`getopt -o hrc:p:d: --long help,renew,aws-config-file:,config-path:,domain: -- "$@"`
eval set -- "$OPTS"
while true; do
    case "$1" in
        -h|--help)
            usage
            exit 0 ;;
        -r|--renew)
            operation="renew" ;;
        -c|--aws-config-file)
            aws_config_file=$2 ; shift 2 ;;
        -p|--config-path)
            config_path=$2 ; shift 2 ;;
        -d|--domain)
            domains+=("-d $2") ; shift 2 ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

echo "AWS config file: ${aws_config_file}"
echo "Operation: ${operation}"
echo "Config path: ${config_path}"
if [ -v domains[@] ]; then
    echo "Domains: ${domains[@]}"
else
    echo "No domains specified"
fi

if [[ $EUID -ne 0 ]]; then
    echo "Error: This script should be run as root"
    exit 1
fi

if [ ! -f "${aws_config_file}" ]; then
    echo "Error: Configuration file \`\`${aws_config_file}'' not found."
    exit 1
fi

mkdir -p $config_path
cp $aws_config_file $config_path/aws-config

docker pull certbot/dns-route53

echo "Running Certbot"
docker run -it --rm --name certbot \
    --env AWS_CONFIG_FILE=/etc/letsencrypt/aws-config \
    -v "${config_path}:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    certbot/dns-route53 \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --dns-route53 \
    $operation \
    ${domains[@]}
