# Assignment 10 — EIP-3009 (Transfer With Authorization)

**Status: DONE ✅ (2026-11-26)**

Token holder off-chain sign karta hai ke "mera USDC transfer kar do" — phir koi aur (relayer) wo signature on-chain submit karta hai. **Signer zero gas deta hai, relayer gas deta hai.** Yehi gasless transfer hai.

## Run result (2026-11-26 ~20:36 PKT)

- **Script:** `eip3009-transfer.js` (ethers v6, Sepolia)
- **Holder (signer):** Account 2 `0xEd047aFAdEa547Ba3c78fE066840E55798E578f8`
- **Relayer (gas dene wala):** Account 1 `0x115b46762d3f6C8257886971a8aA4FBDAA5419b8`
- **To:** Account 1
- **Amount:** 1 USDC
- **Holder USDC:** 40.0 → 39.0
- **Account 1 USDC:** 40.0 → 41.0
- **Tx:** `0x255e9ba11532d112f8f46d820fadec4ce52721cf40e104082b76af09994feac3` (confirmed)

## Kaise kaam karta hai

1. Holder message banata hai: from, to, value, validAfter, validBefore, nonce (random, aik dafa use hota hai)
2. Holder apni private key se EIP-712 typed data sign karta hai — off-chain, **free**
3. Relayer `transferWithAuthorization` call karta hai USDC contract par — **gas relayer deta hai**
4. Contract check karta hai: signature sahi? Nonce pehle use nahi hua? Time window mein hai? Sab theek ho to transfer kar deta hai

## Setup

- `.env` mein `HOLDER_PRIVATE_KEY` (Account 2) aur `RELAYER_PRIVATE_KEY` (Account 1 ya 3) — **64-character private keys**, 42-character addresses nahi.
- `npm install dotenv ethers` phir `node.exe script/eip3009-transfer.js` (WSL mein `node` nahi milta to `node.exe` use karo)

Sir ko batane ke liye (2 lines): EIP-3009 mein token holder aik signed permission deta hai aur relayer usay chain par submit karta hai — holder ko gas nahi dena parta. Maine Sepolia USDC se 1 USDC transfer kiya: signer ne zero gas diya, relayer ne gas diya.
