// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import {Vm} from "forge-std/Vm.sol";
import {Script, console} from "forge-std/Script.sol";

import {Broadcasted} from "./LevelAttacks/Broadcasted.sol";
import {FallbackAttk} from "./LevelAttacks/01Fallback.sol";
import {FalloutAttk} from "./LevelAttacks/02Fallout.sol";
import {CoinFlipAttk} from "./LevelAttacks/03CoinFlip.sol";
import {TelephoneAttk} from "./LevelAttacks/04Telephone.sol";
import {TokenAttack} from "./LevelAttacks/05Token.sol";
import {DelegationAttk} from "./LevelAttacks/06Delegation.sol";
import {ForceAttk} from "./LevelAttacks/07Force.sol";

contract RunLvlAttack is Script {
    // address in Sepolia
    address constant EthernautCtr = 0xa3e7317E591D5A0F1c605be1b3aC4D2ae56104d6;
    address constant lvl1Factory = 0x3c34A342b2aF5e885FcaA3800dB5B205fEfa3ffB;
    address constant lvl2Factory = 0x676e57FdBbd8e5fE1A7A3f4Bb1296dAC880aa639;
    address constant lvl3Factory = 0xA62fE5344FE62AdC1F356447B669E9E6D10abaaF;
    address constant lvl4Factory = 0x2C2307bb8824a0AbBf2CC7D76d8e63374D2f8446;
    address constant lvl5Factory = 0x478f3476358Eb166Cb7adE4666d04fbdDB56C407;
    address constant lvl6Factory = 0x73379d8B82Fda494ee59555f333DF7D44483fD58;
    address constant lvl7Factory = 0xb6c2Ec883DaAac76D8922519E63f875c2ec65575;

    // todo could be easier to use but will imply storing all lvls on storage
    // mapping(uint256 lvlNumber => address lvlFactory) lvlFactories;

    function run(uint256 lvlNumber_) public {
        vm.startBroadcast();
        (
            address _lvlFactory,
            Broadcasted _attackCtr,
            uint256 _callValue,
            bool needBroadcast
        ) = getLevelFactoryAttackCtrAndValue(lvlNumber_);

        // create lvl instance
        address payable _lvlInstance = createLevel(_lvlFactory);
        vm.stopBroadcast();

        // attack lvl instance
        if (needBroadcast) {
            vm.startBroadcast();
        }
        attackLevel(_lvlInstance, _attackCtr, _callValue);
        if (needBroadcast) {
            vm.stopBroadcast();
        }

        // check lvl suceeded
        vm.startBroadcast();
        submitLevel(_lvlFactory, _lvlInstance);
        vm.stopBroadcast();
    }

    function createLevel(address lvlFactory_) public returns (address payable) {
        // get lvl instance
        vm.recordLogs();
        IEthernaut(EthernautCtr).createLevelInstance(lvlFactory_);

        Vm.Log[] memory _entries = vm.getRecordedLogs();
        uint256 _entriesLength = _entries.length - 1;
        require(_entries.length > 0, "No event emited");
        require(
            _entries[_entriesLength].topics[0] ==
                keccak256("LevelInstanceCreatedLog(address,address,address)"),
            "Not the right event"
        );

        address _lvlInstance = address(
            uint160(uint256(_entries[_entriesLength].topics[2]))
        );

        return payable(_lvlInstance);
    }

    function submitLevel(address lvlFactory_, address lvlInstance_) public {
        // validate lvl
        require(
            ILevelFactory(lvlFactory_).validateInstance(
                payable(lvlInstance_),
                msg.sender
            )
        );
        // submit lvl instance
        IEthernaut(EthernautCtr).submitLevelInstance(payable(lvlInstance_));
    }

    function attackLevel(
        address lvlInstance_,
        Broadcasted attackCtr_,
        uint256 value_
    ) public {
        // call attack on lvl instance
        attackCtr_.broadcastedAttack{value: value_}(payable(lvlInstance_));
    }

    function getLevelFactoryAttackCtrAndValue(
        uint256 lvlNumber_
    )
        public
        returns (
            address lvlFactory,
            Broadcasted lvlAttack,
            uint256 callValue,
            bool needBroadcast
        )
    {
        if (lvlNumber_ == 1) {
            console.log("01 Fallback level attack");
            return (lvl1Factory, new FallbackAttk(), 0.00002 ether, false);
        } else if (lvlNumber_ == 2) {
            console.log("02 Fallout level attack");
            return (lvl2Factory, new FalloutAttk(), 0, false);
        }
        // else if (lvlNumber_ == 3) {
        // todo lvl3 need calls on different blocks look a workaround
        //     console.log("03 Coin Flip level attack");
        //     return (lvl3Factory, new CoinFlipAttk(), 0);
        // }
        else if (lvlNumber_ == 4) {
            console.log("04 Telephone level attack");
            return (lvl4Factory, new TelephoneAttk(), 0, true);
        } else if (lvlNumber_ == 5) {
            console.log("05 Token level attack");
            return (lvl5Factory, new TokenAttack(), 0, false);
        } else if (lvlNumber_ == 6) {
            console.log("06 Delegation level attack");
            return (lvl6Factory, new DelegationAttk(), 0, false);
        } else if (lvlNumber_ == 7) {
            console.log("07 Force level attack");
            return (
                lvl7Factory,
                new ForceAttk{value: 0.00001 ether}(),
                0,
                true
            );
        } else {
            revert("Not implemented");
        }
    }
}

interface IEthernaut {
    function createLevelInstance(address _level) external payable;

    function submitLevelInstance(address payable _instance) external;
}

interface ILevelFactory {
    function validateInstance(
        address payable _instance,
        address _player
    ) external returns (bool);
}
