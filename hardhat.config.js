require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
//import "@nomiclabs/hardhat-waffle";

/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
  networks: {
    ethereum: {
      url: `https://goerli.infura.io/v3/17ebbdb5de1641518fc684ca50c4d66e`,
      accounts: [process.env.SIGNER_PRIVATE_KEY],
    }
  },
  solidity: {
    compilers: [
      { version: "0.8.10" },
      //{ version: "0.7.6" },
      //{ version: "0.6.6" }
    ]
  },
};
