const hre = require("hardhat");
const faker = require("@faker-js/faker");


async function main() {
    const signers = await ethers.getSigners();
    const deployed = await hre.deployments.all();

    const Manager = await hre.ethers.getContractFactory("Manager");
    const manager = await Manager.attach(deployed.Manager.address);

    const Soulbound = await hre.ethers.getContractFactory("Soulbound");
    const soulbound = await Soulbound.attach(await manager.soulbound());

    signers.forEach(async (signer) => {
        const managerWithSigner = await manager.connect(signer);
        await managerWithSigner.requestMatch();
    });
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
