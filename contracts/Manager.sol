// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


import "./Soulbound.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Manager is Ownable {
    address public soulbound;

    constructor() {
        soulbound = address(new Soulbound());
    }

    function register(uint[6] calldata bdsm_scores) public {
        Soulbound(soulbound).register(msg.sender, bdsm_scores);
    }
}