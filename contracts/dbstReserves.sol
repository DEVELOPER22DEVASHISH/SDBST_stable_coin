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

    uint256 public currentReserveId;

    struct ReserveVault {
        IERC20 collateral;
        uint256 amount;
    }

    mapping(uint256 => ReserveVault) public _rsvVault;

    event Withdraw(uint256 indexed vid, uint256 amount);
    event Deposit(uint256 indexed vid, uint256 amount);

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    constructor(address initialOwner) {} // Ownable(initialOwner)

    function checkReserveContract(IERC20 _collateral) internal view {
        for (uint256 i; i < currentReserveId; i++) {
            require(
                _rsvVault[i].collateral != _collateral,
                "Collateral address already added"
            );
        }
    }

    function addReserveVault(IERC20 _collateral) external {
        require(hasRole(MANAGER_ROLE, _msgSender()), "Not allowed");
        checkReserveContract(_collateral);
        _rsvVault[currentReserveId].collateral = _collateral;
        currentReserveId++;
    }

    function depositCollateral(uint256 vid, uint256 amount) external {
        // as we do not know which id gonna be add(dbst or wbeth)
        require(hasRole(MANAGER_ROLE, _msgSender()), "Not allowed");
        IERC20 reserves = _rsvVault[vid].collateral; // first you need to have reserves then transfer
        reserves.safeTransferFrom(address(msg.sender), address(this), amount); // current contract address where you wanna add/ deposit token
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
