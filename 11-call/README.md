# Assignment 11 — call() (Low-Level Call)

**Status: DONE — run ho gaya (2026-11-28), teeno tests pass**

`call()` low-level function hai — kisi bhi contract ko call karo, ETH bhi bhej sakte ho, aur koi bhi data bhej sakte ho. Return karta hai `(bool success, bytes memory data)`.

## Contracts

- `Receiver.sol` — `number`, `message`, `setNumber`, `setMessage`, `receive() payable`
- `CallDemo.sol` — `sendEth` (ETH bhejta hai), `callSetNumber` (42 set karta hai), `callSetMessage` ("Hello" set karta hai)

## Run karna

1. `forge build` (foundry-signing project mein)
2. Alag terminal mein `anvil`
3. `node script/call-demo.js` (ya `node.exe` WSL mein)

**Expected output:**
- Test 1 — Receiver balance: 0.1 ETH
- Test 2 — Receiver number: 42
- Test 3 — Receiver message: Hello

## Result (2026-11-28, anvil chain 31337)

- Receiver: 0x5FbDB2315678afecb367f032d93F642f64180aa3
- CallDemo: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
- Test 1 — Receiver balance: 0.1 ETH ✅
- Test 2 — Receiver number: 42 ✅
- Test 3 — Receiver message: Hello ✅

Sir ko batane ke liye (2 lines): `call()` se hum kisi bhi contract ka function call kar sakte hain aur saath ETH bhi bhej sakte hain — ye low-level hai, is liye success check karna zaroori hai. Demo mein CallDemo ne Receiver ko ETH bheja aur us ka number aur message set kiya.
