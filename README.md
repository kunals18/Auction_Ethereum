# Auction Application based on Ethereum Smart Contract

An auction application dapp where you can create auction for items and other people can bid for it.

## Requirement

* Node
* npm
* truffle
* ganache‐cli
* metamask

## Setup

```bash
git clone https://github.com/kunals18/Auction_Ethereum.git
cd Auction_Ethereum
npm install
truffle compile
```

### To run on local network:

```bash
testrpc
truffle migrate --network ropsten
```
Update contract address in file auctionBoxInstance.js in contracts directory

```bash
testrpc
truffle migrate --network ropsten
npm run dev
```
To add test ether to metamask account

```bash
curl -d '{"jsonrpc":"2.0","method":"eth_sendTransaction","params": [{"from":<from_address>, "to":<to_address>, "value": 1e18}], "id":1}' -X POST http://127.0.0.1:8545/

```

### To run on Ropsten Test Network:
Deploy AuctionBox Contract through remix
Update contract address in file auctionBoxInstance.js in contracts directory

```bash
npm run dev
```

### Developers:

1. Ankit Kumar (160119)
2. Krishan Singhal (160339)
3. Kunal Suryawanshi (160353)
4. Priyanshu Singh (160521)
5. Yogendra Singh (160829)
