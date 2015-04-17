Bitcoind and insight for Docker
===================

Docker image that runs a bitcoind node and insight in containers for easy deployment.


Requirements
------------

* Physical machine, cloud instance, or VPS that supports Docker (i.e. [Vultr](http://bit.ly/1HngXg0), [Digital Ocean](http://bit.ly/18AykdD), KVM or XEN based VMs) running Ubuntu 14.04 or later (*not OpenVZ containers!*)
* At least 40 GB to store the block chain files
* At least 1 GB RAM + 2 GB swap file

Recommended and tested on [Vultr 1024 MB RAM/320 GB disk instance @ $8/mo](http://bit.ly/vultrbitcoind).  Vultr also *accepts Bitcoin payments*!  May run on the 512 MB instance, but took *forever* (1+ week) to initialize due to swap and disk thrashing.


Really Fast Quick Start
-----------------------

One liner for Ubuntu 14.04 LTS machines with JSON-RPC enabled on localhost and adds upstart init script:

    curl https://raw.githubusercontent.com/kobigurk/docker-bitcoind/master/bootstrap-host.sh | sh -s trusty


Quick Start
-----------

1. Create `bitcoind-data` and `insight-data` volumes to persist the bitcoind blockchain data and insight data, should exit immediately.  The containers will store the blockchain and insight data when the node container is recreated (software upgrade, reboot, etc):

        docker run --name=bitcoind-data -v /bitcoin busybox chown 1000:1000 /bitcoin
        docker run --name=insight-data -v /insight busybox chown 1000:1000 /insight
        docker-compose up

        or run manually:
        docker run --volumes-from=bitcoind-data --name=bitcoind-node -d \
            -p 8333:8333 \
            -p 127.0.0.1:8332:8332 \
            -p 6881:6881 \
            -p 6882:6882 \
			-p 3000:3000
            kobigurk/bitcoind
        docker run --volumes-from=bitcoind-data --volumes-from=insight-data --name=insight-node -d \
			-p 3000:3000
            kobigurk/bitcoind


2. Verify that the container is running and waiting for bitcoind node to
   catch up with network

        $ docker ps
        CONTAINER ID        IMAGE                         COMMAND             CREATED             STATUS              PORTS                                                                                              NAMES
        d0e1076b2dca        kobigurk/bitcoind:latest     "btc_oneshot"       2 seconds ago       Up 1 seconds        0.0.0.0:6881->6881/tcp, 0.0.0.0:6882->6882/tcp, 127.0.0.1:8332->8332/tcp, 0.0.0.0:8333->8333/tcp   bitcoind-node
        d0e1076b2dcb        kobigurk/insight:latest     "./start.sh"       2 seconds ago       Up 1 seconds        0.0.0.0:3000->3000/tcp   bitcoind-node

3. You can then access the daemon's output thanks to the [docker logs command]( https://docs.docker.com/reference/commandline/cli/#logs)

        docker logs -f bitcoind-node
        docker logs -f insight-node
        or
        docker-compose logs

4. Install optional init script for upstart provided @ `upstart.init`.

5. To access insight frontend, go to http://localhost:3000.


Documentation
-------------

* Additional documentation in the [docs folder](docs).
