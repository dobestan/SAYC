// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


import "./Soulbound.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Manager is Ownable {
    address public soulbound;

    event MatchRequest(address indexed soul);
    event MatchResponse(address indexed soul, address[] souls);
    event Matched(address indexed soul0, address indexed soul1);

    struct Match {
        address soul0;
        address soul1;
        // TODO: escrow functionality(ex, isOkay?)
    }

    Match[] public matches;

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

    function _createMatch(address soulA, address soulB) public {
        (address soul0, address soul1) = _asOrderedAddresses(soulA, soulB);
        Match memory createdMatch = Match(soul0, soul1);
        matches.push(createdMatch);

        emit Matched(soul0, soul1);
        emit Matched(soul1, soul0);
    }

    function _asOrderedAddresses(address accountA, address accountB) public pure returns (address account0, address account1) {
        // account0/account1 is Ordered
        // accountA/accountB is Unordered
        return accountA < accountB ? (accountA, accountB) : (accountB, accountA);
    }
}
