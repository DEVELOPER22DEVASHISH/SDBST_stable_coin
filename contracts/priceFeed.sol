// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract pricEFeed {
    using SafeMath for uint256;
    AggregatorV3Interface private priceFeed;
    uint256 public unstableColPrice;
    address public datafeed; // for updating the data feed of diffrent token //contract address to the aggregator

    function setDataFeedAddress(address contractaddress) external {
        datafeed = contractaddress;
        priceFeed = AggregatorV3Interface(datafeed);
    }

    function colPriceToWei() external {
        (, int256 price, , , ) = priceFeed.latestRoundData(); // inside the AggregatorV3Interface will get latest round data and we need only 2nd one
        uint256 uintPrice = uint256(price); // converting int256 to uint256
        unstableColPrice = uintPrice.mul(1e10);
    }

    function rawPriceToWei() external returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData(); // inside the AggregatorV3Interface will get latest round data and we need only 2nd one
        uint256 uintPrice = uint256(price);
        unstableColPrice = uintPrice.mul(1e10); // this is state variable can not be called as view function
        return uintPrice;
    }
}
