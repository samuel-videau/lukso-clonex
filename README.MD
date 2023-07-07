# LuksoCloneX Solidity Project

This repository contains a Solidity project, LuksoCloneX, a digital asset based on the LSP8 Identifiable Digital Asset standard and implements reentrancy security measures.

## Prerequisites

- [NodeJS](https://nodejs.org/en/)
- [NPM](https://www.npmjs.com/get-npm)
- A suitable Ethereum wallet and private key

## Dependencies

This project uses:

- [@lukso/lsp-smart-contracts](https://www.npmjs.com/package/@lukso/lsp-smart-contracts)
- [@nomiclabs/hardhat-ethers](https://www.npmjs.com/package/@nomiclabs/hardhat-ethers)
- [@nomiclabs/hardhat-etherscan](https://www.npmjs.com/package/@nomiclabs/hardhat-etherscan)
- [@openzeppelin/contracts](https://www.npmjs.com/package/@openzeppelin/contracts)
- [dotenv](https://www.npmjs.com/package/dotenv)
- [hardhat](https://www.npmjs.com/package/hardhat)

## Installation

1. Clone this repository.

2. Install the dependencies by running `npm install`.

3. Create a `.env` file at the root of your project and insert your Ethereum private key as `PRIVATEKEY=<your-private-key>`.

## Deployment

The deployment script is located in `scripts/deploy.js`.

Replace `'YOUR OWNER ADDRESS'` in `const owner = 'YOUR OWNER ADDRESS';` with the Ethereum address that will own the contract.

Run the deployment script by executing `npx hardhat run scripts/deploy.js`.

## Configuration

The Hardhat configuration is located in `hardhat.config.js`.

It currently includes three networks:

1. `hardhat`: for local development and testing.
2. `testnet`: for deployment on the LUKSO test network.
3. `mainnet`: for deployment on the LUKSO main network.

Ensure the `PRIVATEKEY` environment variable is correctly set for the respective network before deploying.

## About LuksoCloneX

The contract features:

- A public and private mint function with specific prices and supply limits.
- Whitelisting of addresses for the private mint function.
- A predefined merkle root for verification of the minting address.
- Specific token ID type and base URI for LSP8 metadata.
- Assignment of the creator for LSP4 digital asset metadata.

For more information on LSP8 and LSP4 standards, please refer to [LUKSO standards](https://github.com/lukso-network/LIPs).

## Disclaimer

This contract is not audited. Use at your own risk. Always make sure to test on a testnet before deploying to a mainnet.