# Assignment 4 — ERC Standards

**Status: ERC20 DONE; Kirdar NFT buy flow mein issues — theek karna hai**

## ERC20 — Faizy Token (FAIZY)

- **Contract:** FaizyToken.sol — OpenZeppelin ERC20, Solidity 0.8.20, OZ v5.0.2, Ownable
- **Supply:** 1,000,000 FAIZY, 18 decimals
- **Mint:** constructor mein nahi — alag `mint(address to, uint256 amount) public onlyOwner` function
- **Sepolia:** `0x32Df11F06766d12ed14159EaC18159dA6b64DDb4` (1,000,000 FAIZY Account 2 ko mint hue)
- **Note:** deploy ke waqt supply 0 hoti hai; admin baad mein mint karta hai.

**Code:** FaizyToken.sol laptop par hai — is folder mein copy karna baaki hai.

## ERC721 — Kirdar (Token-to-NFT)

3 contracts: ERC20 (Faizy Token reuse), ERC721 LearnERC721 (onlyOwner mint), TokenToNFT (5 FAIZY approve karo → 1 NFT mint hota hai).

- **Sepolia:** LearnERC721 `0x70F55B336856e005B5d7827241c0F8C554e3e8be`; TokenToNFT v2 `0x884467C2fd07a392ba5BE3c224dd18300Dc0b961`
- **Rate:** 100 FAIZY = 0.001 ETH (1 ETH = 100,000 FAIZY)
- **Known issues:** v2 `buyTokens` formula mein bug tha (×10^18 missing — Account 1 ko 100 FAIZY ki jagah 100 wei mile, 0.001 ETH shop mein stuck); v3 DEAD hai (galat transferOwnership se shop ne khud ko own kar liya); NFT ownership buggy shop `0x8844…` mein LOCKED hai.
- **Frontend test PASSED:** Account 1 ne character #1 (Man) khareeda — 100 → 95 FAIZY, "Mere NFTs" mein dikha.
- **Factory:** KirdarFactory design settled hai, VM test PASSED (factory `0x5A86858aA3b595FD6663c2296741eF4cd8BC4d01`); Sepolia deploy pending.

**Code:** Kirdar contracts laptop par `D:\Bootcamp\Kirdar` mein hain — is folder mein copy karna baaki hai.

Sir ko batane ke liye (2 lines): ERC20 fungible token hai (har token aik jaisa), ERC721 non-fungible hai (har NFT unique). Kirdar mein 5 FAIZY de kar 1 NFT milta hai — token approve karo, shop transferFrom karta hai, NFT mint hota hai.
