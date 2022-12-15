const hre = require("hardhat");

async function main() {
  console.log("deploying...");
  const Flasharb = await hre.ethers.getContractFactory(
    "Flasharb"
  );
  const flasharb = await Flashloan.deploy( "0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D");

  await flasharb.deployed();

  console.log("Flash loan contract deployed: ", flasharb.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});