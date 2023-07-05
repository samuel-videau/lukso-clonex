require('@nomiclabs/hardhat-etherscan');
require('@nomiclabs/hardhat-ethers');

const dotenv = require("dotenv")
dotenv.config()

module.exports = {
  solidity: "0.8.18",
  settings: {
    optimizer: {
      enabled: true,
      runs: 500
    }
  },
  etherscan: {
    apiKey: 'no-api-key-needed',
    customChains: [
      {
        network: 'testnet',
        chainId: 4201,
        urls: {
          apiURL: 'https://explorer.execution.testnet.lukso.network/api',
          browserURL: 'https://explorer.execution.testnet.lukso.network/',
        },
      },
    ],
  },
  networks: {
    hardhat: {
      chainId: 31337,
      loggingEnabled: true,
      accounts: [{
        privateKey: process.env.PRIVATEKEY || '',
        balance: "100000000000000000000" //100ETH
      }]
    },
    testnet: {
      url: "https://rpc.testnet.lukso.network",
      accounts: [process.env.PRIVATEKEY || '']
    },
    mainnet: {
      url: "https://rpc.mainnet.lukso.network",
      accounts: [process.env.PRIVATEKEY || '']
    },
  },
};
