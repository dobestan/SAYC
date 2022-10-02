const hre = require("hardhat");


async function main() {
    const signers = await ethers.getSigners();
    const deployed = await hre.deployments.all();

    const Manager = await hre.ethers.getContractFactory("Manager");
    const manager = await Manager.attach(deployed.Manager.address);

    console.log("[Event Listening] Manager:MatchRequest");
    manager.on("MatchRequest", (soul) => {
        console.log(`[Event emitted] Manager:MatchRequest(${soul})`);
    });
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
