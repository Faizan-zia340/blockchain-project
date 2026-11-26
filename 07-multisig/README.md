# Assignment 7 — Multisignature Wallet

**Status: Remix version PASSED; Sepolia deploy pending**

M-of-N wallet — transaction tab execute hoti hai jab threshold owners confirm kar dein.

## SimpleMultiSigWallet (Remix VM)

- **Deployed (Remix VM):** `0xEf9f1ACE83dfbB8f559Da621f4aEA72C6EB10eBf`
- **Owners:** VM accounts Owner 1 `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`, Owner 2 `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2`, Owner 3 `0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db`
- **Threshold:** 2-of-3
- **ETH TEST PASSED:** wallet ko 1 ETH fund kiya → tx #0 (0.5 ETH → recipient) Owner 2 + Owner 3 ne confirm kiya → execute ✅ — 0.5 ETH gaya, wallet mein 0.5 ETH bacha.
- **TOKEN TEST:** TestToken `0x688c0611a5691B7c1F09a694bf4ADfb456a58Cf7` (1000 TEST mint hue Owner 1 ko, 100 TEST wallet mein). tx #2 execute hua lekin sirf **0.1953125 TEST** gaye, 50 nahi — calldata mein 1 byte zyada tha. **FIX PENDING:** tx #3 Python-verified calldata (136 chars) se 50 TEST bhejna hai.
- **Test recipient:** `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB` (0.1953125 TEST hai)
- **Wallet balance:** 0.5 ETH + 99.8046875 TEST

## Safe (Sepolia)

- **PENDING:** app.safe.global par "Raffle Multi-Sig" banana hai — owners Account 1, 2, 3; threshold 2-of-3. Safe address abhi nahi mila.

**Code:** SimpleMultiSigWallet aur TestToken laptop par hain — is folder mein copy karna baaki hai.

**Notes:**
- Remix **Value** field calls ke beech persist karta hai — submit/confirm/execute se pehle 0 kar do, warna revert.
- `submitTransaction` submitter ko auto-confirm nahi karta.
- Token send: to = token contract, value = 0, data = encoded `transfer(recipient, amount)`.
- Calldata kabhi haath se nahi likhna — Python se verify karo.

Sir ko batane ke liye (2 lines): Multi-sig wallet mein aik transaction tabhi execute hoti hai jab 2-of-3 owners confirm kar dein. ETH test pass ho gaya, token test mein amount galat gaya tha (calldata ki ghalti) — fix pending hai.
