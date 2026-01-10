// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ApplePackageIntegrity} from "../src/ApplePackageIntegrity.sol";

contract CounterTest is Test {
    ApplePackageIntegrity public integrity;

    address private upgraderAddr = makeAddr("UPGRADER_ADDR");
    address private setterAddr = makeAddr("SETTER_ADDR");
    address private roleAdminAddr = makeAddr("ROLE_ADMIN_ADDR");

    bytes private constant HASH_VALUE = hex"3108c4c910208ec70cf01c313d6b0b41ee25956d0db5e1139c8626a4a0f5eaf51da825d649b1b33c69c25147b68eb4f67f079dd640705888a3c0f2c2fecdb176";

    function setUp() public {
        integrity = new ApplePackageIntegrity(upgraderAddr, roleAdminAddr);

        vm.prank(roleAdminAddr);
        integrity.grantHashSetter(setterAddr);
    }

    function test_SetHash() public {
        vm.expectEmit(true, true, true, true);
        emit ApplePackageIntegrity.SetIntegrityHashEvent(ApplePackageIntegrity.PackageType.IPSW, "AppleTV3,1_6.2_11D257c_Restore.ipsw", ApplePackageIntegrity.HashType.SHA2_512, HASH_VALUE);

        vm.prank(setterAddr);
        integrity.storeHash(ApplePackageIntegrity.PackageType.IPSW, "AppleTV3,1_6.2_11D257c_Restore.ipsw", ApplePackageIntegrity.HashType.SHA2_512, HASH_VALUE);
    }

    function test_GetHash() public {
        vm.prank(setterAddr);
        integrity.storeHash(ApplePackageIntegrity.PackageType.IPSW, "AppleTV3,1_6.2_11D257c_Restore.ipsw", ApplePackageIntegrity.HashType.SHA2_512, HASH_VALUE);

        bytes memory hashValue = integrity.getHash(ApplePackageIntegrity.PackageType.IPSW, "AppleTV3,1_6.2_11D257c_Restore.ipsw", ApplePackageIntegrity.HashType.SHA2_512);

        vm.assertEq(hashValue, HASH_VALUE);
    }
}
