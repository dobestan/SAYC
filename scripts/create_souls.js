const hre = require("hardhat");
const faker = require("@faker-js/faker");


async function main() {
    const signers = await ethers.getSigners();
    const deployed = await hre.deployments.all();

    const Manager = await hre.ethers.getContractFactory("Manager");
    const manager = await Manager.attach(deployed.Manager.address);

    const Soulbound = await hre.ethers.getContractFactory("Soulbound");
    const soulbound = await Soulbound.attach(await manager.soulbound());

    const getRandomScore = () => {
        // Random BDSM Score Generator:
        // Output: [13, 7, 50, 3, 100, 97]
        return new Array(6).fill(undefined).map(x => faker.faker.datatype.number({min: 1, max: 100}));
    }

    signers.forEach(async (signer) => {
        const managerWithSigner = await manager.connect(signer);
        const randomScore = getRandomScore();
        await managerWithSigner.register(randomScore);
        console.log(`Registered ${signer.address} with ${randomScore}`);
    });
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
