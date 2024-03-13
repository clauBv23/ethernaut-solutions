// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.s.sol";

contract DoubleEntryPointAttack is Broadcasted {
    function attack(
        address payable doubleEntryPointCtr_
    ) public payable override {
        IForta _forta = IDoubleEntryPoint(doubleEntryPointCtr_).forta();
        MyBot _mb = new MyBot(address(_forta));
        // add bot
        _forta.setDetectionBot(address(_mb));
    }
}

interface IDoubleEntryPoint {
    function forta() external view returns (IForta);
}

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;

    function raiseAlert(address user) external;
}

interface IDetectionBot {
    function handleTransaction(address user, bytes calldata msgData) external;
}

contract MyBot is IDetectionBot {
    IForta s_forta;

    constructor(address forta_) {
        s_forta = IForta(forta_);
    }

    function handleTransaction(address user, bytes calldata) external override {
        s_forta.raiseAlert(user);
    }
}
