// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";

contract ApplePackageIntegrity is Initializable, AccessControl {
    error CannotContestNull(string name);

    enum PackageType {
        IPSW
    }

    enum HashType {
        MD5,
        SHA1,
        SHA2_224,
        SHA2_256,
        SHA2_384,
        SHA2_512,
        SHA3_224,
        SHA3_256,
        SHA3_384,
        SHA3_512,
        Keccak_256
    }

    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant HASH_SETTER_ROLE = keccak256("HASH_SETTER_ROLE");

    struct PackageData {
        string name;
        mapping(HashType => bytes) hashes;
        mapping(address => mapping(HashType => bytes)) hashContests;
    }

    mapping(PackageType => mapping(uint256 => PackageData)) _data;

    constructor(address upgrader, address admin) {
        _grantRole(UPGRADER_ROLE, upgrader);
        _grantRole(ADMIN_ROLE, admin);
    }

    function grantHashSetter(address)

    function storeHash(PackageType packageType, string name, HashType hashType, bytes hash) external onlyRole(HASH_SETTER_ROLE) {
        bytes32 nameHash = keccak256(name);
        PackageData memory data = _data[nameHash];
        data.name = name;
        data.hashes[hashType] = hash;

        _data[nameHash] = data;
    }

    function contestHash(PackageType packageType, string name, HashType hashType, bytes hash) payable external {
        bytes32 nameHash = keccak256(name);
        PackageData memory data = _data[nameHash];

        if (nameHash != keccak256(data.name)) {
            revert CannotContestNull(name);
        }

        data.hashContests[msg.sender][hashType] = data;

        _data[nameHash] = data;
    }
}
