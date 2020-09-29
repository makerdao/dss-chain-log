pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./ChainLog.sol";

contract ChainLogTest is DSTest {
    ChainLog log;

    function setUp() public {
        log = new ChainLog();
    }

    function testSetAddress() public {
        log.setAddress("MCD_VAT", 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        log.setAddress("MCD_CAT", 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
        log.setAddress("MCD_JUG", 0x19c0976f590D67707E62397C87829d896Dc0f1F1);

        assertEq(log.getAddress("MCD_VAT"), 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        assertEq(log.getAddress("MCD_CAT"), 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
        assertEq(log.getAddress("MCD_JUG"), 0x19c0976f590D67707E62397C87829d896Dc0f1F1);
    }

    function testUpdateAddress() public {
        log.setAddress("MCD_VAT", 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        assertEq(log.getAddress("MCD_VAT"), 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        log.setAddress("MCD_VAT", 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
        assertEq(log.getAddress("MCD_VAT"), 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
    }

    function testRemoveAddress() public {
        log.setAddress("MCD_VAT", 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        log.setAddress("MCD_CAT", 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
        log.setAddress("MCD_JUG", 0x19c0976f590D67707E62397C87829d896Dc0f1F1);

        log.setAddress("MCD_CAT", address(0));

        assertEq(3, log.count());

        bytes32 key;
        address addr;

        (key, addr) = log.get(0);
        assertEq(key, "CHANGELOG");
        assertEq(addr, address(log));

        (key, addr) = log.get(1);
        assertEq(key, "MCD_VAT");
        assertEq(addr, 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);

        // MCD_CAT is gone

        (key, addr) = log.get(2);
        assertEq(key, "MCD_JUG");
        assertEq(addr, 0x19c0976f590D67707E62397C87829d896Dc0f1F1);
    }

    function testCount() public {
        assertEq(1, log.count());  // CHANGELOG will be #1
        log.setAddress("MCD_VAT", 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        assertEq(2, log.count());
        log.setAddress("MCD_CAT", 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
        assertEq(3, log.count());
        log.setAddress("MCD_JUG", 0x19c0976f590D67707E62397C87829d896Dc0f1F1);
        assertEq(4, log.count());
        log.setAddress("MCD_VAT", address(0));
        assertEq(3, log.count());
        log.setAddress("MCD_CAT", address(0));
        assertEq(2, log.count());
        log.setAddress("MCD_VAT", 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        assertEq(3, log.count());
    }

    function testGetList() public {
        log.setAddress("MCD_VAT", 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        log.setAddress("MCD_CAT", 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
        log.setAddress("MCD_JUG", 0x19c0976f590D67707E62397C87829d896Dc0f1F1);

        bytes32[] memory locs = log.list();

        assertEq(locs[0], "CHANGELOG");
        assertEq(locs[1], "MCD_VAT");
        assertEq(locs[2], "MCD_CAT");
        assertEq(locs[3], "MCD_JUG");

        log.setAddress("MCD_CAT", address(0));

        locs = log.list();

        assertEq(locs[0], "CHANGELOG");
        assertEq(locs[1], "MCD_VAT");
        assertEq(locs[2], "MCD_JUG");
    }

    function testSetVersion() public {
        log.setVersion("1.0.1");
        assertEq(log.version(), "1.0.1");
        log.setVersion("1.0.2-rc.1");
        assertEq(log.version(), "1.0.2-rc.1");
    }

    function testSetsha256sum() public {
        log.setSha256sum(
            "a948904f2f0f479b8f8197694b30184b0d2ed1c1cd2a1ec0fb85d299a192a447"
        );
        assertEq(
            log.sha256sum(),
            "a948904f2f0f479b8f8197694b30184b0d2ed1c1cd2a1ec0fb85d299a192a447"
        );
    }

    function testIPFS() public {
        log.setIPFS(
            "QmbbZFdXRnfiR8Zdwg557vxxp2wUURdXG28JQB8cZeeY2j"
        );
        assertEq(
            log.ipfs(),
            "QmbbZFdXRnfiR8Zdwg557vxxp2wUURdXG28JQB8cZeeY2j"
        );
    }
}
