# Assignment 3 — Fund Me Contract

**Status: DONE — Sepolia deployed + verified**

Crowdfunding contract: log ETH bhejte hain (minimum USD value, Chainlink price feed se), owner withdraw karta hai.

- **Deployed (Sepolia):** `0xc2553fc62aeDa1159Aa7b1606B1Ca0111700C4Bb` (block 12139944)
- **Verified:** Sourcify + Blockscout
- **Price feed:** Sepolia Chainlink ETH/USD `0x694AA1769357215DE4F77645D6Fb77aD6dCa06f` (constructor mein hardcoded — is liye Remix VM par nahi chalta, sirf Sepolia par)
- **Test:** Fund SUCCEEDED (Account 2, 0.01 Sepolia ETH); withdraw SUCCEEDED (dusri try mein — pehli dafa Value box mein 0.01 ETH reh gaya tha, withdraw() payable nahi hai)

**Review se pehle:** `forge test` dobara chalana hai.

**Code:** ye contract Patrick Collins ke course (Cyfrin Updraft, Section 4) se hai — `foundry-fund-me` project mein hai (`~/foundry-fund-me` laptop par). Is folder mein copy karna baaki hai.

Sir ko batane ke liye (2 lines): FundMe ek crowdfunding contract hai — log ETH bhejte hain, Chainlink price feed check karta hai ke minimum USD value poori hai ya nahi. Sirf owner withdraw kar sakta hai, aur withdraw ke waqt Value box khaali hona chahiye.
