require("@nomicfoundation/hardhat-toolbox");
require('hardhat-deploy');


module.exports = {
    solidity: "0.8.17",
    namedAccounts: {
        deployer: 0,
    },
    defaultNetwork: "localhost",  // defaults to "hardhat"
    networks: {
        ganache: {
            url: "http://127.0.0.1:7545",
            chainId: 1337,
        }
    }
};
