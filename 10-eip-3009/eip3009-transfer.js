// script/eip3009-transfer.js
// EIP-3009: Transfer With Authorization — Sepolia USDC
// Signer zero gas, relayer gas deta hai.

require("dotenv").config();
const { ethers } = require("ethers");

const USDC = "0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238";
const USDC_ABI = [
  "function balanceOf(address) view returns (uint256)",
  "function transferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce,uint8 v,bytes32 r,bytes32 s)",
];

async function main() {
  const provider = new ethers.JsonRpcProvider(process.env.SEPOLIA_RPC_URL);
  const holder = new ethers.Wallet(process.env.HOLDER_PRIVATE_KEY, provider);
  const relayer = new ethers.Wallet(process.env.RELAYER_PRIVATE_KEY, provider);

  const usdc = new ethers.Contract(USDC, USDC_ABI, provider);

  const to = "0x115b46762d3f6C8257886971a8aA4FBDAA5419b8"; // Account 1
  const value = 1000000n; // 1 USDC (6 decimals)

  const now = Math.floor(Date.now() / 1000);
  const validAfter = 0;
  const validBefore = now + 3600; // 1 hour
  const nonce = ethers.hexlify(ethers.randomBytes(32));

  const domain = {
    name: "USDC",
    version: "2",
    chainId: 11155111,
    verifyingContract: USDC,
  };

  const types = {
    TransferWithAuthorization: [
      { name: "from", type: "address" },
      { name: "to", type: "address" },
      { name: "value", type: "uint256" },
      { name: "validAfter", type: "uint256" },
      { name: "validBefore", type: "uint256" },
      { name: "nonce", type: "bytes32" },
    ],
  };

  const message = { from: holder.address, to, value, validAfter, validBefore, nonce };

  console.log("Holder:", holder.address);
  console.log("Relayer:", relayer.address);
  console.log("Holder USDC pehle:", ethers.formatUnits(await usdc.balanceOf(holder.address), 6));
  console.log("To USDC pehle:", ethers.formatUnits(await usdc.balanceOf(to), 6));

  // Holder sign karta hai (off-chain, zero gas)
  const signature = await holder.signTypedData(domain, types, message);
  const { v, r, s } = ethers.Signature.from(signature);
  console.log("Signature mil gayi — holder ne zero gas diya.");

  // Relayer submit karta hai (gas relayer deta hai)
  const usdcRelayer = usdc.connect(relayer);
  const tx = await usdcRelayer.transferWithAuthorization(
    holder.address, to, value, validAfter, validBefore, nonce, v, r, s
  );
  console.log("Tx bheji:", tx.hash);
  await tx.wait();
  console.log("Tx confirm ho gayi.");

  console.log("Holder USDC baad mein:", ethers.formatUnits(await usdc.balanceOf(holder.address), 6));
  console.log("To USDC baad mein:", ethers.formatUnits(await usdc.balanceOf(to), 6));
  console.log("DONE — signer ne zero gas diya, relayer ne gas diya.");
}

main().catch((err) => {
  console.error("ERROR:", err);
  process.exit(1);
});
