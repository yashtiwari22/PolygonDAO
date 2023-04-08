import "hardhat-deploy";
import "@nomiclabs/hardhat-ethers";
import "@typechain/hardhat";
import "dotenv/config";
import { HardhatUserConfig } from "hardhat/config";

const RPC_URL=process.env.RPC_URL;
const PRIVATE_KEY=process.env.PRIVATE_KEY|| "privatKey";

const config:HardhatUserConfig={
  defaultNetwork:"hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
    },
    localhost:{
      chainId:31337,
    },
    polygon_mumbai:{
      url:RPC_URL,
      accounts:[PRIVATE_KEY,]
    }
  },
  solidity:"0.8.8",
  typechain: {
    outDir: "typechain",
    target: "ethers-v5",
  },
  namedAccounts:{
    deployer:{
      default:0,
    }
  }
}
export default config;