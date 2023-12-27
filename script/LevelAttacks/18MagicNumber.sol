// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract MagicNumberAttk is Broadcasted {
    function attack(address payable magicNumberCtr_) public payable override {
        IMagicNumber(magicNumberCtr_).setSolver(address(new MySolver()));
    }
}

interface IMagicNumber {
    function setSolver(address _solver) external;
}

contract MySolver {
    constructor() {
        // ! to solve it have to be able to return 42 with only 10 bytes (opcodes)
        assembly {
            /**
                store 42 on memory
                0x60 PUSH1 2a  (602a)   2a = 42 push the value 
                0x60 PUSH1 0   (6000)   push the memory offset (any value can be set)
                0x52 MSTORE    (52)     pop offset and value from the stack

                // return the value in memory
                0x60 PUSH1 20   (6020)  20 = 32 the value size, a memory slot 32 bytes
                0x60 PUSH1 0    (6000)  push the memory offset (the position when the value was stored)
                0xf3 RETURN     (f3)    pop the offset and the size from stack

                602a60005260206000f3  length 10 = 0a
                offset 22 = 16
           */
            mstore(0, 0x602a60005260206000f3)
            return(0x16, 0x0a)
        }
    }
}
