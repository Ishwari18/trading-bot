const hre = require("hardhat");
const fs = require("fs");
require("dotenv").config();
const { ethers } = require("hardhat");
let config, Trade;
let owner = "0xf922DABeb86327A585D5c4615A2CA6C39384f3F1";
//const network = hre.network.name;
require("./../config/ethereum.json");

const TradeContract = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
//console.log(`Loaded ${config.routes.length} routes`);

const main = async () => {
 
  const network = process.env.ETHEREUM_NETWORK;
  const provider = new ethers.providers.InfuraProvider(
    network,
    process.env.INFURA_API_KEY
  );
  const signer = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);

  await setup();
  await loadData();
  await lookForTrade();
};

const loadData = async () => {
  const tx2 = await Trade.addTokens(["0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9",
  "0xba100000625a3754423978a60c9317c58a424e3D",
  "0x0D8775F648430679A709E98d2b0Cb6250d2887EF",
  "0xD533a949740bb3306d119CC777fa900bA034cd52",
  "0x57Ab1ec28D129707052df4dF418D58a2D46d5f51",
  "0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F",
  "0x6B175474E89094C44Da98b954EedeAC495271d0F",
  "0x853d955aCEf822Db058eb8505911ED77F175b99e",
  "0x514910771AF9Ca656af840dff83E8264EcF986CA",
  "0x111111111117dC0aa78b770fA6A738034120C302",
  "0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2",
  "0x5f98805A4E8be255a32880FDeC7F6728C6568bA0",
  "0x956F47F50A910163D8BF957Cf5846D573E7f87CA",
  "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984",
  "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
  "0xdAC17F958D2ee523a2206206994597C13D831ec7",
  "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599",
  "0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e",
  "0x4Fabb145d64652a948d72533023f6E7A623C7C53"  
  ]);
  tx2.wait();
  console.log("All done loading routes in to smart contract");
};

let baseAssets = [
  { sym: "weth", address: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2" },
  { sym: "wBTC", address: "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599" },
  { sym: "USDT", address: "0xdAC17F958D2ee523a2206206994597C13D831ec7" },
  { sym: "USDC", address: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48" },
  { sym: "DAI", address: "0x6B175474E89094C44Da98b954EedeAC495271d0F" },
];

const lookForTrade = async () => {
  //const router1 = uniswap ruter address
  const baseAsset =
    config.baseAssets[Math.floor(Math.random() * config.baseAssets.length)]
      .address;
  const tradeSize = balances[baseAsset].balance;
  try {
    const returnArray = await Trade.instaSearch(router1, baseAsset, tradeSize);
    const amtBack = returnArray[0];
    const token1 = returnArray[1];
    const token2 = returnArray[2];
    const multiplier = ethers.BigNumber.from(
      config.minBasisPointsPerTrade + 10000
    );
    const sizeMultiplied = tradeSize.mul(multiplier);
    const divider = ethers.BigNumber.from(10000);
    const profitTarget = sizeMultiplied.div(divider);
    if (amtBack.gt(profitTarget)) {
      console.log("found profitable trade");
      await requestFlashLoan(baseAsset, tradeSize);
      await gettradedata(router1, baseAsset, token1, token2, tradeSize);
    } else {
      await lookForTrade();
    }
  } catch (e) {
    console.log(e);
    await lookForTrade();
  }
};
const requestFlashLoan = async (baseAsset, tradeSize) => {
  if (inTrade === true) {
    await lookForTrade();
    return false;
  }
  try {
    inTrade = true;
    console.log("> Making dualTrade...");
    const tx = await Flasharb.connect(owner).requestFlashLoan(
      baseAsset,
      tradeSize
    );
    console.log("requestign flashloan");
    await tx.wait();
    inTrade = false;
    await lookForTrade();
  } catch (e) {
    console.log(e);
    inTrade = false;
    await lookForTrade();
  }
};

const gettradedata = async () => {
  const tx1 = await Flashloan.connect(owner).gettradedata(
    router1,
    baseAsset,
    token1,
    token2,
    tradeSize
  );
  await tx1.wait();
};

const setup = async () => {
  [owner] = await ethers.getSigners();
  console.log(`Owner: ${owner.address}`);
  const Itrade = await ethers.getContractFactory("Trade");
  Trade = await Itrade.attach("0x5FbDB2315678afecb367f032d93F642f64180aa3"); // 0xf922DABeb86327A585D5c4615A2CA6C39384f3F1
  balances = {};
  for (let i = 0; i < baseAssets.length; i++) {
    const asset = baseAssets[i];
    const interface = await ethers.getContractFactory("WETH9");
    const assetToken = await interface.attach(asset.address);
    const balance = await assetToken.balanceOf(
      "0x5FbDB2315678afecb367f032d93F642f64180aa3"
    );
    console.log(asset.sym, balance.toString());
    balances[asset.address] = {
      sym: asset.sym,
      balance,
      startBalance: balance,
    };
  }
  setTimeout(() => {
    setInterval(() => {
      logResults();
    }, 600000);
    logResults();
  }, 120000);
};

const logResults = async () => {
  console.log(`############# LOGS #############`);
  for (let i = 0; i < config.baseAssets.length; i++) {
    const asset = config.baseAssets[i];
    const interface = await ethers.getContractFactory("WETH9");
    const assetToken = await interface.attach(asset.address);
    balances[asset.address].balance = await assetToken.balanceOf(
      "0x5FbDB2315678afecb367f032d93F642f64180aa3"
    );
    const diff = balances[asset.address].balance.sub(
      balances[asset.address].startBalance
    );
    const basisPoints = diff
      .mul(10000)
      .div(balances[asset.address].startBalance);
    console.log(`#  ${asset.sym}: ${basisPoints.toString()}bps`);
  }
};

process.on("uncaughtException", function (err) {
  console.log("UnCaught Exception 83: " + err);
  console.error(err.stack);
  fs.appendFile("./critical.txt", err.stack, function () {});
});

process.on("unhandledRejection", (reason, p) => {
  console.log("Unhandled Rejection at: " + p + " - reason: " + reason);
});

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
