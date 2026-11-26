// script/call-demo.js
// call() demo — Anvil par Receiver + CallDemo deploy kar ke test karta hai
// Pehle: `forge build` chalao, alag terminal mein `anvil` chalao

const { ethers } = require("ethers");
const fs = require("fs");
const path = require("path");

async function main() {
  const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");
  const signer = await provider.getSigner(0);

  const receiverArtifact = JSON.parse(
    fs.readFileSync(path.join(__dirname, "../out/Receiver.sol/Receiver.json"), "utf8")
  );
  const callDemoArtifact = JSON.parse(
    fs.readFileSync(path.join(__dirname, "../out/CallDemo.sol/CallDemo.json"), "utf8")
  );

  const ReceiverFactory = new ethers.ContractFactory(receiverArtifact.abi, receiverArtifact.bytecode.object, signer);
  const receiver = await ReceiverFactory.deploy();
  await receiver.waitForDeployment();
  const receiverAddr = await receiver.getAddress();
  console.log("Receiver deployed:", receiverAddr);

  const CallDemoFactory = new ethers.ContractFactory(callDemoArtifact.abi, callDemoArtifact.bytecode.object, signer);
  const callDemo = await CallDemoFactory.deploy();
  await callDemo.waitForDeployment();
  console.log("CallDemo deployed:", await callDemo.getAddress());

  // Test 1: sendEth — 0.1 ETH
  const tx1 = await callDemo.sendEth(receiverAddr, { value: ethers.parseEther("0.1") });
  await tx1.wait();
  const bal = await provider.getBalance(receiverAddr);
  console.log("Test 1 — Receiver balance:", ethers.formatEther(bal), "ETH (expect 0.1)");

  // Test 2: callSetNumber — 42
  const tx2 = await callDemo.callSetNumber(receiverAddr, 42);
  await tx2.wait();
  console.log("Test 2 — Receiver number:", (await receiver.number()).toString(), "(expect 42)");

  // Test 3: callSetMessage — "Hello"
  const tx3 = await callDemo.callSetMessage(receiverAddr, "Hello");
  await tx3.wait();
  console.log("Test 3 — Receiver message:", await receiver.message(), '(expect "Hello")');

  console.log("DONE — teeno tests pass hone chahiye.");
}

main().catch((err) => {
  console.error("ERROR:", err);
  process.exit(1);
});
