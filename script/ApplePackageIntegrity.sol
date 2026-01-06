// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {ApplePackageIntegrity} from "../src/ApplePackageIntegrity.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract CounterScript is Script {
    ApplePackageIntegrity public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new ApplePackageIntegrity();

        vm.stopBroadcast();
    }
}
