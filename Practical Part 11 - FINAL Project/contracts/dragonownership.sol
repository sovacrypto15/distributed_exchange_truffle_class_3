pragma solidity ^0.4.19;

import "./dragonattack.sol";
import "./erc721.sol";
import "./safemath.sol";

contract DragonOwnership is DragonAttack, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) DragonApprovals;

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerDragonCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return DragonToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerDragonCount[_to] = ownerDragonCount[_to].add(1);
    ownerDragonCount[msg.sender] = ownerDragonCount[msg.sender].sub(1);
    DragonToOwner[_tokenId] = _to;
    Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    DragonApprovals[_tokenId] = _to;
    Approval(msg.sender, _to, _tokenId);
  }

  function takeOwnership(uint256 _tokenId) public {
    require(DragonApprovals[_tokenId] == msg.sender);
    address owner = ownerOf(_tokenId);
    _transfer(owner, msg.sender, _tokenId);
  }
}
