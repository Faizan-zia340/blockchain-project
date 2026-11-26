// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Receiver {
    uint256 public number;
    string public message;

    function setNumber(uint256 _number) public {
        number = _number;
    }

    function setMessage(string memory _message) public {
        message = _message;
    }

    receive() external payable {}
}
