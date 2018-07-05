docker rm ethereum-node
docker run --name ethereum-node -v $PWD/root:/root \
           -p 8545:8545 -p 30303:30303 -it kunstmaan/ethereum-geth \
           /bin/bash
