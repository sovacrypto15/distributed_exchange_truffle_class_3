pragma solidity ^0.4.19;

import "./dragonhelper.sol";

contract DragonAttack is DragonHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }

  function attack(uint _DragonId, uint _targetId) external onlyOwnerOf(_DragonId) {
    Dragon storage myDragon = Dragons[_DragonId];
    Dragon storage enemyDragon = Dragons[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      myDragon.winCount++;
      myDragon.level++;
      enemyDragon.lossCount++;
      feedAndMultiply(_DragonId, enemyDragon.dna, "Dragon");
    } else {
      myDragon.lossCount++;
      enemyDragon.winCount++;
      _triggerCooldown(myDragon);
    }
  }
}
