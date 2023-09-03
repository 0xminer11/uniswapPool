import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";

dotenv.config();
const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: '0.8.18',
        settings: {
          optimizer: {
            enabled: true,
            runs: 1,
          },
        },
      },
      {
        version: '0.5.16',
        settings: {
          optimizer: {
            enabled: true,
            runs: 1,
          },
        },
      }],
  },
  networks: {
    goerli: {
      url: process.env.GOERLI_RPC_URL,
      accounts:
        process.env.CONTRACT_DEPLOYER !== undefined
          ? [process.env.CONTRACT_DEPLOYER]
          : [],
    }
  },
  // etherscan: {
  //   apiKey: {
  //     goerli: process.env.GOERLI_TESTNET_API_KEY
  //   }
  // }
};

export default config;
