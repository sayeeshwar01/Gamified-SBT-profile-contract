// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

contract MyNFT is ERC721URIStorage, Ownable, ERC721Enumerable{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // mapping(address => uint256[]) private _ownedTokens;
    mapping (uint256 => string) private _tokenURIs;

    constructor() public ERC721("MyNFT", "SBT") {}

    function mintNFT(address recipient, string memory meta)
        public onlyOwner
        returns (uint256)
    {
        if(ERC721.balanceOf(recipient)<1) {
            _tokenIds.increment();

            uint256 newItemId = _tokenIds.current();
            _mint(recipient, newItemId);
            _setTokenURI(newItemId, meta);
            _tokenURIs[newItemId] = meta;

            return newItemId;
        }
        
    }

    function _beforeTokenTransfer(
    address from, 
    address to, 
    uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) virtual {
    require(from == address(0), "Err: token transfer is BLOCKED"); 
    super._beforeTokenTransfer(from, to, tokenId);  
    }

    function upgrade(uint256 tokenId, string memory meta) public onlyOwner 
    {
        _setTokenURI(tokenId, meta);
        _tokenURIs[tokenId] = meta;
    }

    function getTokenIds(address owner) public view returns (uint[] memory) 
    {
        uint [] memory _tokensOfOwner = new uint[] (ERC721.balanceOf(owner));
        uint i;
        for(i=0;i<ERC721.balanceOf(owner);i++) {
            _tokensOfOwner[i] = ERC721Enumerable.tokenOfOwnerByIndex(owner,i);
        }
        // require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
        return (_tokensOfOwner);
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721URIStorage, ERC721) {
        _burn(tokenId);
    }
    
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool){

    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721,  ERC721URIStorage) returns (string memory) {
        string memory _tokenURI = _tokenURIs[tokenId];
        return _tokenURI;
    }


}