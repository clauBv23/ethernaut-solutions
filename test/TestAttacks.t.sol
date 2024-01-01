// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";

import {RunLvlAttack} from "../script/RunLvlAttack.sol";
import {Broadcasted} from "../script/LevelAttacks/Broadcasted.sol";

contract TestAttacks is Test {
    RunLvlAttack s_attackScript;
    uint256 constant s_totalAttackedLevels = 23;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        s_attackScript = new RunLvlAttack();
        // funding attack script contract and msg.sender
        vm.deal(msg.sender, STARTING_BALANCE);
        vm.deal(address(s_attackScript), STARTING_BALANCE);
    }

    function testAttackLevels() public {
        for (uint160 i = 15; i <= 15; ++i) {
            if (i == 3) {
                continue;
            }

            s_attackScript.run(i);
        }
    }
}
