# Debugging

## Viewing bitcoind Logs

    docker logs bitcoind-node


## Running Bash in Docker Container

*Note:* This container will be run in the same way as the bitcoind node, but will not connect to already running containers or processes.

    docker run --volumes-from=bitcoind-data --rm -it kylemanna/bitcoind bash -l
