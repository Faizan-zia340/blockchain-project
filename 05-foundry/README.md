# Assignment 5 — Foundry

**Status: DONE**

Foundry environment, testing, deployment — forge / cast / anvil.

- `forge init`, `forge build`, `forge test` — sab pass
- Chainlink Brownie Contracts v1.1.1, OpenZeppelin v5.7.0, forge-std v1.17.0
- Deploy pattern: `forge script script/DeployX.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast`
- WSL quirks: `forge`/`cast` na mile to `export PATH="$PATH:/home/faizan/.foundry/bin"`; sessions aksar `/mnt/c/Windows/system32` se shuru hoti hain.

Sir ko batane ke liye (2 lines): Foundry Solidity ke liye fast toolkit hai — forge se build/test/deploy, cast se chain par read/write, anvil se local blockchain. Maine is se lottery aur USDC raffle deploy kiye.
