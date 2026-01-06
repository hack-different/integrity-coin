// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ApplePackageIntegrity} from "../src/ApplePackageIntegrity.sol";

contract CounterTest is Test {
    ApplePackageIntegrity public integrity;

    address SETTER_ADDR = makeAddr("SETTER_ADDR");
    address ROLE_ADMIN_ADDR = makeAddr("ROLE_ADMIN_ADDR");


    function setUp() public {
        integrity = new ApplePackageIntegrity();
    }

    function test_SetHash() public {
        integrity.storeHash(ApplePackageIntegrity.PackageType.IPSW, "AppleTV3,1_6.2_11D257c_Restore.ipsw", ApplePackageIntegrity.HashType.SHA2_512, 0x3108c4c910208ec70cf01c313d6b0b41ee25956d0db5e1139c8626a4a0f5eaf51da825d649b1b33c69c25147b68eb4f67f079dd640705888a3c0f2c2fecdb176);
    }

    function test_ContestHash(uint256 x) public {
        integrity.storeHash(ApplePackageIntegrity.PackageType.IPSW, "AppleTV3,1_6.2_11D257c_Restore.ipsw", ApplePackageIntegrity.HashType.SHA2_512, 0xc8bd1ac4e9721b181139a6b7f277dd142dbb5baab24b2422bfb947e00c67bf55b53e84538e68f32c58153314fc9408ba836c186adf449cde590eb482958f156d);


    }
}
