# Assignment 9 — EIP-712 (Typed Structured Data Signing)

EIP-712: typed structured data sign karna. EIP-191 se farq — yahan sirf text nahi, aik **struct** (jaise Mail: from, to, content) sign hota hai. Domain (name, version, chainId, contract address) + struct hash se digest banta hai, us par signature hoti hai. Wallet mein user ko saaf dikhta hai ke wo kya sign kar raha hai.

## Files

- `EIP712Verify.sol` — OpenZeppelin EIP712 + ECDSA; `Mail` struct verify karta hai.
- `eip712-demo.js` — Anvil par deploy + sign + verify karta hai (ethers v6).

## Setup (aik dafa)

OpenZeppelin contracts install karo:

```
forge install OpenZeppelin/openzeppelin-contracts@v5.4.0
```

`remappings.txt` mein ye line ho:

```
@openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/
```

## Run karna

1. `foundry-signing` mein `src/EIP712Verify.sol` copy karo, `script/eip712-demo.js` copy karo.
2. `forge build` chalao.
3. Alag terminal mein `anvil` chalao.
4. `node.exe script/eip712-demo.js` chalao.

## Expected output

- verify(sahi signature): **true**
- verify(ghalat content): **false**
- recoverSigner: **from wala address** (signer wapas milta hai)

## Samajhna

EIP-191 mein sirf aik text hash sign hota tha. EIP-712 mein **domain + struct** dono hash hote hain — is liye signature sirf is contract aur is chain par valid hoti hai (replay nahi ho sakti). Yehi standard USDC ke `transferWithAuthorization` (EIP-3009) mein use hota hai — wahan bhi typed data sign hota hai.

Sir ko batane ke liye (2 lines): EIP-712 mein data typed hota hai — har field ka naam aur type hota hai, is liye wallet mein saaf dikhta hai ke kya sign ho raha hai. Yehi standard EIP-3009 aur permit jaisi cheezon mein use hota hai.
