// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.sol";

contract GateKeeperThreeAttack is Broadcasted {
    function attack(address payable motorbikeCtr_) public payable override {}
}
