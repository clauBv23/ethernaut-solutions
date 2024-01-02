// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.s.sol";

contract HelloAttack is Broadcasted {
    function attack(address payable helloCtr_) public payable override {
        IHello(helloCtr_).authenticate("ethernaut0");
    }
}

interface IHello {
    function authenticate(string memory passkey) external;
}
