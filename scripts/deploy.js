// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main0() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const token = await ethers.deployContract("pricEFeed");

  console.log("Token address:", token.address);
}



async function mainaa() {
  const [deployer] = await ethers.getSigners();

console.log("Deploying contracts with the account:", deployer.address)

const Token = await ethers.getContractFactory("");
const token = await Token.deploy(deployer.address);

console.log("Token address:", await token.address);
}

async function mainaa() {
  const [deployer] = await ethers.getSigners();

console.log("Deploying contracts with the account:", deployer.address)

const Token = await ethers.getContractFactory("utilityGovernance");
const token = await Token.deploy(deployer.address);

console.log("Token address:", token.address);
}

async function maina() {
  const [deployer] = await ethers.getSigners();

console.log("Deploying contracts with the account:", deployer.address)
const stableDBSTAddress = "0x5FC8d32690cc91D4c39d9d3abcBD16989F875707";
const utilityCoinAddress = "0x0165878A594ca255338adfa4d48449f69242Eb8F";

const Token = await ethers.getContractFactory("utilityGovernance");
const token = await Token.deploy(stableDBSTAddress, utilityCoinAddress);


console.log("Token address:", await token.address);
}

async function main1() {
const [deployer] = await ethers.getSigners();
console.log("Deploying contracts with the account:", deployer.address)
const WalletAddress = "0x88070c79BaCC2785088A2C346242cb8512796aD9";
const Token = await ethers.getContractFactory("DbstCoin");
const token = await Token.deploy(WalletAddress);
console.log("Token address:", token.address);
}

async function main2() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address)
  // const dbstCoinAddress = "0x865dc786e7974Ec4433499dB6422C5DB4e94bd79";
  const Token = await ethers.getContractFactory("DbstReserves");
  const token = await Token.deploy();
  console.log("Token address:", token.address);
  }

  async function main3() {
    const [deployer] = await ethers.getSigners();
    const priceFeedAddress = "0x0715A7794a1dc8e42615F059dD6e406A6594651A"
    console.log("Deploying contracts with the account:", deployer.address);
    const Token = await ethers.getContractFactory("priceFeed");
    const token = await Token.deploy(priceFeedAddress);
    console.log("Token address:", token.address);
  }  
async function main4() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address)
  const Token = await ethers.getContractFactory("stableDBST");
  const token = await Token.deploy();
  console.log("Token address:", token.address);
  }
  async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address)
    const stableCoinAddress = "0xEAD2b4559d3F0AAeDdAfBCA9B69e531BD26FDFC4";
    const Token = await ethers.getContractFactory("SDBSTGovernance");
    const token = await Token.deploy(stableCoinAddress);
    console.log("Token address:",token.address);
    }
    async function main6() {
      const [deployer] = await ethers.getSigners();
      console.log("Deploying contracts with the account:", deployer.address)
      const Token = await ethers.getContractFactory("UtilityCoin");
      const token = await Token.deploy();
      console.log("Token address:", token.address);
      }
      async function main7() {
        const [deployer] = await ethers.getSigners();
        console.log("Deploying contracts with the account:", deployer.address)
        const Token = await ethers.getContractFactory("SDBSTReservess"); // utility reserves
        const token = await Token.deploy();
        console.log("Token address:", token.address);
        }

        async function main8() {
        const [deployer] = await ethers.getSigners();  
        console.log("Deploying contracts with the account:", deployer.address)
        const stableDBSTAddress = "0xCaE803835a449b462f5D0E0c6ee47C6152C6a063";
        const utilityCoinAddress = "0xD3AAb3cf7f0a74521a6fA76635593e2f796b1489";
        const Token = await ethers.getContractFactory("utilityGovernance");
        const token = await Token.deploy(stableDBSTAddress, utilityCoinAddress);
        console.log("Token address:", token.address);
        }

        async function main9() {
          const [deployer] = await ethers.getSigners();
          console.log("Deploying contracts with the account:", deployer.address);
          const token = await ethers.deployContract("Wbeth"); 
          console.log("Token address:", token.address);
        } 
        

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  // npx hardhat run scripts/deploy.js --network sepolia 
  // npx hardhat run scripts/deploy.js --network mumbai

  // npx hardhat run --network localhost scripts/deploy.js