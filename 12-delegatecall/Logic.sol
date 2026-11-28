// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Logic contract — iska code Proxy ke through chalta hai (delegatecall).
// Iske apne storage mein kuch nahi badalta; sab Proxy ke storage mein hota hai.
contract Logic {
    uint256 public number;
    string public message;

    function setNumber(uint256 _number) public {
        number = _number;
    }

    function setMessage(string memory _message) public {
        message = _message;
    }
}
