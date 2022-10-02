const hre = require("hardhat");


async function main() {
    const signers = await ethers.getSigners();
    const deployed = await hre.deployments.all();

    const Manager = await hre.ethers.getContractFactory("Manager");
    const manager = await Manager.attach(deployed.Manager.address);

    const Soulbound = await hre.ethers.getContractFactory("Soulbound");
    const soulbound = await Soulbound.attach(await manager.soulbound());

    const getSouls = async () => {
        const filterRegister = soulbound.filters.Register(null);
        const registerEvents = await soulbound.queryFilter(filterRegister);
        const souls = registerEvents.map(event => event.args.soul);
        return souls;
    }

    console.log("[Event Listening] Manager:MatchRequest");
    manager.on("MatchRequest", async (soul) => {
        console.log(`[Event emitted] Manager:MatchRequest(${soul})`);
        const souls = await getSouls();
        await manager.requestMatchCallback(soul, souls);
    });

    console.log("[Event Listening] Manager:MatchResponse");
    manager.on("MatchResponse", (soul, souls) => {
        console.log(`[Event emitted] Manager:MatchResponse(${soul}, [${souls}])`);
    });
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
