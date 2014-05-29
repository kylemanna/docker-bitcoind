docker-bitcoind
===============

Docker image that runs a bitcoind node in a container for easy deployment.

Quick Start
-----------

1. Create a bitcoind-data volume to persist the bitcoind blockchain data, should exit immediately.  The bitcoind-data container will store the blockchain when the node container is remade later (software upgrade, reboot, etc):

        $ docker run --name=bitcoind-data kylemanna/bitcoind --help

2. Run a Bitcoin node and use the data volume:

        $ docker run --volumes-from=bitcoind-data --name=bitcoind-node -d -p 8333:8333 kylemanna/bitcoind
        5144bdf31fa689e166fe3a8e1a3befd2b28bbb1bd48207f4583c072207124a10

3. Verify that the container is running:

        $ docker ps
        CONTAINER ID        IMAGE                       COMMAND                CREATED             STATUS              PORTS                              NAMES
        5144bdf31fa6        kylemanna/bitcoind:latest   /bitcoin/bitcoind.sh   6 seconds ago       Up 5 seconds        0.0.0.0:8333->8333/tcp, 8332/tcp   bitcoind-node


Debugging
---------

    docker run --volumes-from=bitcoind-data --name=bitcoind-node -d -p 8333:8333 kylemanna/bitcoind -printtoconsole -disablewallet


Todo
----

- [ ] Add Ubuntu 14.04 quick start guide
- [ ] Add Ubuntu upstart init script
