// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {ApplePackageIntegrity} from "../src/ApplePackageIntegrity.sol";

contract CounterScript is Script {
    ApplePackageIntegrity public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();



        vm.stopBroadcast();
    }
}
