const express = require('express')
const { ethers  } = require("ethers");
const managerDeployments = require("../deployments/localhost/Manager.json");
const soulboundArtifacts = require("../artifacts/contracts/Soulbound.sol/Soulbound.json");

const app = express()
const port = 3000


app.get('/', async (req, res) => {
    const provider = new ethers.providers.JsonRpcProvider("http://127.0.0.1:8545");
    const signer = provider.getSigner();

    // Manager Contract
    const managerAddress = managerDeployments.address;
    const managerAbi = managerDeployments.abi;

    const managerContract = new ethers.Contract(
        managerAddress,
        managerAbi,
        provider,
    )

    // Soulbound Contract
    // Soulbound Contract is deployed via Manager contract, NOT manually deployed via hardhat-deploy.
    // Soulbound ABI, Address CANNOT be found in deployments folder which is automatically created by hardhat-deploy.
    const soulboundAddress = await managerContract.soulbound();
    const soulboundAbi = soulboundArtifacts.abi;
    const soulboundContract = new ethers.Contract(
        soulboundAddress,
        soulboundAbi,
        provider,
    )

    // Query Historic Events
    // https://docs.ethers.io/v5/getting-started/#getting-started--history
    const filterRegister = soulboundContract.filters.Register(null);
    const registerEvents = await soulboundContract.queryFilter(filterRegister);
    const souls = registerEvents.map(event => event.args.soul);

    res.send(souls);
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`);
})
