# Debugging

## Things to Check

* RAM utilization -- bitcoind is very hungry and typically needs in excess of 1GB.  A swap file might be necessary.
* Disk utilization -- The bitcoin blockchain will continue growing and growing and growing.  Then it will grow some more.  At the time of writing, 40GB+ is necessary.

## Viewing bitcoind Logs

    docker logs bitcoind-node


## Running Bash in Docker Container

*Note:* This container will be run in the same way as the bitcoind node, but will not connect to already running containers or processes.

    docker run -v bitcoind-data:/bitcoin --rm -it kylemanna/bitcoind bash -l

You can also attach bash into running container to debug running bitcoind

    docker exec -it bitcoind-node bash -l


