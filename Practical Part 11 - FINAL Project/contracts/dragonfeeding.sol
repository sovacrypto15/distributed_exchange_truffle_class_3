pragma solidity ^0.4.19;

import "./dragonlair.sol";

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract DragonFeeding is DragonLair {

  KittyInterface kittyContract;

  modifier onlyOwnerOf(uint _DragonId) {
    require(msg.sender == DragonToOwner[_DragonId]);
    _;
  }

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Dragon storage _Dragon) internal {
    _Dragon.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Dragon storage _Dragon) internal view returns (bool) {
      return (_Dragon.readyTime <= now);
  }

  function feedAndMultiply(uint _DragonId, uint _targetDna, string _species) internal onlyOwnerOf(_DragonId) {
    Dragon storage myDragon = Dragons[_DragonId];
    require(_isReady(myDragon));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myDragon.dna + _targetDna) / 2;
    if (keccak256(_species) == keccak256("kitty")) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createDragon("NoName", newDna);
    _triggerCooldown(myDragon);
  }

  function feedOnKitty(uint _DragonId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_DragonId, kittyDna, "kitty");
  }
}
