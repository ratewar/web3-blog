require("@nomiclabs/hardhat-waffle");
const fs= require("fs");
const privateKey = fs.readFileSync(".secret").toString();


/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  networks:{
    hardhat:{
      chainId: 1337
    },
    mumbai:{
      url:"https://speedy-nodes-nyc.moralis.io/046ba9d682978e71c93944e2/polygon/mumbai",
      accounts:[privateKey]
    },
    mainnet:{
      url:"https://speedy-nodes-nyc.moralis.io/046ba9d682978e71c93944e2/polygon/mainnet",
      accounts:[privateKey]
    }
  },
  solidity: "0.8.4",
};
