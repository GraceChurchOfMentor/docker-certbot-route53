Easily request wildcard certificates from Let's Encrypt.
--------------------------------------------------------

Let's Encrypt now issues wildcard SSL certificates via their ACMEv2 protocol.
Currently, this requires domain validation via DNS-01 challenge. To make this
practical, you need a DNS provider with programmatic access.

The Certbot project provides [preconfigured Docker
containers](https://hub.docker.com/u/certbot/) for the most popular DNS
providers. We are using Route53, so this repository contains a shell script
customized to use the Certbot-provided Docker container for Route53, and a
template for providing your AWS credentials. See the official Certbot Docker
container docs for details and examples of how to configure your AWS account for
programmatic access.

Why use Docker for this?
------------------------

The ACMEv2 protocol is brand-new, and most Certbot packages are not up-to-date
yet. The official Docker images are updated by the Certbot project and always
contain the latest version.


How do I use it?
----------------

Assuming you already have a functioning Let's Encrypt implementation, all you
have to do is run:

```
$ ./certbot.sh
```

When propmted, enter your domain names. For wildcards, just use an asterisk:

```
$ ./certbot.sh
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Credentials found in config file: /etc/aws-config
Plugins selected: Authenticator dns-route53, Installer None
Please enter in your domain name(s) (comma and/or space separated)  (Enter 'c'
to cancel): example.com,*.example.com
```
