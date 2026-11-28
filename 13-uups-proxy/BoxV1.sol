// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// Box V1 — UUPS upgradeable contract.
// Constructor ki jagah initialize() use hota hai (proxy ke through deploy hota hai).
contract BoxV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
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

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
