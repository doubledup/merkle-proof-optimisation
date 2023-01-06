// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import {MerkleProof as SnowbridgeMerkleProof} from "snowbridge/utils/MerkleProof.sol";
import {OptimisedMerkleProof as OpenZeppelinMerkleProof} from "src/OptimisedMerkleProof.sol";

contract MerkleProofTest is Test {
    uint256 leafToProve = 12;
    bytes[] leaves = [
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000000"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000001"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000002"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000003"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000004"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000005"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000006"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000007"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000008"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000009"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000010"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000011"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000012"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000013"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000014"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000015")
    ];

    function setUp() external {}

    function testUnoptimisedProofLengthIndex() external {
        bytes32 expectedRoot = hex"89e05033b83bbcd26574a13c72f57f63174870e598e982236a31cc70b08c32dc";
        bytes32 hashedLeaf = hashLeaf(leaves[leafToProve]);

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = bytes32(
            hex"d255520a2445a6225c516a8607cbda7359210115131577170448c9deb235206a"
        );
        proof[1] = bytes32(
            hex"506b310f1fda68eae42eabe909a3cdf1c796b3f6d6d0955fc466d274e4731c7a"
        );
        proof[2] = bytes32(
            hex"df340c91de0b21ac6130307f468b025f0a665789dd7e8f586096566c387e8131"
        );
        proof[3] = bytes32(
            hex"cbacfce1c89d6b660bc9aee56149f446a623db095ceb54d269748e3f331462d7"
        );

        bytes32 computedRoot = SnowbridgeMerkleProof
            .computeRootFromProofAtPosition(
                hashedLeaf,
                leafToProve,
                leaves.length,
                proof
            );

        assertEq(computedRoot, expectedRoot);
    }

    function testUnoptimisedProofSidesArray() external {
        bytes32 expectedRoot = hex"89e05033b83bbcd26574a13c72f57f63174870e598e982236a31cc70b08c32dc";
        bytes32 hashedLeaf = hashLeaf(leaves[leafToProve]);

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = bytes32(
            hex"d255520a2445a6225c516a8607cbda7359210115131577170448c9deb235206a"
        );
        proof[1] = bytes32(
            hex"506b310f1fda68eae42eabe909a3cdf1c796b3f6d6d0955fc466d274e4731c7a"
        );
        proof[2] = bytes32(
            hex"df340c91de0b21ac6130307f468b025f0a665789dd7e8f586096566c387e8131"
        );
        proof[3] = bytes32(
            hex"cbacfce1c89d6b660bc9aee56149f446a623db095ceb54d269748e3f331462d7"
        );

        bool[] memory sides = new bool[](7);
        sides[0] = false;
        sides[1] = false;
        sides[2] = true;
        sides[3] = true;

        bytes32 computedRoot = SnowbridgeMerkleProof
            .computeRootFromProofAndSide(hashedLeaf, proof, sides);

        assertEq(computedRoot, expectedRoot);
    }

    function testOptimisedProof() external {
        bytes32 expectedRoot = hex"df074105270e8147f6be169cbcead1467648cb88b28b2ce50980a95ca9a76728";

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = bytes32(
            hex"d255520a2445a6225c516a8607cbda7359210115131577170448c9deb235206a"
        );
        proof[1] = bytes32(
            hex"85bd40c5b4ca17772657807ac3722be7d49c2e6dbc50b9f25cd9a028bf6f4bed"
        );
        proof[2] = bytes32(
            hex"9d5922d3886daa7e6561934906922a10a0df6faa66fd3ca553e795edd7c72006"
        );
        proof[3] = bytes32(
            hex"5ca62c8f5e9c77e8e1b99bf85960e378830dd052533f2de017292333dc04ca6e"
        );

        bytes32 hashedLeaf = hashLeaf(leaves[leafToProve]);

        bytes32 computedRoot = OpenZeppelinMerkleProof.processProof(
            proof,
            hashedLeaf
        );

        assertEq(computedRoot, expectedRoot);
    }

    function hashLeaf(bytes storage leaf) private pure returns (bytes32) {
        bytes memory encodedLeaf = abi.encode(leaf);
        // Leaves are double-hashed to prevent second preimage attacks
        bytes32 hashedLeaf = keccak256(abi.encode(keccak256(encodedLeaf)));

        // // Uncomment for intermediate leaf values
        // console.log("leaf:");
        // console.logBytes(leaf);
        // console.log("encoded leaf:");
        // console.logBytes(encodedLeaf);
        // console.log("leaf hash:");
        // console.logBytes32(hashedLeaf);

        return hashedLeaf;
    }
}
