// script/uups-demo.js
// UUPS demo — Anvil par BoxV1 deploy, proxy se use, phir BoxV2 par upgrade
// Pehle: `forge build` chalao, alag terminal mein `anvil` chalao
// Note: OpenZeppelin upgradeable contracts install karne honge:
//   forge install OpenZeppelin/openzeppelin-contracts-upgradeable@v5.4.0
//   forge install OpenZeppelin/openzeppelin-contracts@v5.4.0
//   aur remappings.txt mein dono ki lines hon

const { ethers } = require("ethers");
const fs = require("fs");
const path = require("path");

async function main() {
  const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");
  const signer = await provider.getSigner(0);
  const owner = await signer.getAddress();

  const boxV1Artifact = JSON.parse(
    fs.readFileSync(path.join(__dirname, "../out/BoxV1.sol/BoxV1.json"), "utf8")
  );
  const boxV2Artifact = JSON.parse(
    fs.readFileSync(path.join(__dirname, "../out/BoxV2.sol/BoxV2.json"), "utf8")
  );
  const proxyArtifact = JSON.parse(
    fs.readFileSync(path.join(__dirname, "../out/ERC1967Proxy.sol/ERC1967Proxy.json"), "utf8")
  );

  // Step 1: BoxV1 implementation deploy karo
  const BoxV1Factory = new ethers.ContractFactory(boxV1Artifact.abi, boxV1Artifact.bytecode.object, signer);
  const boxV1Impl = await BoxV1Factory.deploy();
  await boxV1Impl.waitForDeployment();
  const boxV1Addr = await boxV1Impl.getAddress();
  console.log("BoxV1 implementation:", boxV1Addr);

  // Step 2: ERC1967Proxy deploy karo — initialize(42) ke saath
  const boxV1Interface = new ethers.Interface(boxV1Artifact.abi);
  const initData = boxV1Interface.encodeFunctionData("initialize", [42]);
  const ProxyFactory = new ethers.ContractFactory(proxyArtifact.abi, proxyArtifact.bytecode.object, signer);
  const proxy = await ProxyFactory.deploy(boxV1Addr, initData);
  await proxy.waitForDeployment();
  const proxyAddr = await proxy.getAddress();
  console.log("Proxy deployed:", proxyAddr);

  // Proxy ko BoxV1 ki tarah use karo
  const boxAsV1 = new ethers.Contract(proxyAddr, boxV1Artifact.abi, signer);
  console.log("Test 1 — Proxy number (after initialize):", (await boxAsV1.number()).toString(), "(expect 42)");

  // Test 2: setNumber(100) — proxy ke storage mein
  const tx1 = await boxAsV1.setNumber(100);
  await tx1.wait();
  console.log("Test 2 — Proxy number (after setNumber):", (await boxAsV1.number()).toString(), "(expect 100)");

  // Step 3: BoxV2 implementation deploy karo
  const BoxV2Factory = new ethers.ContractFactory(boxV2Artifact.abi, boxV2Artifact.bytecode.object, signer);
  const boxV2Impl = await BoxV2Factory.deploy();
  await boxV2Impl.waitForDeployment();
  const boxV2Addr = await boxV2Impl.getAddress();
  console.log("BoxV2 implementation:", boxV2Addr);

  // Step 4: Upgrade — proxy ko V2 par le jao (sirf owner kar sakta hai)
  const tx2 = await boxAsV1.upgradeToAndCall(boxV2Addr, "0x");
  await tx2.wait();
  console.log("Upgraded to BoxV2");

  // Proxy ko BoxV2 ki tarah use karo — address wahi, number wahi
  const boxAsV2 = new ethers.Contract(proxyAddr, boxV2Artifact.abi, signer);
  console.log("Test 3 — Proxy number (after upgrade):", (await boxAsV2.number()).toString(), "(expect 100 — state safe hai)");
  console.log("Test 3 — Proxy address:", proxyAddr, "(same as before — address nahi badla)");

  // Test 4: V2 ka naya function — increment()
  const tx3 = await boxAsV2.increment();
  await tx3.wait();
  console.log("Test 4 — Proxy number (after increment):", (await boxAsV2.number()).toString(), "(expect 101 — naya function kaam kar raha hai)");

  console.log("DONE — upgrade ho gaya, address aur data wahi rahe, naya function aa gaya.");
}

main().catch((err) => {
  console.error("ERROR:", err);
  process.exit(1);
});
