// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// here we fetch the real time price save it and send it to the governance smart cotract to repeg the collateral as per need
contract priceFeed {
    using SafeMath for uint256;
    AggregatorV3Interface private priceeFeed;
    uint256 public unstableColPrice;
    address public datafeed; // for updating the data feed of diffrent token //contract address to the aggregator

    constructor(address _datafeed) {
        datafeed = _datafeed;
        priceeFeed = AggregatorV3Interface(datafeed);
    }

    function setDataFeedAddress(address contractaddress) external {
        datafeed = contractaddress;
        priceeFeed = AggregatorV3Interface(datafeed);
    }

    function colPriceToWei() external {
        (, int256 price, , , ) = priceeFeed.latestRoundData(); // inside the AggregatorV3Interface will get latest round data and we need only 2nd one
        uint256 uintPrice = uint256(price); // converting int256 to uint256
        unstableColPrice = uintPrice.mul(1e10);
    }

    // this is the Eth price
    function rawPriceToWei() external view returns (uint256) {
        (, int256 price, , , ) = priceeFeed.latestRoundData(); // inside the AggregatorV3Interface will get latest round data and we need only 2nd one
        uint256 uintPrice = uint256(price);
        // unstableColPrice = uintPrice.mul(1e10); // this is state variable can not be called as view function
        return uintPrice;
    }
}
