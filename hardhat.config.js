require("@nomiclabs/hardhat-waffle");
//require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
  // networks: {
  //   ethereum: {
  //     url: ``,
  //     accounts: [process.env.privateKey],
  //   }
  // },
  solidity: {
    compilers: [
      { version: "0.8.10" },
      //{ version: "0.7.6" },
      //{ version: "0.6.6" }
    ]
  },
};
