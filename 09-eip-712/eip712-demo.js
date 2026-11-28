// script/eip712-demo.js
// EIP-712 demo — Anvil par EIP712Verify deploy kar ke typed-data signature verify karta hai
// Pehle: `forge build` chalao, alag terminal mein `anvil` chalao
// Note: OpenZeppelin contracts install karne honge:
//   forge install OpenZeppelin/openzeppelin-contracts@v5.4.0
//   aur remappings.txt mein iski line ho

const { ethers } = require("ethers");
const fs = require("fs");
const path = require("path");

async function main() {
  const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");
  const signer = await provider.getSigner(0);
  const from = await signer.getAddress();
  const to = await provider.getSigner(1).then((s) => s.getAddress());
  const content = "Hello Faizy, EIP-712!";

  const artifact = JSON.parse(
    fs.readFileSync(path.join(__dirname, "../out/EIP712Verify.sol/EIP712Verify.json"), "utf8")
  );

  const Factory = new ethers.ContractFactory(artifact.abi, artifact.bytecode.object, signer);
  const verifier = await Factory.deploy();
  await verifier.waitForDeployment();
  const verifierAddr = await verifier.getAddress();
  console.log("EIP712Verify deployed:", verifierAddr);

  // Domain — contract ke constructor se match kare (name "FaizyMail", version "1")
  const domain = {
    name: "FaizyMail",
    version: "1",
    chainId: 31337,
    verifyingContract: verifierAddr,
  };
  const types = {
    Mail: [
      { name: "from", type: "address" },
      { name: "to", type: "address" },
      { name: "content", type: "string" },
    ],
  };
  const value = { from, to, content };

  // Test 1: sahi signature — verify() true hona chahiye
  const signature = await signer.signTypedData(domain, types, value);
  const sig = ethers.Signature.from(signature);
  console.log("Signature:", signature);
  const ok = await verifier.verify(from, to, content, sig.v, sig.r, sig.s);
  console.log("Test 1 — verify(sahi signature):", ok, "(expect true)");

  // Test 2: ghalat content — verify() false hona chahiye
  const wrong = await verifier.verify(from, to, "ghalat message", sig.v, sig.r, sig.s);
  console.log("Test 2 — verify(ghalat content):", wrong, "(expect false)");

  // Test 3: signer wapas nikalo
  const recovered = await verifier.recoverSigner(from, to, content, sig.v, sig.r, sig.s);
  console.log("Test 3 — recoverSigner:", recovered);
  console.log("Test 3 — from:", from, "(dono same hone chahiye)");

  console.log("DONE — EIP-712 typed-data signature verify ho gaya.");
}

main().catch((err) => {
  console.error("ERROR:", err);
  process.exit(1);
});
