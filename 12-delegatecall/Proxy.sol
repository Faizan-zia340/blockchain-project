// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Proxy contract — delegatecall se Logic ka code chalata hai,
// lekin storage aur msg.sender PROXY ke hote hain.
// Storage layout: number (slot 0) aur message (slot 1) Logic jaisi hai,
// is liye Logic ka code Proxy ke sahi slots mein likhta hai.
contract Proxy {
    uint256 public number;
    string public message;
    address public implementation;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function setNumber(uint256 _number) public {
        (bool success, ) = implementation.delegatecall(
            abi.encodeWithSignature("setNumber(uint256)", _number)
        );
        require(success, "delegatecall failed");
    }

    function setMessage(string memory _message) public {
        (bool success, ) = implementation.delegatecall(
            abi.encodeWithSignature("setMessage(string)", _message)
        );
        require(success, "delegatecall failed");
    }
}
