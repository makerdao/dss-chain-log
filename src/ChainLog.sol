pragma solidity ^0.6.7;

contract ChainLog {

    event Rely(address usr);
    event Deny(address usr);
    event UpdateVersion(string version);
    event UpdateSha256sum(string sha256sum);
    event UpdateIPFS(string ipfs);
    event UpdateAddress(string key, address addr);

    // --- Auth ---
    mapping (address => uint) public wards;
    function rely(address usr) external auth { wards[usr] = 1; emit Rely(usr); }
    function deny(address usr) external auth { wards[usr] = 0; emit Deny(usr); }
    modifier auth {
        require(wards[msg.sender] == 1, "ChainLog/not-authorized");
        _;
    }

    struct Location {
        uint256  pos;
        address  addr;
    }

    mapping (string => Location) location;
    string[] locations;

    string public version;
    string public sha256sum;
    string public ipfs;

    constructor() public {
        wards[msg.sender] = 1;
        setVersion("0.0.0");
        setAddress("CHANGELOG", address(this));        
    }

    function setVersion(string memory _version) public auth {
        version = _version;
        emit UpdateVersion(_version);
    }

    function setSha256sum(string memory _sha256sum) public auth {
        sha256sum = _sha256sum;
        emit UpdateSha256sum(_sha256sum);
    }

    function setIPFS(string memory _ipfs) public auth {
        ipfs = _ipfs;
        emit UpdateIPFS(_ipfs);
    }

    function setAddress(string memory _key, address _addr) public auth {
        if (location[_key].addr == address(0)) {       // Key does not exist
            _addAddress(_key, _addr);
        } else if (_addr == address(0)) {              // Remove zero address
            _removeAddress(_key);
        } else {                                       // Update existing key
            _updateAddress(_key, _addr);
        }
        emit UpdateAddress(_key, _addr);
    }

    function count() public view returns (uint256) {
        return locations.length;
    }

    // Returns the key and address of an item in the changelog array (for enumeration)
    function get(uint256 index) public view returns (string memory, address) {
        return (locations[index], location[locations[index]].addr);
    }

    function getAddress(string memory _key) public view returns (address addr) {
        addr = location[_key].addr;
        require(addr != address(0), "dss-chain-log/invalid-key");
    }

    function _addAddress(string memory _key, address _addr) internal {
        locations.push(_key);
        location[locations[locations.length - 1]] = Location(
            locations.length - 1,
            _addr
        );
    }

    function _updateAddress(string memory _key, address _addr) internal {
        location[_key].addr = _addr;
    }

    function _removeAddress(string memory _key) internal {
        uint256 _index = location[_key].pos;                     // Get pos in array
        string memory _move  = locations[locations.length - 1];  // Get last location
        locations[_index] = _move;                               // Replace
        location[_move].pos = _index;                            // Update array pos
        locations.pop();                                         // Trim last location
        delete location[_key];                                   // Delete struct data
    }
}
