const hre = require("hardhat");


async function main() {
    const signers = await ethers.getSigners();
    const deployed = await hre.deployments.all();

    const Manager = await hre.ethers.getContractFactory("Manager");
    const manager = await Manager.attach(deployed.Manager.address);

    const Soulbound = await hre.ethers.getContractFactory("Soulbound");
    const soulbound = await Soulbound.attach(await manager.soulbound());

    // Query Historic Events
    // https://docs.ethers.io/v5/getting-started/#getting-started--history
    const filterRegister = soulbound.filters.Register(null);
    const registerEvents = await soulbound.queryFilter(filterRegister);
    const souls = registerEvents.map(event => event.args.soul);

    console.log(`Total Registered Users: ${souls.length}`);

    souls.forEach(async (soul) => {
        const scores = await soulbound.getScores(soul);
        console.log(`Soul ${soul} Score is [${scores}]`);
    });
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
