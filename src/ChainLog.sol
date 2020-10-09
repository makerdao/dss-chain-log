
// SPDX-License-Identifier: AGPL-3.0-or-later

/// ChainLog.sol - An on-chain governance-managed contract registry

// Copyright (C) 2020 Maker Ecosystem Growth Holdings, INC.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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

    bytes32[] public keys;

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
        if (count() > 0 && _key == keys[location[_key].pos]) {
            location[_key].addr = _addr;   // Key exists in keys (update)
        } else {
            _addAddress(_key, _addr);      // Add key to keys array
        }
        emit UpdateAddress(_key, _addr);
    }

    // Removes the key from the keys list()
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
        return keys.length;
    }

    // Returns the key and address of an item in the changelog array (for enumeration)
    function get(uint256 _index) public view returns (bytes32, address) {
        return (keys[_index], location[keys[_index]].addr);
    }

    function list() public view returns (bytes32[] memory) {
        return keys;
    }

    function getAddress(bytes32 _key) public view returns (address addr) {
        addr = location[_key].addr;
        require(addr != address(0), "dss-chain-log/invalid-key");
    }

    function _addAddress(bytes32 _key, address _addr) internal {
        keys.push(_key);
        location[keys[keys.length - 1]] = Location(
            keys.length - 1,
            _addr
        );
    }

    function _removeAddress(bytes32 _key) internal {
        uint256 index = location[_key].pos;       // Get pos in array
        require(keys[index] == _key, "dss-chain-log/invalid-key");
        bytes32 move  = keys[keys.length - 1];    // Get last key
        keys[index] = move;                       // Replace
        location[move].pos = index;               // Update array pos
        keys.pop();                               // Trim last key
        delete location[_key];                    // Delete struct data
    }
}
