// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Vm} from "forge-std/Vm.sol";
import {Script, console} from "forge-std/Script.sol";

import {Broadcasted} from "./LevelAttacks/Helper/Broadcasted.s.sol";
import {HelloAttack} from "./LevelAttacks/00Hello.s.sol";
import {FallbackAttack} from "./LevelAttacks/01Fallback.s.sol";
import {FalloutAttack} from "./LevelAttacks/02Fallout.s.sol";
import {CoinFlipAttack} from "./LevelAttacks/03CoinFlip.s.sol";
import {TelephoneAttack} from "./LevelAttacks/04Telephone.s.sol";
import {TokenAttack} from "./LevelAttacks/05Token.s.sol";
import {DelegationAttack} from "./LevelAttacks/06Delegation.s.sol";
import {ForceAttack} from "./LevelAttacks/07Force.s.sol";
import {VaultAttack} from "./LevelAttacks/08Vault.s.sol";
import {KingAttack} from "./LevelAttacks/09King.s.sol";
import {ReentrancyAttack} from "./LevelAttacks/10Reentrancy.s.sol";
import {ElevatorAttack} from "./LevelAttacks/11Elevator.s.sol";
import {PrivacyAttack} from "./LevelAttacks/12Privacy.s.sol";
import {GatekeeperOneAttack} from "./LevelAttacks/13GatekeeperOne.s.sol";
import {GatekeeperTwoAttack} from "./LevelAttacks/14GatekeeperTwo.s.sol";
import {NaughtCoinAttack, INaughtCoin} from "./LevelAttacks/15NaughtCoin.s.sol";
import {PreservationAttack} from "./LevelAttacks/16Preservation.s.sol";
import {RecoveryAttack} from "./LevelAttacks/17Recovery.s.sol";
import {MagicNumberAttack} from "./LevelAttacks/18MagicNumber.s.sol";
import {AlienCodexAttack} from "./LevelAttacks/19AlienCodex.s.sol";
import {DenialAttack} from "./LevelAttacks/20Denial.s.sol";
import {ShopAttack} from "./LevelAttacks/21Shop.s.sol";
import {DexAttack} from "./LevelAttacks/22Dex.s.sol";
import {DexTwoAttack} from "./LevelAttacks/23DexTwo.s.sol";
import {PuzzleWalletAttack} from "./LevelAttacks/24PuzzleWallet.s.sol";
import {MotorbikeAttack} from "./LevelAttacks/25Motorbike.s.sol";
import {DoubleEntryPointAttack} from "./LevelAttacks/26DoubleEntryPoint.s.sol";
import {GoodSamaritanAttack} from "./LevelAttacks/27GoodSamaritan.s.sol";
import {GateKeeperThreeAttack} from "./LevelAttacks/28GateKeeperThree.s.sol";
import {SwitchAttack} from "./LevelAttacks/29Switch.s.sol";
import {HigherOrderAttack} from "./LevelAttacks/30HigherOrder.s.sol";
import {StakeAttack} from "./LevelAttacks/31Stake.s.sol";

contract RunLvlAttack is Script {
    uint256 constant s_someEther = 0.00001 ether;
    uint256 constant s_initialDeposit = 0.001 ether;

    address[32] SEPOLIA_FACTORIES = [
        0x7E0f53981657345B31C59aC44e9c21631Ce710c7, // lvl 0
        0x3c34A342b2aF5e885FcaA3800dB5B205fEfa3ffB, // lvl 1
        0x676e57FdBbd8e5fE1A7A3f4Bb1296dAC880aa639, // lvl 2
        0xA62fE5344FE62AdC1F356447B669E9E6D10abaaF, // lvl 3
        0x2C2307bb8824a0AbBf2CC7D76d8e63374D2f8446, // lvl 4
        0x478f3476358Eb166Cb7adE4666d04fbdDB56C407, // lvl 5
        0x73379d8B82Fda494ee59555f333DF7D44483fD58, // lvl 6
        0xb6c2Ec883DaAac76D8922519E63f875c2ec65575, // lvl 7
        0xB7257D8Ba61BD1b3Fb7249DCd9330a023a5F3670, // lvl 8
        0x3049C00639E6dfC269ED1451764a046f7aE500c6, // lvl 9
        0x2a24869323C0B13Dff24E196Ba072dC790D52479, // lvl 10
        0x6DcE47e94Fa22F8E2d8A7FDf538602B1F86aBFd2, // lvl 11
        0x131c3249e115491E83De375171767Af07906eA36, // lvl 12
        0xb5858B8EDE0030e46C0Ac1aaAedea8Fb71EF423C, // lvl 13
        0x0C791D1923c738AC8c4ACFD0A60382eE5FF08a23, // lvl 14
        0x80934BE6B8B872B364b470Ca30EaAd8AEAC4f63F, // lvl 15
        0x7ae0655F0Ee1e7752D7C62493CEa1E69A810e2ed, // lvl 16
        0xAF98ab8F2e2B24F42C661ed023237f5B7acAB048, // lvl 17
        0x2132C7bc11De7A90B87375f282d36100a29f97a9, // lvl 18
        0x0BC04aa6aaC163A6B3667636D798FA053D43BD11, // lvl 19
        0x2427aF06f748A6adb651aCaB0cA8FbC7EaF802e6, // lvl 20
        0x691eeA9286124c043B82997201E805646b76351a, // lvl 21
        0xB468f8e42AC0fAe675B56bc6FDa9C0563B61A52F, // lvl 22
        0xf59112032D54862E199626F55cFad4F8a3b0Fce9, // lvl 23
        0x725595BA16E76ED1F6cC1e1b65A88365cC494824, // lvl 24
        0x3A78EE8462BD2e31133de2B8f1f9CBD973D6eDd6, // lvl 25
        0x34bD06F195756635a10A7018568E033bC15F3FB5, // lvl 26
        0x36E92B2751F260D6a4749d7CA58247E7f8198284, // lvl 27
        0x653239b3b3E67BC0ec1Df7835DA2d38761FfD882, // lvl 28
        0xb2aBa0e156C905a9FAEc24805a009d99193E3E53, // lvl 29
        0xd459773f02e53F6e91b0f766e42E495aEf26088F, // lvl 30
        0xB99f27b94fCc8b9b6fF88e29E1741422DFC06224 // lvl 31
    ];

    // Sepolia chain 0
    address constant SEPOLIA_ETHERNAUT_CTR =
        0xa3e7317E591D5A0F1c605be1b3aC4D2ae56104d6;

    function run(uint256 lvlNumber_) public {
        vm.startBroadcast(tx.origin);
        (
            address _ethernautCtr,
            address _lvlFactory,
            Broadcasted _attackCtr,
            uint256 _callValue,
            bool _needBroadcast,
            uint256 _createValue,
            bool _noValidate
        ) = getLevelFactoryAttackCtrAndValue(lvlNumber_);

        // create lvl instance
        address payable _lvlInstance = createLevel(
            _ethernautCtr,
            _lvlFactory,
            _createValue
        );
        vm.stopBroadcast();

        // attack lvl instance
        console.log("needBroadcast", _needBroadcast);
        if (_needBroadcast) {
            vm.startBroadcast(tx.origin);
        }
        attackLevel(_lvlInstance, _attackCtr, _callValue, lvlNumber_);
        if (_needBroadcast) {
            vm.stopBroadcast();
        }

        // check lvl succeeded
        vm.startBroadcast(tx.origin);
        submitLevel(_ethernautCtr, _lvlFactory, _lvlInstance, _noValidate);
        vm.stopBroadcast();
    }

    function createLevel(
        address ethernautCtr_,
        address lvlFactory_,
        uint256 createValue_
    ) public returns (address payable) {
        // get lvl instance
        vm.recordLogs();
        IEthernaut(ethernautCtr_).createLevelInstance{value: createValue_}(
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

    function submitLevel(
        address ethernautCtr_,
        address lvlFactory_,
        address lvlInstance_,
        bool noValidate_
    ) public {
        // validate lvl if no disabled
        if (!noValidate_) {
            require(
                ILevelFactory(lvlFactory_).validateInstance(
                    payable(lvlInstance_),
                    tx.origin
                )
            );
        }
        // submit lvl instance
        IEthernaut(ethernautCtr_).submitLevelInstance(payable(lvlInstance_));
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
            address ethernautCtr,
            address lvlFactory,
            Broadcasted lvlAttack,
            uint256 callValue,
            bool needBroadcast,
            uint256 createValue,
            bool noValidate
        )
    {
        lvlFactory = SEPOLIA_FACTORIES[lvlNumber_];
        ethernautCtr = SEPOLIA_ETHERNAUT_CTR;

        if (lvlNumber_ == 0) {
            console.log("00 Hello level attack");
            lvlAttack = new HelloAttack();
        } else if (lvlNumber_ == 1) {
            console.log("01 Fallback level attack");
            lvlAttack = new FallbackAttack();
            callValue = 2 * s_someEther;
        } else if (lvlNumber_ == 2) {
            console.log("02 Fallout level attack");
            lvlAttack = new FalloutAttack();
        } else if (lvlNumber_ == 3) {
            // todo lvl3 need calls on different blocks look a workaround
            console.log("03 Coin Flip level attack");
            lvlAttack = new CoinFlipAttack();
            revert("Not implemented on foundry");
        } else if (lvlNumber_ == 4) {
            console.log("04 Telephone level attack");
            lvlAttack = new TelephoneAttack();
            needBroadcast = true;
        } else if (lvlNumber_ == 5) {
            console.log("05 Token level attack");
            lvlAttack = new TokenAttack();
        } else if (lvlNumber_ == 6) {
            console.log("06 Delegation level attack");
            lvlAttack = new DelegationAttack();
        } else if (lvlNumber_ == 7) {
            console.log("07 Force level attack");
            lvlAttack = new ForceAttack{value: s_someEther}();
            needBroadcast = true;
        } else if (lvlNumber_ == 8) {
            console.log("08 Vault level attack");
            lvlAttack = new VaultAttack();
        } else if (lvlNumber_ == 9) {
            console.log("09 King level attack");
            lvlAttack = new KingAttack();
            callValue = s_initialDeposit;
            needBroadcast = true;
            createValue = s_initialDeposit;
        } else if (lvlNumber_ == 10) {
            console.log("10 Reentrancy level attack");
            lvlAttack = new ReentrancyAttack();
            callValue = s_initialDeposit;
            needBroadcast = true;
            createValue = s_initialDeposit;
        } else if (lvlNumber_ == 11) {
            console.log("11 Elevator level attack");
            lvlAttack = new ElevatorAttack();
            needBroadcast = true;
        } else if (lvlNumber_ == 12) {
            console.log("12 Privacy level attack");
            lvlAttack = new PrivacyAttack();
        } else if (lvlNumber_ == 13) {
            console.log("13 Gate Keeper One level attack");
            lvlAttack = new GatekeeperOneAttack();
            needBroadcast = true;
        } else if (lvlNumber_ == 14) {
            console.log("14 Gate Keeper Two level attack");
            // lvlAttack = new GatekeeperTwoAttack();  no create the contract cuz the attack is in the constructor
            needBroadcast = true;
        } else if (lvlNumber_ == 15) {
            console.log("15 Naught Coin level attack");
            lvlAttack = new NaughtCoinAttack();
            needBroadcast = true;
        } else if (lvlNumber_ == 16) {
            console.log("16 Preservation level attack");
            lvlAttack = new PreservationAttack();
            needBroadcast = true;
        } else if (lvlNumber_ == 17) {
            console.log("17 Recovery level attack");
            lvlAttack = new RecoveryAttack();
            createValue = s_initialDeposit;
        } else if (lvlNumber_ == 18) {
            console.log("18 Magic Number level attack");
            lvlAttack = new MagicNumberAttack();
        } else if (lvlNumber_ == 19) {
            console.log("19 Alien Codex level attack");
            lvlAttack = new AlienCodexAttack();
        } else if (lvlNumber_ == 20) {
            console.log("20 Denial level attack");
            lvlAttack = new DenialAttack();
            createValue = s_initialDeposit;
        } else if (lvlNumber_ == 21) {
            console.log("21 Shop level attack");
            lvlAttack = new ShopAttack();
            needBroadcast = true;
        } else if (lvlNumber_ == 22) {
            console.log("22 Dex level attack");
            lvlAttack = new DexAttack();
        } else if (lvlNumber_ == 23) {
            console.log("23 Dex Two level attack");
            lvlAttack = new DexTwoAttack();
        } else if (lvlNumber_ == 24) {
            console.log("24 Puzzle Wallet level attack");
            lvlAttack = new PuzzleWalletAttack();
            createValue = s_initialDeposit;
            callValue = s_initialDeposit;
            needBroadcast = true;
        } else if (lvlNumber_ == 25) {
            console.log("25 Motorbike level attack");
            lvlAttack = new MotorbikeAttack();
            noValidate = true; // do not check validate due to it does not work on the testnet
        } else if (lvlNumber_ == 26) {
            console.log("26 Double Entry Point level attack");
            lvlAttack = new DoubleEntryPointAttack();
        } else if (lvlNumber_ == 27) {
            console.log("27 Good Samaritan level attack");
            lvlAttack = new GoodSamaritanAttack();
            needBroadcast = true;
        } else if (lvlNumber_ == 28) {
            console.log("28 Gate Keeper Three level attack");
            lvlAttack = new GateKeeperThreeAttack();
            needBroadcast = true;
            callValue = 2 * s_initialDeposit;
        } else if (lvlNumber_ == 29) {
            console.log("29 Switch level attack");
            lvlAttack = new SwitchAttack();
        } else if (lvlNumber_ == 30) {
            console.log("30 Higher Order level attack");
            lvlAttack = new HigherOrderAttack();
        } else if (lvlNumber_ == 31) {
            console.log("31 Stake attack");
            lvlAttack = new StakeAttack();
            // needBroadcast = true;
            createValue = s_initialDeposit;
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

    function engines(address) external returns (address);
}
