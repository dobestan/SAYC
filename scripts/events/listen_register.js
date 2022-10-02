const hre = require("hardhat");
const faker = require("@faker-js/faker");


async function main() {
    const signers = await ethers.getSigners();
    const deployed = await hre.deployments.all();

    const Manager = await hre.ethers.getContractFactory("Manager");
    const manager = await Manager.attach(deployed.Manager.address);

    const Soulbound = await hre.ethers.getContractFactory("Soulbound");
    const soulbound = await Soulbound.attach(await manager.soulbound());

    console.log("[Event Listening] Soulbound:Register");
    soulbound.on("Register", (soul) => {
        console.log(`[Event emitted] Soulbound:Register(${soul})`);
    });
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
