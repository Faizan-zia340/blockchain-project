// script/delegatecall-demo.js
// delegatecall() demo — Anvil par Logic + Proxy deploy kar ke test karta hai
// Pehle: `forge build` chalao, alag terminal mein `anvil` chalao

const { ethers } = require("ethers");
const fs = require("fs");
const path = require("path");

async function main() {
  const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");
  const signer = await provider.getSigner(0);

  const logicArtifact = JSON.parse(
    fs.readFileSync(path.join(__dirname, "../out/Logic.sol/Logic.json"), "utf8")
  );
  const proxyArtifact = JSON.parse(
    fs.readFileSync(path.join(__dirname, "../out/Proxy.sol/Proxy.json"), "utf8")
  );

  const LogicFactory = new ethers.ContractFactory(logicArtifact.abi, logicArtifact.bytecode.object, signer);
  const logic = await LogicFactory.deploy();
  await logic.waitForDeployment();
  const logicAddr = await logic.getAddress();
  console.log("Logic deployed:", logicAddr);

  const ProxyFactory = new ethers.ContractFactory(proxyArtifact.abi, proxyArtifact.bytecode.object, signer);
  const proxy = await ProxyFactory.deploy(logicAddr);
  await proxy.waitForDeployment();
  const proxyAddr = await proxy.getAddress();
  console.log("Proxy deployed:", proxyAddr);

  // Test 1: proxy.setNumber(42) — number Proxy ke storage mein badle, Logic ke mein nahi
  const tx1 = await proxy.setNumber(42);
  await tx1.wait();
  console.log("Test 1 — Proxy number:", (await proxy.number()).toString(), "(expect 42)");
  console.log("Test 1 — Logic number:", (await logic.number()).toString(), "(expect 0)");

  // Test 2: proxy.setMessage("Hello") — message Proxy ke storage mein badle, Logic ke mein nahi
  const tx2 = await proxy.setMessage("Hello");
  await tx2.wait();
  console.log("Test 2 — Proxy message:", await proxy.message(), '(expect "Hello")');
  console.log("Test 2 — Logic message:", await logic.message(), '(expect "")');

  console.log("DONE — delegatecall ka matlab: code Logic ka, storage Proxy ki.");
}

main().catch((err) => {
  console.error("ERROR:", err);
  process.exit(1);
});
