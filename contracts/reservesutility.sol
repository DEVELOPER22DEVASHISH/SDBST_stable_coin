// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract SDBSTReservess is Ownable, ReentrancyGuard, AccessControl {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    uint256 public currentReserveCount;

    struct ReserveVault {
        IERC20 collateral;
        uint256 amount;
    }

    mapping(uint256 => ReserveVault) public rsvVault;

    event Deposit(uint256 indexed pid, uint256 amount);
    event Withdraw(uint256 indexed pid, uint256 amount);

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MANAGER_ROLE, _msgSender());
    }

    function checkReserveDuplicate(IERC20 _colToken) internal view {
        for (uint256 _pid = 0; _pid < currentReserveCount; _pid++) {
            require(
                rsvVault[_pid].collateral != _colToken,
                "Collateral Contract Already Added"
            );
        }
    }

    function addReserve(IERC20 _colToken) external {
        require(hasRole(MANAGER_ROLE, _msgSender()), "Not allowed");
        checkReserveDuplicate(_colToken);
        rsvVault[currentReserveCount].collateral = _colToken;
        currentReserveCount++;
    }

    // function reserveLength() view external returns(uint256) {
    //    return currentReserveCount ;
    // }

    function deposit(uint256 _pid, uint256 _amount) external {
        require(hasRole(MANAGER_ROLE, _msgSender()), "Not allowed");
        IERC20 reserve = rsvVault[_pid].collateral;
        reserve.safeTransferFrom(address(msg.sender), address(this), _amount);
        uint256 currentAmount = rsvVault[_pid].amount;
        rsvVault[_pid].amount = currentAmount.add(_amount);
        emit Deposit(_pid, _amount);
    }

    function withdraw(uint256 _pid, uint256 _amount) external {
        require(hasRole(MANAGER_ROLE, _msgSender()), "Not allowed");
        IERC20 reserve = rsvVault[_pid].collateral;
        uint256 currentAmount = rsvVault[_pid].amount;
        if (currentAmount >= _amount) {
            reserve.safeTransfer(address(msg.sender), _amount);
        }
        rsvVault[_pid].amount = currentAmount.sub(_amount);
        emit Withdraw(_pid, _amount);
    }
}

// when the collateral value is less than the total supply then we do not want to touch the sdbst token to stablise the token
// here we will burn the utility token to balnce the stable coin
