geth --datadir ~/data/ --networkid 15 \
--rpc --rpccorsdomain "*" --rpcaddr "0.0.0.0" \
--rpcapi "db,admin,eth,net,web3,miner,personal" \
--nodiscover --identity "gleth"
