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
}