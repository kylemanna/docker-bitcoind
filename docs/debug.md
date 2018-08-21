# Debugging

## Things to Check

- RAM utilization -- btcd is very hungry and typically needs in excess of 1GB. A swap file might be necessary.
- Disk utilization -- The bitcoin blockchain will continue growing and growing and growing. Then it will grow some more. At the time of writing, 40GB+ is necessary.

## Viewing btcd Logs

    docker logs btcd-node

## Running Bash in Docker Container

_Note:_ This container will be run in the same way as the btcd node, but will not connect to already running containers or processes.

    docker run -v btcd-data:/btcd --rm -it lnzap/btcd bash -l

You can also attach bash into running container to debug running btcd

    docker exec -it btcd-node bash -l
