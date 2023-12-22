// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Wbeth is ERC20, ERC20Burnable, Ownable {
    using SafeERC20 for ERC20;

    constructor() ERC20("Wrapped ETH", "WBETH") {}

    function mint(uint256 amount) public onlyOwner {
        _mint(msg.sender, amount);
    }
}
