// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

// Ye file sirf is liye hai ke `forge build` ERC1967Proxy ka artifact
// (out/ERC1967Proxy.sol/ERC1967Proxy.json) banaye.
// JS demo (uups-demo.js) ko proxy deploy karne ke liye wo artifact chahiye.
// Is file mein koi contract nahi hai — sirf import hai.
