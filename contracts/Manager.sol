// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


import "./Soulbound.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Manager is Ownable {
    address public soulbound;

    event MatchRequest(address soul);
    event MatchResponse(address soul, address[] souls);

    constructor() {
        soulbound = address(new Soulbound());
    }

    function register(uint[6] calldata bdsm_scores) public {
        Soulbound(soulbound).register(msg.sender, bdsm_scores);
    }

    function requestMatch() public {
        emit MatchRequest(msg.sender);
    }

    function requestMatchCallback(address soul, address[] calldata souls) public {
        _createMatch(soul, souls[0]);
        emit MatchResponse(soul, souls);
    }

    function _createMatch(address account1, address account2) public {
        // TODO
    }
}