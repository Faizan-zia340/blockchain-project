# Assignment 12 — delegatecall()

`delegatecall()` `call()` jaisa hai, lekin farq ye hai: **code dusre contract ka chalta hai, lekin storage aur msg.sender CALLER ke hote hain**. Isi liye proxy contracts mein use hota hai.

## Files

- `Logic.sol` — implementation contract; `setNumber` aur `setMessage` rakhta hai.
- `Proxy.sol` — delegatecall se Logic ka code chalata hai; storage Proxy ki hoti hai.
- `delegatecall-demo.js` — Anvil par deploy + test karta hai (ethers v6).

## Run karna

1. `foundry-signing` mein `src/Logic.sol` aur `src/Proxy.sol` copy karo, `script/delegatecall-demo.js` copy karo.
2. `forge build` chalao.
3. Alag terminal mein `anvil` chalao.
4. `node.exe script/delegatecall-demo.js` chalao.

## Expected output

- Proxy number: **42**, Logic number: **0** (number Proxy ke storage mein badla, Logic ke mein nahi)
- Proxy message: **"Hello"**, Logic message: **""** (khali)

## Samajhna

Proxy ne `setNumber(42)` call kiya — code Logic ka chala, lekin number Proxy ke storage mein likha gaya. Logic ka apna number 0 hi raha. Yehi delegatecall hai: **code udhaar, storage apni**. Isi par UUPS proxy banta hai. Ghalat storage layout se storage corrupt ho sakti hai, is liye Proxy aur Logic ke shared slots (number, message) aik jaise rakhe hain.

Sir ko batane ke liye (2 lines): `delegatecall` mein dusre contract ka code chalta hai lekin storage hamari hoti hai — is liye proxy upgradeable contracts isi par bante hain. Ghalat use se storage corrupt ho sakti hai, is liye layout same rakhna zaroori hai.
