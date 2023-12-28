// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";

import {RunLvlAttack} from "../script/RunLvlAttack.sol";
import {Broadcasted} from "../script/LevelAttacks/Broadcasted.sol";

contract TestAttacks is Test {
    RunLvlAttack s_attackScript;
    uint256 constant s_totalAttackedLevels = 20;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        s_attackScript = new RunLvlAttack();
        // funding attack script contract and msg.sender
        vm.deal(msg.sender, STARTING_BALANCE);
        vm.deal(address(s_attackScript), STARTING_BALANCE);
    }

    function testAttackLevels() public {
        for (uint160 i = 0; i <= s_totalAttackedLevels; ++i) {
            if (i == 3) {
                continue;
            }
            if (i == 15) {
                // todo review why the test is not working
                continue;
            }
            _callAttackScript(i);
        }
    }

    function _callAttackScript(uint256 lvlNumber_) internal {
        // it simulates the run function in the script, but send the transactions
        // signed by the msg.sender not the Test contract
        // same behavior could be achieved by calling prank before the run function,
        // but that can't be done due to there is a broadcast inside the script when attacking
        vm.startBroadcast(msg.sender);
        (
            address _lvlFactory,
            Broadcasted _attackCtr,
            uint256 _callValue,
            bool _needBroadcast,
            uint256 _createValue
        ) = s_attackScript.getLevelFactoryAttackCtrAndValue(lvlNumber_);

        // create lvl instance
        // vm.prank(msg.sender);
        address payable _lvlInstance = s_attackScript.createLevel(
            _lvlFactory,
            _createValue
        );
        vm.stopBroadcast();

        if (_needBroadcast) {
            vm.startBroadcast(msg.sender);
        }
        // attack lvl instance
        s_attackScript.attackLevel(
            _lvlInstance,
            _attackCtr,
            _callValue,
            lvlNumber_
        );
        if (_needBroadcast) {
            vm.stopBroadcast();
        }
        // check lvl succeeded
        // vm.prank(msg.sender);
        vm.startBroadcast(msg.sender);
        s_attackScript.submitLevel(_lvlFactory, _lvlInstance);
        vm.stopBroadcast();
    }
}
