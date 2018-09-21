pragma solidity ^0.4.19;

import "./dragonfeeding.sol";

contract DragonHelper is DragonFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _DragonId) {
    require(Dragons[_DragonId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _DragonId) external payable {
    require(msg.value == levelUpFee);
    Dragons[_DragonId].level++;
  }

  function changeName(uint _DragonId, string _newName) external aboveLevel(2, _DragonId) onlyOwnerOf(_DragonId) {
    Dragons[_DragonId].name = _newName;
  }

  function changeDna(uint _DragonId, uint _newDna) external aboveLevel(20, _DragonId) onlyOwnerOf(_DragonId) {
    Dragons[_DragonId].dna = _newDna;
  }

  function getDragonsByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerDragonCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < Dragons.length; i++) {
      if (DragonToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
