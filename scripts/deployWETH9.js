const hre = require("hardhat");

async function main() {
  console.log("deploying...");
  const WETH9 = await hre.ethers.getContractFactory("WETH9");
  const weth = await WETH9.deploy();

  await weth.deployed();

  console.log("Trade contract deployed: ", weth.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});