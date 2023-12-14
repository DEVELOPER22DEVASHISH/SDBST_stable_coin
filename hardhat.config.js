require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
require('dotenv').config();

// /** @type import('hardhat/config').HardhatUserConfig */
// module.exports = {
//   solidity: "0.8.7",
// };



// const ALCHEMY_API_KEY = "PQhFPEXdELfVzj01gcq6Sw65gHm5JfcE";

// Replace this private key with your Sepolia account private key
// To export your private key from Coinbase Wallet, go to
// Settings > Developer Settings > Show private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts
// const SEPOLIA_PRIVATE_KEY = "YOUR SEPOLIA PRIVATE KEY";

// module.exports = {
//   solidity: "0.8.19",
//   networks: {
//     sepolia: {
//       url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
//       accounts: [SEPOLIA_PRIVATE_KEY]
//     }
//   }
// };

const { API_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: "0.8.7",
  defaultNetwork: "sepolia",
  networks: {
    hardhat: {},
    sepolia: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  },
}




//  npx hardhat run --network localhost scripts/deploy.js    