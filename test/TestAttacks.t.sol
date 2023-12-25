// SPDT-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";

import {RunLvlAttack} from "../script/RunLvlAttack.sol";
import {Broadcasted} from "../script/LevelAttacks/Broadcasted.sol";

contract TestAttacks is Test {
    RunLvlAttack attackScript;
    uint256 constant totalAttakedLvls = 5;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        attackScript = new RunLvlAttack();
        // funding attack script contract and msg.sender
        // vm.deal(msg.sender, STARTING_BALANCE);
        vm.deal(address(attackScript), STARTING_BALANCE);
    }

    function testAttackLevls() public {
        for (uint160 i = 1; i <= totalAttakedLvls; ++i) {
            if (i == 3) {
                continue;
            }
            _callAttackScript(i);
        }
    }

    function _callAttackScript(uint256 lvlNumber_) internal {
        // it simulates the run function in the script, but send the transactions
        // signed by the msg.sender not the Test contract
        // same behaviour could be achieved by calling prank before the run function,
        // but that can't be done due to there is a broadcast inside the script when attaking
        (
            address _lvlFactory,
            Broadcasted _attackCtr,
            uint256 _callValue,

        ) = attackScript.getLevelFactoryAttackCtrAndValue(lvlNumber_);

        // create lvl instance
        vm.prank(msg.sender);
        address payable _lvlInstance = attackScript.createLevel(_lvlFactory);
        // attack lvl instance
        attackScript.attackLevel(_lvlInstance, _attackCtr, _callValue);
        // check lvl suceeded
        vm.prank(msg.sender);
        attackScript.submitLevel(_lvlFactory, _lvlInstance);
    }
}
