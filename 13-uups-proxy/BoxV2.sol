// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// Box V2 — V1 jaisa hi, sirf aik naya function (increment) add hai.
// Storage layout V1 jaisa hai (number pehle slot par), is liye upgrade par data safe rehta hai.
contract BoxV2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 public number;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(uint256 _number) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        number = _number;
    }

    function setNumber(uint256 _number) public {
        number = _number;
    }

    // V2 mein naya function
    function increment() public {
        number += 1;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
