// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import {Vm} from "forge-std/Vm.sol";
import {Script, console} from "forge-std/Script.sol";

import {FallbackAttk} from "./LevelAttacks/01FallbackAttk.sol";
import {FalloutAttk} from "./LevelAttacks/02FalloutAttk.sol";
import {Broadcasted} from "./LevelAttacks/Broadcasted.sol";

contract RunLvlAttack is Script {
    address EthernautCtr = 0xa3e7317E591D5A0F1c605be1b3aC4D2ae56104d6;
    address lvl1Factory = 0x3c34A342b2aF5e885FcaA3800dB5B205fEfa3ffB;
    address lvl2Factory = 0x676e57FdBbd8e5fE1A7A3f4Bb1296dAC880aa639;

    function run(uint256 lvlNumber_) public {
        (
            address _lvlFactory,
            Broadcasted _attackCtr,
            uint256 _callValue
        ) = _getLevelFactoryAttackCtrAndValue(lvlNumber_);

        // create lvl instance
        address payable _lvlInstance = _createLevel(_lvlFactory);

        // attack lvl instance
        _attackLevel(_lvlInstance, _attackCtr, _callValue);

        // check lvl suceeded
        _submitLevel(_lvlFactory, _lvlInstance);
    }

    function _createLevel(
        address lvlFactory_
    ) internal returns (address payable) {
        vm.startBroadcast();
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
        vm.stopBroadcast();

        return payable(_lvlInstance);
    }

    function _submitLevel(address lvlFactory_, address lvlInstance_) internal {
        // validate lvl
        require(
            ILevelFactory(lvlFactory_).validateInstance(
                payable(lvlInstance_),
                msg.sender
            )
        );
        vm.startBroadcast();
        // submit lvl instance
        IEthernaut(EthernautCtr).submitLevelInstance(payable(lvlInstance_));
        vm.stopBroadcast();
    }

    function _attackLevel(
        address lvlInstance_,
        Broadcasted attackCtr_,
        uint256 value_
    ) internal {
        // deploy attack contract
        // FallbackAttk _attackCtr = new FallbackAttk();
        // call attack on lvl instance
        attackCtr_.broadcastedAttack{value: value_}(payable(lvlInstance_));
    }

    function _getLevelFactoryAttackCtrAndValue(
        uint256 lvlNumber_
    )
        internal
        returns (address lvlFactory, Broadcasted lvlAttack, uint256 callValue)
    {
        if (lvlNumber_ == 1) {
            // todo make the fallback contract Broadcasted
            return (lvl1Factory, new FalloutAttk(), 0.00002 ether);
            // return (new FallbackAttk(), 0.00002 ether);
        } else if (lvlNumber_ == 2) {
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
