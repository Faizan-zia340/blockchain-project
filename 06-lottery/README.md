# Assignment 6 — Lottery Contract

**Status: DONE — 4 raffles fulfilled; 4-player redraw PARKED**

Chainlink VRF v2.5 lottery — player entry fee deta hai, VRF random number deta hai, contract winner chunta hai.

## ETH Raffles

- **Raffle 1:** `0x1dee05c688487B4aaBB0D469D448CEb3dE24C7f9` (entry 0.01 ETH)
- **Raffle 2:** `0x947841805b731De3cF73616581597a635dF79350` (entry 0.01 ETH)
- Dono fulfilled — winner Account 2, state OPEN, reusable.

## USDC Raffles

- **USDCRaffle v1:** `0xF30A52Ee91690bcEE861F26Bfd4ef43c8A99D74c` (entry 3 USDC, callbackGasLimit 500,000)
- **USDCRaffle v2:** `0xb774ca39F65182bb79ba43ddD4D9c1D5482CaC4E` (entry 3 USDC, callbackGasLimit 200,000)
- Dono fulfilled — winner Account 2, Account 2 USDC wapas 20.0.
- **Sepolia USDC:** `0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238` (6 decimals; entry fee 3 USDC = 3,000,000)

## VRF

- **Subscription:** `0x79375454fd5edd09e053a57345f2ecc4752d146b5b9f02dace1c46b02ad172e0` (owner Account 2; balance ~75 LINK)
- **Coordinator:** `0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B`
- **Gas lane:** `0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae`
- **Note:** callbackGasLimit 200,000 se neeche mat karo (callback ko ~110–150k gas chahiye; kam hua to fulfillment fail + LINK phir bhi charge hota hai).
- **Automation:** Chainlink Automation site inaccessible — MANUAL `performUpkeep` use hota hai.

**Code:** `foundry-smart-contract-lottery-cu` (finished clone, `forge test` 16/16 pass) aur `foundry-usdc-raffle` laptop par `D:\Bootcamp\foundry\` mein hain — is folder mein copy karna baaki hai.

Sir ko batane ke liye (2 lines): Lottery mein player fee de kar enter karta hai, Chainlink VRF random number deta hai, contract us se winner chunta hai aur prize bhejta hai. ETH aur USDC dono versions live hain aur fulfill ho chuke hain.
