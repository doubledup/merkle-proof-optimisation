// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import {MerkleProof as SnowbridgeMerkleProof} from "snowbridge/utils/MerkleProof.sol";
import {MerkleProof as OpenZeppelinMerkleProof} from "openzeppelin/utils/cryptography/MerkleProof.sol";

contract MerkleProofTest is Test {
    uint256 leafToProve = 7;
    bytes[] leaves = [
        bytes(hex"1111111111111111111111111111111111111111"),
        bytes(hex"2222222222222222222222222222222222222222"),
        bytes(hex"3333333333333333333333333333333333333333"),
        bytes(hex"4444444444444444444444444444444444444444"),
        bytes(hex"5555555555555555555555555555555555555555"),
        bytes(hex"6666666666666666666666666666666666666666"),
        bytes(hex"7777777777777777777777777777777777777777"),
        bytes(hex"8888888888888888888888888888888888888888"),
        bytes(hex"9999999999999999999999999999999999999999"),
        bytes(hex"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"),
        bytes(hex"BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"),
        bytes(hex"CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"),
        bytes(hex"DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD"),
        bytes(hex"EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"),
        bytes(hex"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
    ];

    function setUp() external {}

    // function testUnoptimisedProofLengthIndex() external {
    //     bytes32 expectedRoot = hex"d594f06a7365bfe1d7ff0d436cb4b5a31a453c0f857ff6412695c5df48097f1b";

    //     bytes32 computedRoot = SnowbridgeMerkleProof.computeRootFromProofAtPosition(
    //         hashedLeaf,
    //         2,
    //         4,
    //         proof
    //     );

    //     console.log("expected:");
    //     console.logBytes32(expectedRoot);
    //     console.log("found:");
    //     console.logBytes32(computedRoot);

    //     assertEq(computedRoot, expectedRoot);
    // }

    // function testUnoptimisedProofSidesArray() external {
    //     bytes32 expectedRoot = hex"d594f06a7365bfe1d7ff0d436cb4b5a31a453c0f857ff6412695c5df48097f1b";
    //     bool[] memory sides = new bool[](2);
    //     sides[0] = false;
    //     sides[1] = true;
    //     // sides[0] = true;
    //     // sides[1] = true;
    //     // sides[2] = true;
    //     // sides[3] = false;

    //     bytes32 computedRoot = SnowbridgeMerkleProof.computeRootFromProofAndSide(
    //         hashedLeaf,
    //         proof,
    //         sides
    //     );

    //     console.log("expected:");
    //     console.logBytes32(expectedRoot);
    //     console.log("found:");
    //     console.logBytes32(computedRoot);

    //     assertEq(computedRoot, expectedRoot);
    // }

    function testOptimisedProof() external {
        bytes32 expectedRoot = hex"ad32a67e72f7ac17e8191151183eb5a4adb0d24f4c46b8c9b884ab64e5c5ebe5";

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = bytes32(
            hex"93e7520a71a3e30c2660344cc5f9665ab572d25fb948bb0ab92881b253a2120c"
        );
        proof[1] = bytes32(
            hex"6aeaafbb42597ed9a8bc7210bc7c0372587997eee719231102fc80ea7a7a9884"
        );
        proof[2] = bytes32(
            hex"916f8824654fa4b566f331c21f9a8dcbaaac49de1122614c5887501490e0fd4a"
        );
        proof[3] = bytes32(
            hex"799e80126fa1489eea645add1b4b1ae54e2d12837abd3d055c42a661ebbd6b43"
        );

        bytes memory leaf = leaves[leafToProve];
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

        bytes32 computedRoot = OpenZeppelinMerkleProof.processProof(
            proof,
            hashedLeaf
        );

        assertEq(computedRoot, expectedRoot);
    }
}
