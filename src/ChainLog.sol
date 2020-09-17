pragma solidity ^0.6.7;

contract ChainLog {

    event Rely(address usr);
    event Deny(address usr);
    event UpdateVersion(string version);
    event UpdateSha256sum(string sha256sum);
    event UpdateIPFS(string ipfs);
    event UpdateAddress(bytes32 key, address addr);

    // --- Auth ---
    mapping (address => uint) public wards;
    function rely(address usr) external auth { wards[usr] = 1; emit Rely(usr); }
    function deny(address usr) external auth { wards[usr] = 0; emit Deny(usr); }
    modifier auth {
        require(wards[msg.sender] == 1, "ChainLog/not-authorized");
        _;
    }

    string public version;
    string public sha256sum;
    string public ipfs;

    mapping (bytes32 => address) public addr;

    constructor() public {
        version = "0.0.0";
        addr["CHANGELOG"] = address(this);
        wards[msg.sender] = 1;
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
        addr[_key] = _addr;
        emit UpdateAddress(_key, _addr);
    }
}
