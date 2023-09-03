import { ethers } from "hardhat";
import dotenv from "dotenv";

dotenv.config();
async function main() {

  console.log("Deployment Process Bigin 🔴🔴🔴");
  console.log("----------------------------------------------------------------------------");
  console.log("Deploying Alpha Token Contract 🔴🔴🔴");
  const alpha = await ethers.getContractFactory("Alpha");
  const tokenAlpha = await alpha.deploy();
  console.log("Deployed Successfully Alpha Token Contract at", tokenAlpha.address," ✅✅✅");

  console.log("Deploying Beta Token Contract 🔴🔴🔴");
  const beta = await ethers.getContractFactory("Beta");
  const tokenBeta = await beta.deploy();
  console.log("Deployed Successfully Beta Token Contract at", tokenBeta.address," ✅✅✅");

  console.log("Deploying Pool Contract 🔴🔴🔴");
  const Pool = await ethers.getContractFactory("Beta");
  const PoolContract = await Pool.deploy();
  console.log("Deployed Successfully Beta Token Contract at", tokenBeta.address," ✅✅✅");
  console.log("----------------------------------------------------------------------------");
  console.log("Deployment Process Complete ✅✅✅");

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
