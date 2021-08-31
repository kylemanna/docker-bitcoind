# Using docker-compose

## Prerequisites

Docker and docker-compose. On Debian/Ubuntu, docker-compose can be installed with `sudo apt install docker-compose`

## Variables

First, `cp default.env .env` and adjust variables. Most importantly, username and password for the RPC port.

Next, decide how to run bitcoin core: With RPC mapped to localhost, or with a traefik reverse proxy.

Adjust `COMPOSE_FILE` as needed for this, adding additional `.yml` files with `:` between them.

- `btc.yml` - the core file for bitcoind
- `btc-shared.yml` - expose RPC port to host on 127.0.0.1 only
- `traefik-cf.yml` - use traefik reverse proxy instead, with Let's Encrypt and CloudFlare for DNS verification
- `traefik-aws.yml` - use traefik reverse proxy with Let's Encrypt and AWS Route 53 for DNS verification
- `ext-network.yml` - if traefik runs outside this "stack" and you want to connect to that external network

## Using docker-compose

For all of the following, you can leave `sudo` off if your user is part of the `docker` group.

Start bitcoind via `sudo docker-compose up -d`.

Stop bitcoind via `sudo docker-compose down`.

Watch logs via `sudo docker-compose logs -f bitcoind`.

## Traefik

You will require a domain name for this to work. Where you buy it is up to you. One option is NameCheap.

As a 450m overview, traefik will be reachable via port 443 / https from the Internet (configurable, could be 8443 if you prefer). All
browsing attempts to it will be checked by traefik for their hostname, and it steers traffic to bitcoind thereby.

For example, say I have a domain `example.com`, and left the `_HOST` setting in `.env` at default.
`https://btc.example.com/` will get me to my bitcoind RPC port.

### Cloudflare for DNS management

With this option, CloudFlare will provide DNS management. Traefik uses CloudFlare to issue a Let's Encrypt certificate for
your domain. This also automatically updates the IP address of the domain, which is useful if you are on a dynamic address, such as domestic Internet. Either for
the main domain `example.com` or if desired for a subdomain such as `btc.example.com`.

You'll add `traefik-cf.yml` to your `COMPOSE_FILE` in `.env`, for example: `btc.yml:traefik-cf.yml`

Create a (free) CloudFlare account and set up your domain, which will require pointing nameservers for your domain
to Cloudflare's servers. How this is done depends on your domain registrar.

With NameCheap, "Manage" your domain from the Dashboard, then change "NameServers" to "Custom DNS", add the
CloudFlare servers, and finally hit the green checkmark next to "Custom DNS".

You will need a "scoped API token" from CloudFlare's [API page](https://dash.cloudflare.com/profile/api-tokens). Create a token with `Zone.DNS:Edit`, `Zone.Zone:Read` and `Zone.Zone Settings:Read` permissions, for all zones. This will not work if it is issued for a specific zone only. Make a note of the Token secret, it will only be shown to you once.

With that, in the `.env` file:
- Set `CF_EMAIL` to your CloudFlare login email
- Set `CF_API_TOKEN` to the API token you just created
- Set `DDNS_SUBDOMAIN` if you want the Dynamic DNS IP address update to act on a specific subdomain name, rather than the main domain
- Set `DDNS_PROXY` to `false` if you do not want CloudFlare to proxy traffic to the domain / subdomain
- Read further down about common settings for Traefik

#### CNAMEs and proxy settings

You need CNAMEs or A records for the services you make available. Assuming you have set the main domain with the IP address of your host, and keeping the
default names in `.env`, set the CNAMEs for the service you use:

- `btc` CNAME to `@`, DNS only, for the bitcoind RPC https:// port

### AWS for DNS management

With this option, AWS Route53 will provide DNS management. Traefik uses CloudFlare to issue a Let's Encrypt certificate for
your domain. It does not create an A record for you, that is left up to you.

You'll add `traefik-aws.yml` to your `COMPOSE_FILE` in `.env`, for example: `btc.yml:traefik-aws.yml`

This setup assumes that you already have an AWS named user profile in `~/.aws` on the node itself. If not, [please create one](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html). The IAM user will need to have the AWS-managed `AmazonRoute53DomainsFullAccess` policy [attached to it](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-attach-detach.html).

With that, in the `.env` file:
- Set `AWS_PROFILE` to the profile you want to use
- Set `AWS_HOSTED_ZONE_ID` to the Route53 zone you are going to use

### A records and CNAMEs

Assuming you use the default names in `.env`:

- An A record for your service such as `btc.example.com`, or on the domain itself `example.com` to use for CNAMEs. The A record will be the IP
  address of your node
- Optionally, additional CNAME for `btc`, if you chose to make the A record domain-wide

## Traefik common settings

Two settings in `.env` are required, and one is optional.

- `DOMAIN` needs to be set to your domain
- `ACME_EMAIL` is the email address Let's Encrypt will use to communicate with you. This need not be the same address as your DNS provider's account.

Optionally, you can change the name that bitcoind is reachable under, and adjust CNAME to match. This is the `BTC_HOST` variable.

