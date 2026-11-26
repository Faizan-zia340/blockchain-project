# Assignment 8 — EIP-191 (Signed Data Standard)

**Status: Demo ready, verify() unconfirmed**

EIP-191: off-chain message sign karna aur on-chain verify karna — `"\x19Ethereum Signed Message:\n32"` prefix se.

## Contract

`EIP191Verify.sol` — self-contained, Solidity 0.8.20, koi import nahi. 5 functions: `getMessageHash`, `getEthSignedMessageHash`, `splitSignature`, `recoverSigner`, `verify`.

## Test vector (corrected — pehle wale galat thay)

- Message: `"Hello Faizy"`
- `getMessageHash` = `0x7828bafb3bd214fee07cdfbc89ad59953c99f11e57ba73c138ec4bfda080c88a`
- `getEthSignedMessageHash` = `0x56675bcb485879a0fd45d27e22f47dc9ad1923261e3ab5615d4042d68252d3b6`
- Signature = `0x6666a2085a74b64e03be7d266632c4c914c90c72189d4d4a8d7990bee44b39ba11bbf50fdeb401f2f6aa63d8a9cb77a3ad1d600bdf700a7198c35d6a2c6def881b` (v=27)
- Signer = `0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266` (Hardhat test account 0 — Remix VM only, kabhi real funds nahi)

**Rule: 32-byte message hash ko sign karo, text ko nahi** — Foundry: `vm.sign(privKey, ethSignedMessageHash)`. MetaMask `personal_sign` text sign karta hai aur is contract se verify nahi hoga.

**verify() = true — ABHI UNCONFIRMED hai.** Run kar ke result report karna hai.

Sir ko batane ke liye (2 lines): EIP-191 mein message ko hash kar ke Ethereum prefix lagate hain, phir private key se sign karte hain. Contract `ecrecover` se signer nikalta hai aur check karta hai ke wahi hai jo expected tha.
