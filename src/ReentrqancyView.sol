// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

import {console} from "forge-std/Script.sol";

contract Pool is ReentrancyGuard {
    WrappedToken private s_wrappedToken;
    ERC20 private s_depositToken;

    mapping(address => uint256) private s_depositedEther;
    mapping(address => uint256) private s_depositedPDT;
    mapping(address => bool) private s_lockedDeposits;

    error InvalidDeposit();
    error AlreadyDeposited();
    error InsufficientAllowance();

    constructor(address wrappedToken_, address depositToken_) {
        s_wrappedToken = WrappedToken(wrappedToken_);
        s_depositToken = ERC20(depositToken_);
    }

    function depositEther() external payable {
        if (msg.value != 0.001 ether) revert InvalidDeposit();

        if (s_depositedEther[msg.sender] != 0) revert AlreadyDeposited();

        s_depositedEther[msg.sender] += msg.value;
        _mintWrappedTokens(msg.sender, 10);
    }

    function depositPDT(uint256 value) external {
        if (s_depositToken.allowance(msg.sender, address(this)) < value)
            revert InsufficientAllowance();

        s_depositedPDT[msg.sender] += value;
        s_depositToken.transferFrom(msg.sender, address(this), value);
        _mintWrappedTokens(msg.sender, value);
    }

    function withdrawAll() external nonReentrant {
        // send the DT to the user
        uint256 _depositedValue = s_depositedPDT[msg.sender];

        s_depositedPDT[msg.sender] = 0;
        s_depositToken.transfer(msg.sender, _depositedValue);

        // send the ether to the user
        _depositedValue = s_depositedEther[msg.sender];

        s_depositedEther[msg.sender] = 0;
        payable(msg.sender).call{value: _depositedValue}("");

        uint256 _pwtBalance = s_wrappedToken.balanceOf(msg.sender);
        _burnWrappedTokens(msg.sender, _pwtBalance);
    }

    function lockDeposits() external {
        console.log("Locking deposits", msg.sender);
        s_lockedDeposits[msg.sender] = true;
    }

    function depositsLocked(address account_) external view returns (bool) {
        return s_lockedDeposits[account_];
    }

    function balanceOf(address account_) external view returns (uint256) {
        return s_wrappedToken.balanceOf(account_);
    }

    function _mintWrappedTokens(address account_, uint256 amount_) private {
        s_wrappedToken.mint(account_, amount_);
    }

    function _burnWrappedTokens(address account_, uint256 amount_) private {
        s_wrappedToken.burn(account_, amount_);
    }
}

contract BettingHouse {
    Pool private s_pool;
    uint256 private constant BET_PRICE = 20;
    mapping(address => bool) private s_bettors;

    error InsufficientFunds();
    error FundsNotLocked();

    constructor(address pool_) {
        s_pool = Pool(pool_);
    }

    function makeBet(address bettor_) external {
        if (s_pool.balanceOf(msg.sender) < BET_PRICE)
            revert InsufficientFunds();
        if (!s_pool.depositsLocked(msg.sender)) revert FundsNotLocked();

        s_bettors[bettor_] = true;
    }

    function isBettor(address bettor_) external view returns (bool) {
        return s_bettors[bettor_];
    }

    /* really awesome implementation of betting house */
}

contract DepositToken is ERC20, Ownable {
    constructor() ERC20("PoolDepositToken", "PDT") Ownable(msg.sender) {}

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }
}

contract WrappedToken is ERC20, Ownable {
    constructor() ERC20("PoolWrappedToken", "PWT") Ownable(msg.sender) {}

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }
}
