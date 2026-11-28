# Assignment 13 — UUPS Proxy (Upgradeable contract)

**Status: NOT done**

UUPS (Universal Upgradeable Proxy Standard, EIP-1822): proxy contract user ke saamne hota hai, implementation contract peeche hota hai. Upgrade karne par implementation badal jata hai, proxy address aur storage wahi rehte hain.

**Next:** deploy karo, phir upgrade kar ke dikhao — delegatecall() ke baad.

Sir ko batane ke liye (2 lines): UUPS proxy mein user proxy se baat karta hai, proxy delegatecall se implementation ka code chalata hai. Upgrade par sirf implementation badalta hai — address aur data wahi rehte hain.
