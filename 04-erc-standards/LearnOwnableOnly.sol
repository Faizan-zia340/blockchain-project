// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// SEPARATELY - PART 2: Sirf Ownable, ERC20 nahi hai
// Is me koi token nahi, sirf owner ka concept hai

contract LearnOwnableOnly {
    address public owner;
    uint256 public myNumber;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    error NotOwner();

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Sirf owner kar sakta hai - ye test karne ke liye hai
    function setNumber(uint256 _num) public onlyOwner {
        myNumber = _num;
    }

    // Sirf owner kar sakta hai
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is zero address");
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    // WARNING: test me mat dabana, owner khatam ho jayega
    function renounceOwnership() public onlyOwner {
        address oldOwner = owner;
        owner = address(0);
        emit OwnershipTransferred(oldOwner, address(0));
    }
}
