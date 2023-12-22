// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Context.sol"; // to make available _msgSender()

contract UtilityCoin is Context, ERC20, ERC20Burnable, Ownable, AccessControl {
    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    mapping(address => uint256) private _balances; // when governance token minted we will see how many token minted
    uint256 private _totalSupply;
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE"); // enabling the manager role in deployer account

    // address private initialOwner;

    constructor() ERC20("DBST utilityToken", "DBSTU") {
        // _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        // _setupRole(MANAGER_ROLE, _msgSender());
        // initialOwner = msg.sender;
    }

    function mint(uint256 amount) external {
        // require(hasRole(MANAGER_ROLE, _msgSender()), "Not allowed");
        _totalSupply = _totalSupply.add(amount); // executing mint function will increase total supply
        _balances[msg.sender] = _balances[msg.sender].add(amount); // keep tracking/ auditing the balances
        _mint(msg.sender, amount);
    }

    function grantManagerRole(address account) external onlyOwner {
        grantRole(MANAGER_ROLE, account);
    }
}
