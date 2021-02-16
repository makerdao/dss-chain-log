pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./ChainLog.sol";

contract ChainLogTest is DSTest {
    ChainLog clog;

    function setUp() public {
        clog = new ChainLog();
    }

    function testSetAddress() public {
        clog.setAddress("MCD_VAT", 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        clog.setAddress("MCD_CAT", 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
        clog.setAddress("MCD_JUG", 0x19c0976f590D67707E62397C87829d896Dc0f1F1);

        assertEq(clog.getAddress("MCD_VAT"), 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        assertEq(clog.getAddress("MCD_CAT"), 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
        assertEq(clog.getAddress("MCD_JUG"), 0x19c0976f590D67707E62397C87829d896Dc0f1F1);
    }

    function testUpdateAddress() public {
        clog.setAddress("MCD_VAT", 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        assertEq(clog.getAddress("MCD_VAT"), 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        clog.setAddress("MCD_VAT", 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
        assertEq(clog.getAddress("MCD_VAT"), 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
    }

    function testRemoveAddress() public {
        clog.setAddress("MCD_VAT", 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        clog.setAddress("MCD_CAT", 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
        clog.setAddress("MCD_JUG", 0x19c0976f590D67707E62397C87829d896Dc0f1F1);

        clog.removeAddress("MCD_CAT");

        assertEq(3, clog.count());

        bytes32 key;
        address addr;

        (key, addr) = clog.get(0);
        assertEq(key, "CHANGELOG");
        assertEq(addr, address(clog));

        (key, addr) = clog.get(1);
        assertEq(key, "MCD_VAT");
        assertEq(addr, 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);

        // MCD_CAT is gone

        (key, addr) = clog.get(2);
        assertEq(key, "MCD_JUG");
        assertEq(addr, 0x19c0976f590D67707E62397C87829d896Dc0f1F1);
    }

    function testCount() public {
        assertEq(1, clog.count());  // CHANGELOG will be #1
        clog.setAddress("MCD_VAT", 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        assertEq(2, clog.count());
        clog.setAddress("MCD_CAT", 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
        assertEq(3, clog.count());
        clog.setAddress("MCD_JUG", 0x19c0976f590D67707E62397C87829d896Dc0f1F1);
        assertEq(4, clog.count());
        clog.setAddress("MCD_VAT", address(0));
        assertEq(4, clog.count());
        clog.setAddress("MCD_CAT", address(0));
        assertEq(4, clog.count());
        clog.setAddress("MCD_VAT", 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        assertEq(4, clog.count());
    }

    function testGetList() public {
        clog.setAddress("MCD_VAT", 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
        clog.setAddress("MCD_CAT", 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea);
        clog.setAddress("MCD_JUG", 0x19c0976f590D67707E62397C87829d896Dc0f1F1);

        bytes32[] memory locs = clog.list();

        assertEq(locs[0], "CHANGELOG");
        assertEq(locs[1], "MCD_VAT");
        assertEq(locs[2], "MCD_CAT");
        assertEq(locs[3], "MCD_JUG");

        clog.setAddress("MCD_CAT", address(0));

        locs = clog.list();

        assertEq(locs[0], "CHANGELOG");
        assertEq(locs[1], "MCD_VAT");
        assertEq(locs[2], "MCD_CAT");
        assertEq(locs[3], "MCD_JUG");

        clog.removeAddress("MCD_CAT");

        locs = clog.list();

        assertEq(locs[0], "CHANGELOG");
        assertEq(locs[1], "MCD_VAT");
        assertEq(locs[2], "MCD_JUG");
    }

    function testSetVersion() public {
        clog.setVersion("1.0.1");
        assertEq(clog.version(), "1.0.1");
        clog.setVersion("1.0.2-rc.1");
        assertEq(clog.version(), "1.0.2-rc.1");
    }

    function testSetsha256sum() public {
        clog.setSha256sum(
            "a948904f2f0f479b8f8197694b30184b0d2ed1c1cd2a1ec0fb85d299a192a447"
        );
        assertEq(
            clog.sha256sum(),
            "a948904f2f0f479b8f8197694b30184b0d2ed1c1cd2a1ec0fb85d299a192a447"
        );
    }

    function testIPFS() public {
        clog.setIPFS(
            "QmbbZFdXRnfiR8Zdwg557vxxp2wUURdXG28JQB8cZeeY2j"
        );
        assertEq(
            clog.ipfs(),
            "QmbbZFdXRnfiR8Zdwg557vxxp2wUURdXG28JQB8cZeeY2j"
        );
    }

    function testApproximateDeployCost() public {
        new ChainLog();
    }
}
