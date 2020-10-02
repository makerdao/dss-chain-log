pragma solidity ^0.6.7;

contract ChainLog {

    event Rely(address usr);
    event Deny(address usr);
    event UpdateVersion(string version);
    event UpdateSha256sum(string sha256sum);
    event UpdateIPFS(string ipfs);
    event UpdateAddress(bytes32 key, address addr);
    event RemoveAddress(bytes32 key);

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

    mapping (bytes32 => Location) location;
    bytes32[] public locations;

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

    function setAddress(bytes32 _key, address _addr) public auth {
        if (count() > 0 && _key == locations[location[_key].pos]) {
            _updateAddress(_key, _addr);   // Key exists in locations
        } else {
            _addAddress(_key, _addr);      // Add key to locations
        }
        emit UpdateAddress(_key, _addr);
    }

    // Removes the key from the locations list()
    //   WARNING: To save the expense of shifting an array on-chain,
    //     this will replace the key to be deleted with the last key
    //     in the array, and can therefore result in keys being out
    //     of order. Use this only if you intend to reorder the list(),
    //     otherwise consider using `setAddress("KEY", address(0));`
    function removeAddress(bytes32 _key) public auth {
        _removeAddress(_key);
        emit RemoveAddress(_key);
    }

    function count() public view returns (uint256) {
        return locations.length;
    }

    // Returns the key and address of an item in the changelog array (for enumeration)
    function get(uint256 index) public view returns (bytes32, address) {
        return (locations[index], location[locations[index]].addr);
    }

    function list() public view returns (bytes32[] memory) {
        return locations;
    }

    function getAddress(bytes32 _key) public view returns (address addr) {
        addr = location[_key].addr;
        require(addr != address(0), "dss-chain-log/invalid-key");
    }

    function _addAddress(bytes32 _key, address _addr) internal {
        locations.push(_key);
        location[locations[locations.length - 1]] = Location(
            locations.length - 1,
            _addr
        );
    }

    function _updateAddress(bytes32 _key, address _addr) internal {
        require(locations[location[_key].pos] == _key, "dss-chain-log/invalid-key");
        location[_key].addr = _addr;
    }

    function _removeAddress(bytes32 _key) internal {
        require(locations[location[_key].pos] == _key, "dss-chain-log/invalid-key");
        uint256 _index = location[_key].pos;               // Get pos in array
        bytes32 _move  = locations[locations.length - 1];  // Get last location
        locations[_index] = _move;                         // Replace
        location[_move].pos = _index;                      // Update array pos
        locations.pop();                                   // Trim last location
        delete location[_key];                             // Delete struct data
    }
}
