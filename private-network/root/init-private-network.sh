# remove all data in geth
rm -rf ~/data/geth

geth --datadir ~/data/ init genesis.json
