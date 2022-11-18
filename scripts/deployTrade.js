const hre = require("hardhat");

async function main() {
  console.log("deploying...");
  const Trade = await hre.ethers.getContractFactory("Trade");
  const trade = await Trade.deploy();

  await trade.deployed();

  console.log("Trade contract deployed: ", trade.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


