// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EIP191Verify — EIP-191 message sign + verify demo (Remix VM only)
/// @notice Test demo hai — koi real funds nahi. Sirf seekhne ke liye.
contract EIP191Verify {
    /// @notice Message ka hash (keccak256). "Hello Faizy" ka hash:
    /// 0x7828bafb3bd214fee07cdfbc89ad59953c99f11e57ba73c138ec4bfda080c88a
    function getMessageHash(string memory message) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(message));
    }

    /// @notice EIP-191 prefix wala hash — yehi hash sign hota hai.
    /// Prefix: "\x19Ethereum Signed Message:\n32" + messageHash
    /// "Hello Faizy" ka ethSignedMessageHash:
    /// 0x56675bcb485879a0fd45d27e22f47dc9ad1923261e3ab5615d4042d68252d3b6
    function getEthSignedMessageHash(bytes32 messageHash) public pure returns (bytes32) {
        return keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
        );
    }

    /// @notice Signature (65 bytes: r + s + v) ko todta hai.
    function splitSignature(
        bytes memory sig
    ) public pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(sig.length == 65, "invalid signature length");
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

    /// @notice Signature se signer ka address nikalta hai (ecrecover).
    function recoverSigner(
        bytes32 ethSignedMessageHash,
        bytes memory signature
    ) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(signature);
        return ecrecover(ethSignedMessageHash, v, r, s);
    }

    /// @notice Aik call me poora verify: true aaye to signature sahi hai.
    function verify(
        address signer,
        string memory message,
        bytes memory signature
    ) public pure returns (bool) {
        bytes32 messageHash = getMessageHash(message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        return recoverSigner(ethSignedMessageHash, signature) == signer;
    }
}
