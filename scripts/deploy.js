// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const token = await ethers.deployContract("UtilityCoin");

  console.log("Token address:", await token.address);
}



async function main2() {
  const [deployer] = await ethers.getSigners();

console.log("Deploying contracts with the account:", deployer.address)

const Token = await ethers.getContractFactory("DbstReserves");
const token = await Token.deploy(deployer.address);

console.log("Token address:", await token.address);
}

async function maina() {
  const [deployer] = await ethers.getSigners();

console.log("Deploying contracts with the account:", deployer.address)

const Token = await ethers.getContractFactory("UtilityCoin");
const token = await Token.deploy(deployer.address);

console.log("Token address:", await token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  // npx hardhat run scripts/deploy.js --network sepolia 