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

Use the *certbot.sh* script to validate new domains.

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


What if I have multiple AWS accounts?
-------------------------------------

So do we! The *certbot.sh* script handles this nicely. Just use the
*--aws-config-file* and *--config-path* options to specify credentials and a
place to save them. In our case, we've set up a dot-d directory at  */etc/letsencrypt.d*,
as follows:

```
/etc
 +- /letsencrypt.d
     +- /arch
     +- /gcm
     +- /glbi
```

To issue new certs for Arch Ministries, we use a command like this:

```
$ ./certbot.sh --aws-config-file=aws-config.arch --config-path=/etc/letsencrypt.d/arch -d archmin.org -d *.archmin.org
```

This command sets up a directory for Arch in */etc/letsencrypt.d*, copies the
local *aws-config.arch* file to */etc/letsencrypt.d/arch/aws-config*, and mounts
this directory to the docker container's default Lets Encrypt config location.

### Automating Renewals

This setup makes easy work of automating certificate renewals for multiple AWS
accounts. Check out the *renewal-cron.sh* script in this repo for details.
