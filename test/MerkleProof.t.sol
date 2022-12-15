// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import { MerkleProof as SnowbridgeMerkleProof } from "snowbridge/utils/MerkleProof.sol";
import { MerkleProof as OpenZeppelinMerkleProof } from "openzeppelin/utils/cryptography/MerkleProof.sol";

contract MerkleProofTest is Test {
    bytes[] public leaves;
    bytes32 public hashedLeaf;
    bytes32[] public proof;

    function setUp() public {
        leaves = [
            bytes(hex"0102030405"),
            bytes(hex"060708090A"),
            bytes(hex"0B0C0D0E0F"),
            bytes(hex"1011121314")
        ];

        hashedLeaf = keccak256(leaves[2]);

        proof = new bytes32[](2);
        proof[0] = bytes32(hex"c4766a907a6650da5c51e06ffec70444ec38f3ebd9156a8c3c3271b0f6383a2d");
        proof[1] = bytes32(hex"dc98d1099d7ebc2ae6c7c780c218917d5061beccbdb2ac05bc68e7b8bcc39555");
    }

    function testUnoptimisedProofLengthIndex() public {
        bytes32 expectedRoot = hex"d594f06a7365bfe1d7ff0d436cb4b5a31a453c0f857ff6412695c5df48097f1b";

        bytes32 computedRoot = SnowbridgeMerkleProof.computeRootFromProofAtPosition(
            hashedLeaf,
            2,
            4,
            proof
        );

        console.log("expected:");
        console.logBytes32(expectedRoot);
        console.log("found:");
        console.logBytes32(computedRoot);

        assertEq(computedRoot, expectedRoot);
    }

    function testUnoptimisedProofSidesArray() public {
        bytes32 expectedRoot = hex"d594f06a7365bfe1d7ff0d436cb4b5a31a453c0f857ff6412695c5df48097f1b";
        bool[] memory sides = new bool[](2);
        sides[0] = false;
        sides[1] = true;

        bytes32 computedRoot = SnowbridgeMerkleProof.computeRootFromProofAndSide(
            hashedLeaf,
            proof,
            sides
        );

        console.log("expected:");
        console.logBytes32(expectedRoot);
        console.log("found:");
        console.logBytes32(computedRoot);

        assertEq(computedRoot, expectedRoot);
    }

    function testOptimisedProof() public {
        bytes32 expectedRoot = hex"03877141142e4d3fa214041fb5125f2ea61a88db793b5c063cf98910619e0b54";

        bytes32 computedRoot = OpenZeppelinMerkleProof.processProof(
            proof,
            hashedLeaf
        );

        console.log("expected:");
        console.logBytes32(expectedRoot);
        console.log("found:");
        console.logBytes32(computedRoot);

        assertEq(computedRoot, expectedRoot);
    }
}
