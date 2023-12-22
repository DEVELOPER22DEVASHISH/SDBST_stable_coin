// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract DbstReserves is Context, Ownable, ReentrancyGuard, AccessControl {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    uint256 public currentReserveId; // after allocating the coin vault will be incremented

    struct ReserveVault {
        IERC20 collateral;
        uint256 amount;
    }

    mapping(uint256 => ReserveVault) public _rsvVault;

    event Withdraw(uint256 indexed vid, uint256 amount);
    event Deposit(uint256 indexed vid, uint256 amount);

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE"); // allow to call the function// access control

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MANAGER_ROLE, _msgSender());
    }

    // Ownable(initialOwner) // to assign the deployer //it do not have constructor as per tutorial

    function checkReserveContract(IERC20 _collateral) internal view {
        // adding one token only one time // we do not want to have duplicated token
        for (uint256 i; i < currentReserveId; i++) {
            // for soldity i = 0 by default
            require(
                _rsvVault[i].collateral != _collateral,
                "Collateral address already added"
            );
        }
    }

    function addReserveVault(IERC20 _collateral) external {
        require(hasRole(MANAGER_ROLE, _msgSender()), "Not allowed");
        checkReserveContract(_collateral); // checking current wallet address by passing address of the collateral
        _rsvVault[currentReserveId].collateral = _collateral; // building counter by currentReserveId after incrementing the currect reserveID
        currentReserveId++;
    }

    function depositCollateral(uint256 vid, uint256 amount) external {
        // as we do not know which id gonna be add(dbst or wbeth)
        require(hasRole(MANAGER_ROLE, _msgSender()), "Not allowed");
        IERC20 reserves = _rsvVault[vid].collateral; // first you need to have reserves then transfer
        reserves.safeTransferFrom(address(msg.sender), address(this), amount); // this for current contract address where you wanna add/ deposit token // msg.sender is wallet addr // to do that this must be approved first
        uint256 currentVaultBalance = _rsvVault[vid].amount; //  updating the vault amount that is already available then adding the new amount
        _rsvVault[vid].amount = currentVaultBalance.add(amount); // adding the new amount
        emit Deposit(vid, amount);
    }

    function withdrawCollateral(uint256 vid, uint256 amount) external {
        require(hasRole(MANAGER_ROLE, _msgSender()), "Not allowed");
        IERC20 reserves = _rsvVault[vid].collateral;

        uint256 currentVaultBalance = _rsvVault[vid].amount;
        if (currentVaultBalance >= amount) {
            // amount that is asked to withdraw
            reserves.safeTransfer(address(msg.sender), amount);
            _rsvVault[vid].amount = currentVaultBalance.sub(amount); // if we have the amount available then this is gonna be execute
        }

        emit Withdraw(vid, amount);
    }
}
