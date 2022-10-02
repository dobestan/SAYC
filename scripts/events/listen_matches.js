const hre = require("hardhat");


async function main() {
    const signers = await ethers.getSigners();
    const deployed = await hre.deployments.all();

    const Manager = await hre.ethers.getContractFactory("Manager");
    const manager = await Manager.attach(deployed.Manager.address);

    console.log("[Event Listening] Manager:Matched");
    manager.on("Matched", (soul0, soul1) => {
        console.log(`[Event emitted] Manager:Matched(${soul0}, ${soul1})`);
    });
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
