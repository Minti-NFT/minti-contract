// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

contract MultiAsset is ERC1155, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => string) private _tokenURIs;

    event MintedTokenId(uint256);

    constructor() ERC1155("") {}

    function _setTokenURI(uint256 tokenId, string memory _tokenURI)
        internal
        virtual
    {
        _tokenURIs[tokenId] = _tokenURI;
    }

    function uri(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        string memory _tokenURI = _tokenURIs[tokenId];
        return _tokenURI;
    }

    function mint(address recipient, string memory _uri)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 id = _tokenIds.current();
        _mint(recipient, id, 1, "");
        _setTokenURI(id, _uri);

        emit MintedTokenId(id);

        return id;
    }

    function mintBatch(address recipient, string[] memory _uris)
        public
        returns (uint256[] memory)
    {
        uint256[] memory ids;
        uint256[] memory amounts;

        for (uint i = 0; i < _uris.length; i ++) {
            _tokenIds.increment();

            uint256 id = _tokenIds.current();
            _setTokenURI(id, _uris[i]);
            emit MintedTokenId(id);
            ids[i] = id;
            amounts[i] = 1;
        }
        _mintBatch(recipient, ids, amounts, "");

        return ids;
    }
}
