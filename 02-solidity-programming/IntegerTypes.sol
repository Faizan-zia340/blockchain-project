// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// IntegerTypes — integer ke sizes (kitne bit, kitna bara number)
contract IntegerTypes {
    uint8 public smallUint = 255; // 0 se 255 tak
    uint16 public mediumUint = 65535; // 0 se 65535 tak
    uint256 public bigUint = 1000000; // sab se bara, sab se zyada use hota hai
    int8 public smallInt = -128; // -128 se 127 tak
    int256 public bigInt = -1000000;
}
