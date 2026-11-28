# SMIT Blockchain Assignments — Review Prep

Final-year BSCS student, FUUAST Karachi. SMIT course: **Blockchain & Smart Contract Development**.

Har assignment ka kuch dikhane layak hai: deployed contract, passing test, ya live demo.

## Assignments (13)

| # | Assignment | Status |
|---|-----------|--------|
| 01 | Blockchain Fundamentals (Blockchain, Bitcoin, Ethereum) | DONE — theory |
| 02 | Solidity Programming (Fundamentals, Smart Contract Development) | DONE |
| 03 | Fund Me Contract | DONE — Sepolia deployed + verified |
| 04 | ERC Standards | ERC20 DONE; Kirdar NFT buy flow mein issues (v2 bug, v3 dead) — theek karna hai |
| 05 | Foundry (environment, testing, deployment) | DONE |
| 06 | Lottery Contract | DONE — 4 raffles fulfilled; 4-player redraw PARKED |
| 07 | Multisignature Wallet | Remix version PASSED; Sepolia deploy pending |
| 08 | EIP-191 (Signed Data Standard) | Demo ready |
| 09 | EIP-712 (Typed Structured Data Signing) | — |
| 10 | EIP-3009 (Transfer With Authorization) | DONE — JS script se Sepolia USDC transfer, signer ne zero gas diya |
| 11 | call() (Low-Level Call) | Demo ready, run karna baaki |
| 12 | delegatecall() | — |
| 13 | UUPS Proxy (Upgradeable contract) | — |

## Setup

- **Network:** Sepolia testnet
- **Sepolia RPC:** `https://ethereum-sepolia-rpc.publicnode.com`
- **Sepolia USDC:** `0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238` (6 decimals; EIP-712 domain name "USDC", version "2")
- **Foundry:** forge / cast / anvil
- **Node:** v24 (ethers v6)
- **Chainlink VRF:** v2.5 (subscription `0x79375454fd5edd09e053a57345f2ecc4752d146b5b9f02dace1c46b02ad172e0`)

## Accounts (MetaMask, Sepolia)

- **Account 1:** `0x115b46762d3f6C8257886971a8aA4FBDAA5419b8`
- **Account 2 (deployer/owner):** `0xEd047aFAdEa547Ba3c78fE066840E55798E578f8`
- **Account 3:** `0x2F676…8ECaE`

## .env

`.env.example` dekho. Asli keys sirf `.env` mein dalo — **kabhi chat mein ya GitHub par nahi**.

- `SEPOLIA_RPC_URL` — Sepolia RPC
- `HOLDER_PRIVATE_KEY` — jis account ke paas USDC hai (Account 2)
- `RELAYER_PRIVATE_KEY` — jo gas dega (Account 1 ya 3)
- `PRIVATE_KEY` — deploy karne wale account ki key (Account 2)

Private key **64 hex characters** ki hoti hai (0x ke saath 66). **42 characters wali cheez address hai, private key nahi** — MetaMask se export karo: 3 dots → Account details → Show private key.

## Notes

- Remix (new UI v2.6.14): koi "At Address" button nahi — Deploy panel → **Deployed Contracts** tab → **+ Add Contract** → address paste karo → **Add**.
- WSL mein `node` nahi milta to `node.exe` use karo (Windows Node v24.16.0).
- `forge`/`cast` na mile to pehle: `export PATH="$PATH:/home/faizan/.foundry/bin"`
- Private keys kabhi chat mein paste nahi karni — sirf terminal ya `.env` file mein.
