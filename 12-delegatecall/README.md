# Assignment 12 — delegatecall()

**Status: NOT done**

`delegatecall()` `call()` jaisa hai, lekin farq ye hai: **code dusre contract ka chalta hai, lekin storage aur msg.sender CALLER ke hote hain**. Isi liye proxy contracts mein use hota hai.

**Next:** pehle samajhna hai, phir demo banana hai (Remix/Foundry, phir JS) — call() ke baad.

Sir ko batane ke liye (2 lines): `delegatecall` mein dusre contract ka code chalta hai lekin storage hamari hoti hai — is liye proxy upgradeable contracts isi par bante hain. Ghalat use se storage corrupt ho sakti hai, is liye layout same rakhna zaroori hai.
