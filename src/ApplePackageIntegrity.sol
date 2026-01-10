// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract ApplePackageIntegrity is Initializable, AccessControl {
    error CannotContestNull(string name);
    error InconsistentData();

    event SetIntegrityHashEvent(PackageType packageType, string name, HashType hashType, bytes hash);

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
        PackageType packageType;
        mapping(HashType => bytes) hashes;
        mapping(address => mapping(HashType => bytes)) hashContests;
    }

    mapping(uint256 => PackageData) private _data;

    constructor(address upgrader, address admin) {
        _grantRole(UPGRADER_ROLE, upgrader);
        _grantRole(ADMIN_ROLE, admin);
    }

    function grantHashSetter(address role) onlyRole(ADMIN_ROLE) external {
        _grantRole(HASH_SETTER_ROLE, role);
    }

    function storeHash(PackageType packageType, string calldata name, HashType hashType, bytes calldata hash) external onlyRole(HASH_SETTER_ROLE) {
        uint256 nameHash = uint256(keccak256(abi.encodePacked(name)));
        _data[nameHash].name = name;
        _data[nameHash].packageType = packageType;
        _data[nameHash].hashes[hashType] = hash;

        emit SetIntegrityHashEvent(packageType, name, hashType, hash);
    }

    function getHash(PackageType packageType, string calldata name, HashType hashType) external view returns (bytes memory) {
        uint256 nameHash = uint256(keccak256(abi.encodePacked(name)));
        if (packageType != _data[nameHash].packageType) {
            revert InconsistentData();
        }
        return _data[nameHash].hashes[hashType];
    }

    function contestHash(PackageType packageType, string calldata name, HashType hashType, bytes calldata hash) payable external {
        uint256 nameHash = uint256(keccak256(abi.encodePacked(name)));

        if (nameHash != uint256(keccak256(abi.encodePacked(_data[nameHash].name)))) {
            revert CannotContestNull(name);
        }

        if (packageType != _data[nameHash].packageType) {
            revert InconsistentData();
        }

        _data[nameHash].hashContests[msg.sender][hashType] = hash;
    }
}
