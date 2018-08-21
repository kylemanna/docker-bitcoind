# btcd config tuning

You can use environment variables to customize config ([see docker run environment options](https://docs.docker.com/engine/reference/run/#/env-environment-variables)):

        docker run -v btcd-data:/btcd --name=btcd-node -d \
            -p 8333:8333 \
            -p 127.0.0.1:8334:8334 \
            -e RPCUSER=mysecretrpcuser \
            -e RPCPASS=mysecretrpcpass \
            lnzap/btcd

Or you can use your very own config file like that:

        docker run -v btcd-data:/btcd --name=btcd-node -d \
            -p 8333:8333 \
            -p 127.0.0.1:8334:8334 \
            -v /etc/mybtcd.conf:/btcd/.btcd/btcd.conf \
            lnzap/btcd
