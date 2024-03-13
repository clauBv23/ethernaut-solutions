// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";

import {RunLvlAttack} from "../script/RunLvlAttack.s.sol";
import {Broadcasted} from "../script/LevelAttacks/Helper/Broadcasted.s.sol";

contract TestAttacks is Test {
    RunLvlAttack s_attackScript;
    uint256 constant s_totalAttackedLevels = 29;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        vm.createSelectFork(vm.rpcUrl("mumbai"));
        s_attackScript = new RunLvlAttack();
        // funding attack script contract and msg.sender
        vm.deal(address(s_attackScript), STARTING_BALANCE);
    }

    function testAttackLevels() public {
        for (uint160 i = 0; i <= s_totalAttackedLevels; ++i) {
            if (i == 3) {
                continue;
            }

            // chain 0 is sepolia chain other mumbai
            s_attackScript.run(1, i);
        }
    }
}
