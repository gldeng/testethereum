
## Run private network
1. Start the docker

    ```bash
    bash run.sh
    ```

1. In the docker initialize the blockchain

    ```bash
    cd /root
    bash init-private-network.sh
    ```

1. In the docker start the node
    ```bash
    bash start-private-network.sh
    ```

1. In the docker run geth console to manage and interact with the node
    ```bash
    geth attach /root/data/geth.ipc
    ```
1. In geth console create an account
    ```javascript
    > personal.newAccount()
    Passphrase: 
    Repeat passphrase: 
    "0x4f0e9799078ace7997684489dda2169af6ad59e8"
    ```

1. In geth console, start mining
    ```javascript
    > miner.setEtherbase("0x4f0e9799078ace7997684489dda2169af6ad59e8")
    true
    > miner.start(1)
    ```

1. In geth console, check balance
    ```javascript
    > eth.getBalance('0x4f0e9799078ace7997684489dda2169af6ad59e8')
    175000000000000000000
    ```

## Deploy dapp
### Prepare

```bash
$ node -v
v8.9.0
$ npm -v
5.5.1
```

### Steps

1. Install solc and web3
    ```bash
    cd app
    npm install solc
    npm install web3@0.20.1
    ```
1. Use web to interact with the blockchain
    ```bash
    $ node
    > Web3 = require('web3')
    > web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"))
    > web3.eth.accounts
    [ '0x4f0e9799078ace7997684489dda2169af6ad59e8' ]
    ```
1. Compile contract
    ```bash
    > code = fs.readFileSync('Voting.sol').toString()
    > solc = require('solc')
    > compiledCode = solc.compile(code)
    ```
1. Unlock Account
    ```bash
    > web3.personal.unlockAccount("0x4f0e9799078ace7997684489dda2169af6ad59e8", "<passcode>")
    ```
1. Deploy contract
    ```bash
    > abiDefinition = JSON.parse(compiledCode.contracts[':Voting'].interface)
    > VotingContract = web3.eth.contract(abiDefinition)
    > byteCode = '0x' + compiledCode.contracts[':Voting'].bytecode
    > deployedContract = VotingContract.new(['Rama','Nick','Jose'],{data: byteCode, from: web3.eth.accounts[0], gas: 4700000})
    > deployedContract.address
    '0x2cc0f4efd562c2499a4bfad409b7e4b8f8029570'
    > contractInstance = VotingContract.at(deployedContract.address)
    ```

1. Invoking contract
    ```bash
    > contractInstance.totalVotesFor.call('Rama')
    BigNumber { s: 1, e: 0, c: [ 0 ] }
    > contractInstance.voteForCandidate('Rama', {from: web3.eth.accounts[0]})
    '0x5f1307047259a5b0a12db0fb3cee6e29db72d178457a7ce4a2c91d9f51cbfac8'
    > contractInstance.voteForCandidate('Rama', {from: web3.eth.accounts[0]})
    '0x3faa957cc86b955caff010474778228e2ff0bcae620d7040dc856068e4590470'
    > contractInstance.voteForCandidate('Rama', {from: web3.eth.accounts[0]})
    '0x35b6df4cb4d7d20772518d8c70fdb2218a907b0144463a616b0849374ec0487e'
    > contractInstance.totalVotesFor.call('Rama').toString()
    '3'
    ```

1. Modify address in [index.js](app/index.js) to use the newly deployed contract address
    ```javascript
    contractInstance = VotingContract.at('0x2cc0f4efd562c2499a4bfad409b7e4b8f8029570');
    ```



