// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./stableCoin.sol"; // to intract with the stable coin for burning and minting
import "./utilityCoin.sol"; // to intract with the stable coin for burning and minting

contract utilityGovernance is Ownable, ReentrancyGuard, AccessControl {
    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    struct SupChange {
        // supply change to balance the coin
        string method; // method to balance the peg
        uint256 amount; // amount required for the balacing the coin
        uint256 timestamp;
        uint256 blocknum; // blocknumber to balancing the token peg
    }

    // mapping (uint256 => SupChange) public _supplychange;

    struct reserveList {
        // to store the collateral smart contract address/ id // to know how much collateral available
        IERC20 colToken; //
    }

    mapping(uint256 => reserveList) public rsvList; // to check the collateral for token 1 , 2 so on

    stableDBST private sdbst; // this will allow to call mint and burn function from stable coin
    UtilityCoin private udbst; // this will allow to call mint and burn function from stable coin
    address private reserveContract; // later
    uint256 public dbstSupply; // this is for after the repeg how much supply we have available
    uint256 public ubstSupply; // this is for after the repeg how much supply we have available
    address public datafeed; // this is the address of datafeed of unstable collateral
    uint256 public supplyChangeCount; // this is for real time supplychange for rebalancing the coin
    // how many times we rebalance the coin
    uint256 public stableColPrice = 1e18; // 1 eth

    uint256 public stableColAmount;
    uint256 private constant COL_PRICE_TO_WEI = 1e10;
    uint256 private constant WEI_VALUE = 1e18; // CONVERING ANY VAUE TO WEI
    uint256 public unstableColAmount; // holding how much unstable collateral amount holding in reserves
    uint256 public unstableColPrice;
    uint256 public reserveCount; // number of total reserves count

    mapping(uint256 => SupChange) public _supplyChange; // public declaration for supply change

    // for access control
    bytes32 public constant GOVERN_ROLE = keccak256("GOVERN_ROLE");

    event RepegAction(uint256 time, uint256 amount);
    event Withdraw(uint256 time, uint256 amount);

    constructor(stableDBST _sdbst, UtilityCoin _udbst) {
        sdbst = _sdbst; // this is how the governance smart contract gets attached with the stable coin contract address
        udbst = _udbst;

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(GOVERN_ROLE, _msgSender());
    }

    function addCollateralToken(IERC20 colcontract) external nonReentrant {
        require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
        rsvList[reserveCount].colToken = colcontract; // this is for adding every single token added to the collateral
        reserveCount++; //
    }

    function setReserveContract(address reserve) external nonReentrant {
        require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
        reserveContract = reserve;
    }

    function setUDBSTTokenPrice(uint256 marketcap) external nonReentrant {
        require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
        ubstSupply = udbst.totalSupply();
        unstableColPrice = ((marketcap).mul(ubstSupply)).div(WEI_VALUE);
    }

    function collateralRebalancing() internal returns (bool) {
        // we do not apply here govern role because its internal
        uint256 stableBalance = rsvList[0].colToken.balanceOf(reserveContract); // 0 means 0th token in thisn case 0th will be dbst token
        // we are balancing the coin from reserve token address
        uint256 unstableBalance = rsvList[1].colToken.balanceOf(
            reserveContract
        );
        if (stableBalance != stableColAmount) {
            stableColAmount = stableBalance; //then do  this
        }

        if (unstableBalance != unstableColAmount) {
            unstableColAmount = unstableBalance; //then do  this
        }
        return true;
    }

    function setSdbstSupply(uint256 totalSupply) external {
        require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
        dbstSupply = totalSupply;
    }

    function validatePeg() external nonReentrant {
        dbstSupply = sdbst.totalSupply();
        bool result = collateralRebalancing(); // it needs to be true/falls for collateral rebalancing
        if (result = true) {
            // calculation of the total collateral value to peg stable coin in reserve.
            uint256 rawcolvalue = (stableColAmount.mul(WEI_VALUE)).add(
                unstableColAmount.mul(unstableColPrice)
            );
            uint256 colvalue = rawcolvalue.mul(WEI_VALUE);
            if (colvalue < dbstSupply) {
                uint256 supplyChange = dbstSupply.sub(colvalue); // when supply is higher from collateral value we subtract it from the
                uint256 burnAmount = (supplyChange.div(unstableColPrice)).mul(
                    WEI_VALUE
                );
                udbst.burn(burnAmount); // when we will burn there will be supply change
                _supplyChange[supplyChangeCount].method = "Burn"; // left part is to keep track of supply change by burn method/ex 10h, 20th time
                _supplyChange[supplyChangeCount].amount = supplyChange; // this is the value we obtain by subtracting the collateral value from the  supply
            }

            // case 2 if the value of the etheruim/unstable collateral goes high // flip the col value to dbstsupply

            if (colvalue > dbstSupply) {
                uint256 supplyChange = colvalue.sub(dbstSupply);
                sdbst.mint(supplyChange); // here will be mined in the place of burn due to increasing the value
                _supplyChange[supplyChangeCount].method = "Mint";
                _supplyChange[supplyChangeCount].amount = supplyChange;
            }

            dbstSupply = colvalue; // this is our desirable outcome to be stablise the coin
            _supplyChange[supplyChangeCount].timestamp = block.timestamp; // adding timestamp at the time of supplchange
            _supplyChange[supplyChangeCount].blocknum = block.number; // adding blocknumber
            supplyChangeCount++; // when supply will change supply change count will be incremented
            emit RepegAction(block.timestamp, colvalue);
        }
    }

    function withdraw(uint256 _amount) external nonReentrant {
        require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
        sdbst.transfer(address(msg.sender), _amount);
        emit Withdraw(block.timestamp, _amount);
    }

    function withdrawUDBST(uint256 _amount) external nonReentrant {
        require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
        udbst.transfer(address(msg.sender), _amount);
        emit Withdraw(block.timestamp, _amount);
    }
}
