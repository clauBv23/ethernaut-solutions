// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Vm} from "forge-std/Vm.sol";
import {Script, console} from "forge-std/Script.sol";

import {Broadcasted} from "./LevelAttacks/Helper/Broadcasted.sol";
import {HelloAttack} from "./LevelAttacks/00Hello.sol";
import {FallbackAttack} from "./LevelAttacks/01Fallback.sol";
import {FalloutAttack} from "./LevelAttacks/02Fallout.sol";
import {CoinFlipAttack} from "./LevelAttacks/03CoinFlip.sol";
import {TelephoneAttack} from "./LevelAttacks/04Telephone.sol";
import {TokenAttack} from "./LevelAttacks/05Token.sol";
import {DelegationAttack} from "./LevelAttacks/06Delegation.sol";
import {ForceAttack} from "./LevelAttacks/07Force.sol";
import {VaultAttack} from "./LevelAttacks/08Vault.sol";
import {KingAttack} from "./LevelAttacks/09King.sol";
import {ReentrancyAttack} from "./LevelAttacks/10Reentrancy.sol";
import {ElevatorAttack} from "./LevelAttacks/11Elevator.sol";
import {PrivacyAttack} from "./LevelAttacks/12Privacy.sol";
import {GatekeeperOneAttack} from "./LevelAttacks/13GatekeeperOne.sol";
import {GatekeeperTwoAttack} from "./LevelAttacks/14GatekeeperTwo.sol";
import {NaughtCoinAttack, INaughtCoin} from "./LevelAttacks/15NaughtCoin.sol";
import {PreservationAttack} from "./LevelAttacks/16Preservation.sol";
import {RecoveryAttack} from "./LevelAttacks/17Recovery.sol";
import {MagicNumberAttack} from "./LevelAttacks/18MagicNumber.sol";
import {AlienCodexAttack} from "./LevelAttacks/19AlienCodex.sol";
import {DenialAttack} from "./LevelAttacks/20Denial.sol";
import {ShopAttack} from "./LevelAttacks/21Shop.sol";
import {DexAttack} from "./LevelAttacks/22Dex.sol";
import {DexTwoAttack} from "./LevelAttacks/23DexTwo.sol";
import {PuzzleWalletAttack} from "./LevelAttacks/24PuzzleWallet.sol";

contract RunLvlAttack is Script {
    uint256 constant s_someEther = 0.00001 ether;
    uint256 constant s_initialDeposit = 0.001 ether;
    // address in Sepolia
    address constant ETHERNAUT_CTR = 0xa3e7317E591D5A0F1c605be1b3aC4D2ae56104d6;
    address constant LVL_0_FACTORY = 0x7E0f53981657345B31C59aC44e9c21631Ce710c7;
    address constant LVL_1_FACTORY = 0x3c34A342b2aF5e885FcaA3800dB5B205fEfa3ffB;
    address constant LVL_2_FACTORY = 0x676e57FdBbd8e5fE1A7A3f4Bb1296dAC880aa639;
    address constant LVL_3_FACTORY = 0xA62fE5344FE62AdC1F356447B669E9E6D10abaaF;
    address constant LVL_4_FACTORY = 0x2C2307bb8824a0AbBf2CC7D76d8e63374D2f8446;
    address constant LVL_5_FACTORY = 0x478f3476358Eb166Cb7adE4666d04fbdDB56C407;
    address constant LVL_6_FACTORY = 0x73379d8B82Fda494ee59555f333DF7D44483fD58;
    address constant LVL_7_FACTORY = 0xb6c2Ec883DaAac76D8922519E63f875c2ec65575;
    address constant LVL_8_FACTORY = 0xB7257D8Ba61BD1b3Fb7249DCd9330a023a5F3670;
    address constant LVL_9_FACTORY = 0x3049C00639E6dfC269ED1451764a046f7aE500c6;
    address constant LVL_10_FACTORY =
        0x2a24869323C0B13Dff24E196Ba072dC790D52479;
    address constant LVL_11_FACTORY =
        0x6DcE47e94Fa22F8E2d8A7FDf538602B1F86aBFd2;
    address constant LVL_12_FACTORY =
        0x131c3249e115491E83De375171767Af07906eA36;
    address constant LVL_13_FACTORY =
        0xb5858B8EDE0030e46C0Ac1aaAedea8Fb71EF423C;
    address constant LVL_14_FACTORY =
        0x0C791D1923c738AC8c4ACFD0A60382eE5FF08a23;
    address constant LVL_15_FACTORY =
        0x80934BE6B8B872B364b470Ca30EaAd8AEAC4f63F;
    address constant LVL_16_FACTORY =
        0x7ae0655F0Ee1e7752D7C62493CEa1E69A810e2ed;
    address constant LVL_17_FACTORY =
        0xAF98ab8F2e2B24F42C661ed023237f5B7acAB048;
    address constant LVL_18_FACTORY =
        0x2132C7bc11De7A90B87375f282d36100a29f97a9;
    address constant LVL_19_FACTORY =
        0x0BC04aa6aaC163A6B3667636D798FA053D43BD11;
    address constant LVL_20_FACTORY =
        0x2427aF06f748A6adb651aCaB0cA8FbC7EaF802e6;
    address constant LVL_21_FACTORY =
        0x691eeA9286124c043B82997201E805646b76351a;
    address constant LVL_22_FACTORY =
        0xB468f8e42AC0fAe675B56bc6FDa9C0563B61A52F;
    address constant LVL_23_FACTORY =
        0xf59112032D54862E199626F55cFad4F8a3b0Fce9;
    address constant LVL_24_FACTORY =
        0x725595BA16E76ED1F6cC1e1b65A88365cC494824;

    // todo could be easier to use but will imply storing all levels on storage
    // mapping(uint256 lvlNumber => address lvlFactory) lvlFactories;

    function run(uint256 lvlNumber_) public {
        vm.startBroadcast(tx.origin);
        (
            address _lvlFactory,
            Broadcasted _attackCtr,
            uint256 _callValue,
            bool _needBroadcast,
            uint256 _createValue
        ) = getLevelFactoryAttackCtrAndValue(lvlNumber_);

        // create lvl instance
        address payable _lvlInstance = createLevel(_lvlFactory, _createValue);
        vm.stopBroadcast();

        // attack lvl instance
        if (_needBroadcast) {
            vm.startBroadcast(tx.origin);
        }
        attackLevel(_lvlInstance, _attackCtr, _callValue, lvlNumber_);
        if (_needBroadcast) {
            vm.stopBroadcast();
        }

        // check lvl succeeded
        vm.startBroadcast(tx.origin);
        submitLevel(_lvlFactory, _lvlInstance);
        vm.stopBroadcast();
    }

    function createLevel(
        address lvlFactory_,
        uint256 createValue_
    ) public returns (address payable) {
        // get lvl instance
        vm.recordLogs();
        IEthernaut(ETHERNAUT_CTR).createLevelInstance{value: createValue_}(
            lvlFactory_
        );
        Vm.Log[] memory _entries = vm.getRecordedLogs();
        uint256 _entriesLength = _entries.length - 1;
        require(_entries.length > 0, "No event emitted");
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
                tx.origin
            )
        );
        // submit lvl instance
        IEthernaut(ETHERNAUT_CTR).submitLevelInstance(payable(lvlInstance_));
    }

    function attackLevel(
        address lvlInstance_,
        Broadcasted attackCtr_,
        uint256 value_,
        uint256 lvlNumber_
    ) public {
        // call attack on lvl instance
        if (attackCtr_ == Broadcasted(address(0))) {
            // there is not deployed attack contract the attack is in the constructor
            if (lvlNumber_ == 14) {
                attackCtr_ = new GatekeeperTwoAttack(payable(lvlInstance_));
            }
        } else {
            if (lvlNumber_ == 15) {
                //need extra configuration for approval
                INaughtCoin(lvlInstance_).approve(
                    address(attackCtr_),
                    INaughtCoin(lvlInstance_).balanceOf(tx.origin)
                );
            }
            attackCtr_.broadcastedAttack{value: value_}(payable(lvlInstance_));
        }
    }

    function getLevelFactoryAttackCtrAndValue(
        uint256 lvlNumber_
    )
        public
        returns (
            address lvlFactory,
            Broadcasted lvlAttack,
            uint256 callValue,
            bool needBroadcast,
            uint256 createValue
        )
    {
        if (lvlNumber_ == 0) {
            console.log("00 Hello level attack");
            lvlFactory = LVL_0_FACTORY;
            lvlAttack = new HelloAttack();
        } else if (lvlNumber_ == 1) {
            console.log("01 Fallback level attack");
            lvlFactory = LVL_1_FACTORY;
            lvlAttack = new FallbackAttack();
            callValue = 2 * s_someEther;
        } else if (lvlNumber_ == 2) {
            console.log("02 Fallout level attack");
            lvlFactory = LVL_2_FACTORY;
            lvlAttack = new FalloutAttack();
        }
        // else if (lvlNumber_ == 3) {
        // todo lvl3 need calls on different blocks look a workaround
        //     console.log("03 Coin Flip level attack");
        //     return (LVL_3_FACTORY, new CoinFlipAttack(), 0);
        // }
        else if (lvlNumber_ == 4) {
            console.log("04 Telephone level attack");
            lvlFactory = LVL_4_FACTORY;
            lvlAttack = new TelephoneAttack();
            needBroadcast = true;
        } else if (lvlNumber_ == 5) {
            console.log("05 Token level attack");
            lvlFactory = LVL_5_FACTORY;
            lvlAttack = new TokenAttack();
        } else if (lvlNumber_ == 6) {
            console.log("06 Delegation level attack");
            lvlFactory = LVL_6_FACTORY;
            lvlAttack = new DelegationAttack();
        } else if (lvlNumber_ == 7) {
            console.log("07 Force level attack");
            lvlFactory = LVL_7_FACTORY;
            lvlAttack = new ForceAttack{value: s_someEther}();
            needBroadcast = true;
        } else if (lvlNumber_ == 8) {
            console.log("08 Vault level attack");
            lvlFactory = LVL_8_FACTORY;
            lvlAttack = new VaultAttack();
        } else if (lvlNumber_ == 9) {
            console.log("09 King level attack");
            lvlFactory = LVL_9_FACTORY;
            lvlAttack = new KingAttack();
            callValue = s_initialDeposit;
            needBroadcast = true;
            createValue = s_initialDeposit;
        } else if (lvlNumber_ == 10) {
            console.log("10 Reentrancy level attack");
            lvlFactory = LVL_10_FACTORY;
            lvlAttack = new ReentrancyAttack();
            callValue = s_initialDeposit;
            needBroadcast = true;
            createValue = s_initialDeposit;
        } else if (lvlNumber_ == 11) {
            console.log("11 Elevator level attack");
            lvlFactory = LVL_11_FACTORY;
            lvlAttack = new ElevatorAttack();
            needBroadcast = true;
        } else if (lvlNumber_ == 12) {
            console.log("12 Privacy level attack");
            lvlFactory = LVL_12_FACTORY;
            lvlAttack = new PrivacyAttack();
        } else if (lvlNumber_ == 13) {
            console.log("13 Gate Keeper One level attack");
            lvlFactory = LVL_13_FACTORY;
            lvlAttack = new GatekeeperOneAttack();
            needBroadcast = true;
        } else if (lvlNumber_ == 14) {
            console.log("14 Gate Keeper Two level attack");
            lvlFactory = LVL_14_FACTORY;
            // lvlAttack = new GatekeeperTwoAttack();  no create the contract cuz the attack is in the constructor
            needBroadcast = true;
        } else if (lvlNumber_ == 15) {
            console.log("15 Naught Coin level attack");
            lvlFactory = LVL_15_FACTORY;
            lvlAttack = new NaughtCoinAttack();
            needBroadcast = true;
        } else if (lvlNumber_ == 16) {
            console.log("16 Preservation level attack");
            lvlFactory = LVL_16_FACTORY;
            lvlAttack = new PreservationAttack();
            needBroadcast = true;
        } else if (lvlNumber_ == 17) {
            console.log("17 Recovery level attack");
            lvlFactory = LVL_17_FACTORY;
            lvlAttack = new RecoveryAttack();
            createValue = s_initialDeposit;
        } else if (lvlNumber_ == 18) {
            console.log("18 Magic Number level attack");
            lvlFactory = LVL_18_FACTORY;
            lvlAttack = new MagicNumberAttack();
        } else if (lvlNumber_ == 19) {
            console.log("19 Alien Codex level attack");
            lvlFactory = LVL_19_FACTORY;
            lvlAttack = new AlienCodexAttack();
        } else if (lvlNumber_ == 20) {
            console.log("20 Denial level attack");
            lvlFactory = LVL_20_FACTORY;
            lvlAttack = new DenialAttack();
            createValue = s_initialDeposit;
        } else if (lvlNumber_ == 21) {
            console.log("21 Shop level attack");
            lvlFactory = LVL_21_FACTORY;
            lvlAttack = new ShopAttack();
            needBroadcast = true;
        } else if (lvlNumber_ == 22) {
            console.log("22 Dex level attack");
            lvlFactory = LVL_22_FACTORY;
            lvlAttack = new DexAttack();
        } else if (lvlNumber_ == 23) {
            console.log("23 Dex Two level attack");
            lvlFactory = LVL_23_FACTORY;
            lvlAttack = new DexTwoAttack();
        } else if (lvlNumber_ == 24) {
            console.log("24 Puzzle Wallet level attack");
            lvlFactory = LVL_24_FACTORY;
            lvlAttack = new PuzzleWalletAttack();
            createValue = s_initialDeposit;
            callValue = s_initialDeposit;
            needBroadcast = true;
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
