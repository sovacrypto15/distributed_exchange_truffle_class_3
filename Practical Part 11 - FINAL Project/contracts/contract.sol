pragma solidity ^0.4.19;

contract DragonLair {

    event NewDragon(uint DragonId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Dragon {
        string name;
        uint dna;
    }

    Dragon[] public Dragons;

    mapping (uint => address) public DragonToOwner;
    mapping (address => uint) ownerDragonCount;

    function _createDragon(string _name, uint _dna) private {
        uint id = Dragons.push(Dragon(_name, _dna)) - 1;
        DragonToOwner[id] = msg.sender;
        ownerDragonCount[msg.sender]++;
        NewDragon(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomDragon(string _name) public {
        require(ownerDragonCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createDragon(_name, randDna);
    }

}

contract DragonFeeding is DragonLair {
}
