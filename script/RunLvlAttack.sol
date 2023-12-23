// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import {Vm} from "forge-std/Vm.sol";
import {Script, console} from "forge-std/Script.sol";

import {FallbackAttk} from "./LevelAttacks/01FallbackAttk.sol";
import {FalloutAttk} from "./LevelAttacks/02FalloutAttk.sol";
import {Broadcasted} from "./LevelAttacks/Broadcasted.sol";

contract RunLvlAttack is Script {
    address constant EthernautCtr = 0xa3e7317E591D5A0F1c605be1b3aC4D2ae56104d6;
    address constant lvl1Factory = 0x3c34A342b2aF5e885FcaA3800dB5B205fEfa3ffB;
    address constant lvl2Factory = 0x676e57FdBbd8e5fE1A7A3f4Bb1296dAC880aa639;

    // todo could be easier to use but will imply storing all lvls on storage
    // mapping(uint256 lvlNumber => address lvlFactory) lvlFactories;

    function run(uint256 lvlNumber_) public {
        (
            address _lvlFactory,
            Broadcasted _attackCtr,
            uint256 _callValue
        ) = getLevelFactoryAttackCtrAndValue(lvlNumber_);

        // create lvl instance
        address payable _lvlInstance = createLevel(_lvlFactory);

        // attack lvl instance
        attackLevel(_lvlInstance, _attackCtr, _callValue);

        // check lvl suceeded
        submitLevel(_lvlFactory, _lvlInstance);
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
        returns (address lvlFactory, Broadcasted lvlAttack, uint256 callValue)
    {
        if (lvlNumber_ == 1) {
            console.log("01 Fallback level attack");
            return (lvl1Factory, new FallbackAttk(), 0.00002 ether);
        } else if (lvlNumber_ == 2) {
            console.log("02 Fallout level attack");
            return (lvl2Factory, new FalloutAttk(), 0);
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
