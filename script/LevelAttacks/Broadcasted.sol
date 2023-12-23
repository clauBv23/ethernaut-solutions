// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import {console, Script} from "forge-std/Script.sol";

abstract contract Broadcasted is Script {
    function attack(address payable falloutCtr) public payable virtual;

    function broadcastedAttack(
        address payable levelInstanceCtr_
    ) external payable {
        // start broadcst to sign the transactions as the msg.sender(our address)
        vm.startBroadcast();
        attack(levelInstanceCtr_);
        vm.stopBroadcast();
    }
}
