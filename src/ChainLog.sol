pragma solidity ^0.6.7;

contract ChainLog {

    event Rely(address usr);
    event Deny(address usr);
    event Update(bytes32 key, address addr);

    // --- Auth ---
    mapping (address => uint) public wards;
    function rely(address usr) external auth { wards[usr] = 1; emit Rely(usr); }
    function deny(address usr) external auth { wards[usr] = 0; emit Deny(usr); }
    modifier auth {
        require(wards[msg.sender] == 1, "ChainLog/not-authorized");
        _;
    }

    bytes32 public version;

    mapping (bytes32 => address) public addr;

    constructor() public {
        version = bytes32("0.0.0");
        setAddress("CHANGELOG", address(this));
        wards[msg.sender] = 1;
    }

    function setVersion(bytes32 _version) public auth {
        version = _version;
    }

    function setAddress(bytes32 _key, address _addr) public auth {
        addr[_key] = _addr;
    }
}
