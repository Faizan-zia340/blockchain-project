# Assignment 13 — UUPS Proxy (Upgradeable contract)

UUPS (Universal Upgradeable Proxy Standard, EIP-1822): proxy contract user ke saamne hota hai, implementation contract peeche hota hai. Upgrade karne par implementation badal jata hai, proxy address aur storage wahi rehte hain.

## Files

- `BoxV1.sol` — V1 implementation; `number` + `setNumber`.
- `BoxV2.sol` — V2 implementation; V1 jaisa + naya function `increment`.
- `ERC1967ProxyImport.sol` — sirf import hai; `forge build` se ERC1967Proxy ka artifact banane ke liye.
- `uups-demo.js` — Anvil par deploy + upgrade + test karta hai (ethers v6).

## Setup (aik dafa)

OpenZeppelin upgradeable contracts install karo:

```
forge install OpenZeppelin/openzeppelin-contracts-upgradeable@v5.4.0
forge install OpenZeppelin/openzeppelin-contracts@v5.4.0
```

`remappings.txt` mein ye lines hon:

```
@openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/
@openzeppelin/contracts-upgradeable/=lib/openzeppelin-contracts-upgradeable/contracts/
```

## Run karna

1. `foundry-signing` mein `src/BoxV1.sol`, `src/BoxV2.sol`, `src/ERC1967ProxyImport.sol` copy karo, `script/uups-demo.js` copy karo.
2. `forge build` chalao.
3. Alag terminal mein `anvil` chalao.
4. `node.exe script/uups-demo.js` chalao.

## Expected output

- Proxy number (after initialize): **42**
- Proxy number (after setNumber): **100**
- Upgrade ke baad Proxy number: **100** (state safe hai — data nahi badla)
- Proxy address: **wahi** (upgrade ke baad bhi same address)
- Proxy number (after increment): **101** (V2 ka naya function kaam kar raha hai)

## Samajhna

User hamesha **proxy** se baat karta hai. Proxy `delegatecall` se implementation ka code chalata hai. Upgrade par sirf implementation badalta hai — proxy ka address aur uska storage (number = 100) wahi rehte hain. V2 mein `increment` naya hai, lekin purana data (100) safe hai. Isi liye upgradeable contracts mein storage layout same rakhna zaroori hai — naya variable sirf neeche (end par) add karo, beech mein nahi.

Sir ko batane ke liye (2 lines): UUPS proxy mein user proxy se baat karta hai, proxy delegatecall se implementation ka code chalata hai. Upgrade par sirf implementation badalta hai — address aur data wahi rehte hain.
