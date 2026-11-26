// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CallDemo {
    function sendEth(address payable to) public payable returns (bool) {
        (bool success, ) = to.call{value: msg.value}("");
        require(success, "ETH send fail");
        return success;
    }

    function callSetNumber(address receiver, uint256 _number) public returns (bool) {
        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", _number);
        (bool success, ) = receiver.call(data);
        require(success, "call fail");
        return success;
    }

    function callSetMessage(address receiver, string memory _message) public returns (bool) {
        bytes memory data = abi.encodeWithSignature("setMessage(string)", _message);
        (bool success, ) = receiver.call(data);
        require(success, "call fail");
        return success;
    }
}
