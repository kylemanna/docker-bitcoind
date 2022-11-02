# Use the latest available Ubuntu image as build stage
FROM ubuntu:latest as builder

# Upgrade all packages and install dependencies
RUN apt-get update \
    && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        gnupg \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set variables necessary for download and verification of bitcoind
ARG TARGETARCH
ARG ARCH
ARG VERSION=23.0
ARG BITCOIN_CORE_SIGNATURE=71A3B16735405025D447E8F274810B012346C9A6

# Don't use base image's bitcoin package for a few reasons:
# 1. Would need to use ppa/latest repo for the latest release.
# 2. Some package generates /etc/bitcoin.conf on install and that's dangerous to bake in with Docker Hub.
# 3. Verifying pkg signature from main website should inspire confidence and reduce chance of surprises.
# Instead fetch, verify, and extract to Docker image
RUN case ${TARGETARCH:-amd64} in \
    "arm64") ARCH="aarch64";; \
    "amd64") ARCH="x86_64";; \
    *) echo "Dockerfile does not support this platform"; exit 1 ;; \
    esac \
    && gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys ${BITCOIN_CORE_SIGNATURE} \
    && wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc \
            https://bitcoincore.org/bin/bitcoin-core-${VERSION}/SHA256SUMS \
            https://bitcoincore.org/bin/bitcoin-core-${VERSION}/bitcoin-${VERSION}-${ARCH}-linux-gnu.tar.gz \
    && gpg --verify --status-fd 1 --verify SHA256SUMS.asc SHA256SUMS 2>/dev/null | grep "^\[GNUPG:\] VALIDSIG.*${BITCOIN_CORE_SIGNATURE}\$" \
    && sha256sum --ignore-missing --check SHA256SUMS \
    && tar -xzvf bitcoin-${VERSION}-${ARCH}-linux-gnu.tar.gz -C /opt \
    && ln -sv bitcoin-${VERSION} /opt/bitcoin \
    && /opt/bitcoin/bin/test_bitcoin --show_progress \
    && rm -v /opt/bitcoin/bin/test_bitcoin /opt/bitcoin/bin/bitcoin-qt

# Use latest Ubuntu image as base for main image
FROM ubuntu:latest
LABEL author="Kyle Manna <kyle@kylemanna.com>" \
      maintainer="Seth For Privacy <seth@sethforprivacy.com>"

WORKDIR /bitcoin

# Set bitcoin user and group with static IDs
ARG GROUP_ID=1000
ARG USER_ID=1000
RUN groupadd -g ${GROUP_ID} bitcoin \
    && useradd -u ${USER_ID} -g bitcoin -d /bitcoin bitcoin

# Copy over bitcoind binaries
COPY --chown=bitcoin:bitcoin --from=builder /opt/bitcoin/bin/ /usr/local/bin/

# Upgrade all packages and install dependencies
RUN apt-get update \
    && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gosu \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy scripts to Docker image
COPY ./bin ./docker-entrypoint.sh /usr/local/bin/

# Enable entrypoint script
ENTRYPOINT ["docker-entrypoint.sh"]

# Set HOME
ENV HOME /bitcoin

# Expose default p2p and RPC ports
EXPOSE 8332 8333

# Expose default bitcoind storage location
VOLUME ["/bitcoin/.bitcoin"]

CMD ["btc_oneshot"]
