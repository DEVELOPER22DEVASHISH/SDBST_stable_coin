const {ethers} = require("ethers")
const priceFeedABI = require('./priceFeedabi.json')
// const reserveABI = require('./utreservesabi.json')
const dbstreserveABI = require('./reservesabi.json')
// const udbstabi = require('./udbstabi.json')
const udbstabi = require('./dbstabi.json')

const oracleETH = '0x0715A7794a1dc8e42615F059dD6e406A6594651A'; // from chain link data eth/usd // mumbai testnet
// const reservecontract = "0x8E458467A2256a5968270799A92f666B76064dC7"; // utility reserves
const dbstreservecontract = "0x5DaC81F809849045fEe833A77fB3DC0FB45658CF"; //  dbstreserves
// const udbstcontract = "0xD3AAb3cf7f0a74521a6fA76635593e2f796b1489";
const dbstcontract = "0x865dc786e7974Ec4433499dB6422C5DB4e94bd79";

const ethrpc = 'https://rpc.ankr.com/eth';
const sepoliaRPC= "https://polygon-mumbai.g.alchemy.com/v2/OCWUHrkQ5IQfC4FXou4wOjeAtJGOJXKR";

const ethprovider = new ethers.providers.JsonRpcProvider(ethrpc);
const sepoliaprovider = new ethers.providers.JsonRpcProvider(sepoliaRPC);

const key = 'a300896d74e614eacbe69c0a4b46e36f494f6919df0063c09b88959774f7b856' // here we will paste private key
const walleteth = new ethers.Wallet(key, ethprovider);
const walletsepolia = new ethers.Wallet(key, sepoliaprovider);

// invoking contract interfaces to allow to talk with the smart contract
 const ethoracle = new ethers.Contract(oracleETH, priceFeedABI, walleteth)
//  const reserves = new ethers.Contract(reservecontract, reserveABI, walletsepolia) // in  this sepolia testnet will work here
 const reserves = new ethers.Contract(dbstreservecontract, dbstreserveABI, walletsepolia) // in  this sepolia testnet will work here
//  const usdbst = new ethers.Contract(udbstcontract, udbstabi, walletsepolia) // in  this sepolia testnet will work here
 const sdbst = new ethers.Contract(dbstcontract, udbstabi, walletsepolia) // in  this sepolia testnet will work here

//  async function getEthPrice() {
//      let ethPrice = await ethoracle.latestRoundData().catch((error) => {console.log(error)}) // latestRoundData()
//     console.log((ethPrice).toString); // by doing to string we get eth price
//     let Latesteth = Number((ethPrice.answer).toString())/1e8;

//     return Latesteth;

//  }

 
 async function getEthPrice() {
   let ethPrice = await ethoracle // latestRoundData()
  console.log((ethPrice)); // by doing to string we get eth price
  let Latesteth = Number((ethPrice.answer))/1e8;

  return Latesteth;

}

//  async function getSDBSTPrice() {
//     let latesteth = await getEthPrice().catch((error) => {console.log(error)});
//     let dbstcolraw = await reserves.rsvVault(0).catch((error) => {console.log(error)})
//     let ethcolraw = await reserves.rsvVault(1).catch((error) => {console.log(error)})
//     let sdbstSupRaw = sdbst.totalSupply.catch((error) => {console.log(error)})
//     let dbstcollateral = Number((dbstcolraw.amount).toString())/1e18;
//     let ethcollateral = Number((ethcolraw.amount).toString())/1e18;
//     let sdbstSupply = Number((sdbstSupRaw.amount).toString())/1e18;
//     let sdbstprice = (dbstcollateral*1) + (ethcollateral*latesteth)/sdbstSupply // to calculate 1 stable price we need to divide by total supply 
//    //  console.log(sdbstprice)
//    //  console.log(dbstcollateral)
//    //  console.log(ethcollateral)
//    //  console.log(sdbstSupply);
//     return sdbstprice;
//  }

 async function getSDBSTPrice() {
   let latesteth = await getEthPrice();
  //  let dbstcolraw = await reserves.rsvVault(0)
   let dbstcolraw = await reserves._rsvVault(0)
  //  let ethcolraw = await reserves.rsvVault(1)
   let ethcolraw = await reserves._rsvVault(1)
   let sdbstSupRaw = sdbst.totalSupply
   let dbstcollateral = Number((dbstcolraw.amount))/1e18;
   let ethcollateral = Number((ethcolraw.amount))/1e18;
   let sdbstSupply = Number((sdbstSupRaw.amount))/1e18;
   let sdbstprice = (dbstcollateral*1) + (ethcollateral*latesteth)/sdbstSupply // to calculate 1 stable price we need to divide by total supply 
  //  console.log(sdbstprice)
  //  console.log(dbstcollateral)
  //  console.log(ethcollateral)
  //  console.log(sdbstSupply);
   return sdbstprice;
}


 getSDBSTPrice();
  getEthPrice();

module.exports = { getEthPrice, getSDBSTPrice} // to connct with database we export the function from here 
 


