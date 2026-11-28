// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

// EIP-712 — Typed Structured Data Signing.
// EIP-191 se farq: yahan sirf text nahi, aik STRUCTURED message (struct) sign hota hai.
// Domain (name, version, chainId, contract) + struct hash = digest, us par signature.
contract EIP712Verify is EIP712 {
    constructor() EIP712("FaizyMail", "1") {}

    struct Mail {
        address from;
        address to;
        string content;
    }

    bytes32 private constant MAIL_TYPEHASH =
        keccak256("Mail(address from,address to,string content)");

    function getMessageHash(
        address from,
        address to,
        string memory content
    ) public view returns (bytes32) {
        return
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        MAIL_TYPEHASH,
                        from,
                        to,
                        keccak256(bytes(content))
                    )
                )
            );
    }

    function recoverSigner(
        address from,
        address to,
        string memory content,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public view returns (address) {
        bytes32 digest = getMessageHash(from, to, content);
        return ECDSA.recover(digest, v, r, s);
    }

    function verify(
        address from,
        address to,
        string memory content,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public view returns (bool) {
        return recoverSigner(from, to, content, v, r, s) == from;
    }
}
