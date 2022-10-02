// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Soulbound is ERC1155, Ownable {
    uint public constant MALICIOUS = 0;

    // BDSM Tokens(Score): 0-100(Default: 50)
    uint public constant BD_B = 1;
    uint public constant BD_D = 2;
    uint public constant DS_D = 3;
    uint public constant DS_S = 4;
    uint public constant SM_S = 5;
    uint public constant SM_M = 6;

    event Soulbounded(uint256 indexed id, bool bounded);
    event Register(address indexed soul);

    mapping(uint => bool) private _soulbounds;

    constructor() ERC1155("") {
        _setSoulbound(MALICIOUS, true);
        _setSoulbound(BD_B, true);
        _setSoulbound(BD_D, true);
        _setSoulbound(DS_D, true);
        _setSoulbound(DS_S, true);
        _setSoulbound(SM_S, true);
        _setSoulbound(SM_M, true);
    }

    function register(address soul, uint[6] calldata bdsm_scores) external onlyOwner soulNotRegistered(soul) {
        _mint(soul, MALICIOUS, 1, "");
        _mint(soul, BD_B, bdsm_scores[0], "");
        _mint(soul, BD_D, bdsm_scores[1], "");
        _mint(soul, DS_D, bdsm_scores[2], "");
        _mint(soul, DS_S, bdsm_scores[3], "");
        _mint(soul, SM_S, bdsm_scores[4], "");
        _mint(soul, SM_M, bdsm_scores[5], "");

        emit Register(soul);
    }

    function isSoulbound(uint256 id) public view returns (bool) {
        return _soulbounds[id];
    }

    function _setSoulbound(uint id, bool soulbound) internal {
        require(_soulbounds[id] != soulbound, "Soulbound: Already Soulbound");
        _soulbounds[id] = soulbound;
        emit Soulbounded(id, soulbound);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint[] memory ids,
        uint[] memory amounts,
        bytes memory data
    ) internal virtual override {
        // _beforeTokenTransfer called on 
        // _safeTransferFrom, _safeBatchTransferFrom, _mint, _mintBatch, _burn, _burnBatch.
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
        for (uint i=0; i < ids.length; i++) {
            if (isSoulbound(ids[i])) {
                require(from == address(0) || to == address(0));
                // SBT only allows transfer via _mint, _burn.
            }
        }
    }

    function isRegistered(address soul) public view returns (bool) {
        return balanceOf(soul, BD_B) > 0;
    }

    modifier soulRegistered(address soul) {
        require(
            isRegistered(soul),
            "Soulbound: Soul should be register first."
        );
        _;
    }

    modifier soulNotRegistered(address soul) {
        require(
            !isRegistered(soul),
            "Soulbound: Soul is already registered."
        );
        _;
    }
}