pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./ChainLog.sol";

contract ChainLogTest is DSTest {
    ChainLog log;

    function setUp() public {
        log = new ChainLog();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
