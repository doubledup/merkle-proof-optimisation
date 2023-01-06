// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import {MerkleProof as SnowbridgeMerkleProof} from "snowbridge/utils/MerkleProof.sol";
import {OptimisedMerkleProof as OpenZeppelinMerkleProof} from "src/OptimisedMerkleProof.sol";

contract MerkleProofTest is Test {
    uint256 leafToProve = 47;
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
        bytes(hex"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"),
        bytes(hex"0000000000000000000000000000000000000000"),
        bytes(hex"0000000000000000000000000000000000000001"),
        bytes(hex"0000000000000000000000000000000000000002"),
        bytes(hex"0000000000000000000000000000000000000003"),
        bytes(hex"0000000000000000000000000000000000000004"),
        bytes(hex"0000000000000000000000000000000000000005"),
        bytes(hex"0000000000000000000000000000000000000006"),
        bytes(hex"0000000000000000000000000000000000000007"),
        bytes(hex"0000000000000000000000000000000000000008"),
        bytes(hex"0000000000000000000000000000000000000009"),
        bytes(hex"0000000000000000000000000000000000000010"),
        bytes(hex"0000000000000000000000000000000000000011"),
        bytes(hex"0000000000000000000000000000000000000012"),
        bytes(hex"0000000000000000000000000000000000000013"),
        bytes(hex"0000000000000000000000000000000000000014"),
        bytes(hex"0000000000000000000000000000000000000015"),
        bytes(hex"0000000000000000000000000000000000000016"),
        bytes(hex"0000000000000000000000000000000000000017"),
        bytes(hex"0000000000000000000000000000000000000018"),
        bytes(hex"0000000000000000000000000000000000000019"),
        bytes(hex"0000000000000000000000000000000000000020"),
        bytes(hex"0000000000000000000000000000000000000021"),
        bytes(hex"0000000000000000000000000000000000000022"),
        bytes(hex"0000000000000000000000000000000000000023"),
        bytes(hex"0000000000000000000000000000000000000024"),
        bytes(hex"0000000000000000000000000000000000000025"),
        bytes(hex"0000000000000000000000000000000000000026"),
        bytes(hex"0000000000000000000000000000000000000027"),
        bytes(hex"0000000000000000000000000000000000000028"),
        bytes(hex"0000000000000000000000000000000000000029"),
        bytes(hex"0000000000000000000000000000000000000030"),
        bytes(hex"0000000000000000000000000000000000000031"),
        bytes(hex"0000000000000000000000000000000000000032"),
        bytes(hex"0000000000000000000000000000000000000033"),
        bytes(hex"0000000000000000000000000000000000000034"),
        bytes(hex"0000000000000000000000000000000000000035"),
        bytes(hex"0000000000000000000000000000000000000036"),
        bytes(hex"0000000000000000000000000000000000000037"),
        bytes(hex"0000000000000000000000000000000000000038"),
        bytes(hex"0000000000000000000000000000000000000039"),
        bytes(hex"0000000000000000000000000000000000000040"),
        bytes(hex"0000000000000000000000000000000000000041"),
        bytes(hex"0000000000000000000000000000000000000042"),
        bytes(hex"0000000000000000000000000000000000000043"),
        bytes(hex"0000000000000000000000000000000000000044"),
        bytes(hex"0000000000000000000000000000000000000045"),
        bytes(hex"0000000000000000000000000000000000000046"),
        bytes(hex"0000000000000000000000000000000000000047"),
        bytes(hex"0000000000000000000000000000000000000048"),
        bytes(hex"0000000000000000000000000000000000000049"),
        bytes(hex"0000000000000000000000000000000000000050"),
        bytes(hex"0000000000000000000000000000000000000051"),
        bytes(hex"0000000000000000000000000000000000000052"),
        bytes(hex"0000000000000000000000000000000000000053"),
        bytes(hex"0000000000000000000000000000000000000054"),
        bytes(hex"0000000000000000000000000000000000000055"),
        bytes(hex"0000000000000000000000000000000000000056"),
        bytes(hex"0000000000000000000000000000000000000057"),
        bytes(hex"0000000000000000000000000000000000000058"),
        bytes(hex"0000000000000000000000000000000000000059"),
        bytes(hex"0000000000000000000000000000000000000060"),
        bytes(hex"0000000000000000000000000000000000000061"),
        bytes(hex"0000000000000000000000000000000000000062"),
        bytes(hex"0000000000000000000000000000000000000063"),
        bytes(hex"0000000000000000000000000000000000000064"),
        bytes(hex"0000000000000000000000000000000000000065"),
        bytes(hex"0000000000000000000000000000000000000066"),
        bytes(hex"0000000000000000000000000000000000000067"),
        bytes(hex"0000000000000000000000000000000000000068"),
        bytes(hex"0000000000000000000000000000000000000069"),
        bytes(hex"0000000000000000000000000000000000000070"),
        bytes(hex"0000000000000000000000000000000000000071"),
        bytes(hex"0000000000000000000000000000000000000072"),
        bytes(hex"0000000000000000000000000000000000000073"),
        bytes(hex"0000000000000000000000000000000000000074"),
        bytes(hex"0000000000000000000000000000000000000075"),
        bytes(hex"0000000000000000000000000000000000000076"),
        bytes(hex"0000000000000000000000000000000000000077"),
        bytes(hex"0000000000000000000000000000000000000078"),
        bytes(hex"0000000000000000000000000000000000000079"),
        bytes(hex"0000000000000000000000000000000000000080"),
        bytes(hex"0000000000000000000000000000000000000081"),
        bytes(hex"0000000000000000000000000000000000000082"),
        bytes(hex"0000000000000000000000000000000000000083"),
        bytes(hex"0000000000000000000000000000000000000084"),
        bytes(hex"0000000000000000000000000000000000000085")
    ];

    function setUp() external {}

    function testUnoptimisedProofLengthIndex() external {
        bytes32 expectedRoot = hex"bda97f17356f91657875ebb31022294e021ecada7d667923a326e191bb0e42fb";
        bytes32 hashedLeaf = hashLeaf(leaves[leafToProve]);

        bytes32[] memory proof = new bytes32[](7);
        proof[0] = bytes32(
            hex"e6ec1a07d32d0f0a00d7f279e616d53b927a0c97b73fad79032fe17e0a8ae7d2"
        );
        proof[1] = bytes32(
            hex"92f4e58aa3a75cdb8d2ee9d68c936299cfa770a69d1e4005f0ddfa318f93bcd7"
        );
        proof[2] = bytes32(
            hex"e260aa7e80add5c69cd7570cb05fb0edb95439a67a2bad0bc3bebbaac795826b"
        );
        proof[3] = bytes32(
            hex"ddb7a24a56453540466025286110fca50e90b7c185cb60bc0aa493309c3fb685"
        );
        proof[4] = bytes32(
            hex"f3fd3b24e9eac2f0d53c888ae208b48bc83001d1aab33ebd5cb21602c6c18e34"
        );
        proof[5] = bytes32(
            hex"2aa8a23f5c9bb0a7830ac24e623b772b64748c436994346055ced600595d34c4"
        );
        proof[6] = bytes32(
            hex"1d2d3a958693166e9f093b2123d89562ed809a50f9d8310d98a47765592999f3"
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
        bytes32 expectedRoot = hex"bda97f17356f91657875ebb31022294e021ecada7d667923a326e191bb0e42fb";
        bytes32 hashedLeaf = hashLeaf(leaves[leafToProve]);

        bytes32[] memory proof = new bytes32[](7);
        proof[0] = bytes32(
            hex"e6ec1a07d32d0f0a00d7f279e616d53b927a0c97b73fad79032fe17e0a8ae7d2"
        );
        proof[1] = bytes32(
            hex"92f4e58aa3a75cdb8d2ee9d68c936299cfa770a69d1e4005f0ddfa318f93bcd7"
        );
        proof[2] = bytes32(
            hex"e260aa7e80add5c69cd7570cb05fb0edb95439a67a2bad0bc3bebbaac795826b"
        );
        proof[3] = bytes32(
            hex"ddb7a24a56453540466025286110fca50e90b7c185cb60bc0aa493309c3fb685"
        );
        proof[4] = bytes32(
            hex"f3fd3b24e9eac2f0d53c888ae208b48bc83001d1aab33ebd5cb21602c6c18e34"
        );
        proof[5] = bytes32(
            hex"2aa8a23f5c9bb0a7830ac24e623b772b64748c436994346055ced600595d34c4"
        );
        proof[6] = bytes32(
            hex"1d2d3a958693166e9f093b2123d89562ed809a50f9d8310d98a47765592999f3"
        );

        bool[] memory sides = new bool[](7);
        sides[0] = true;
        sides[1] = true;
        sides[2] = true;
        sides[3] = true;
        sides[4] = false;
        sides[5] = true;
        sides[6] = false;

        bytes32 computedRoot = SnowbridgeMerkleProof
            .computeRootFromProofAndSide(hashedLeaf, proof, sides);

        assertEq(computedRoot, expectedRoot);
    }

    function testOptimisedProof() external {
        bytes32 expectedRoot = hex"a31a4bb4ecf733adaa8c63939cab10113dc47e90abf282da8282fcb1805d3df4";

        bytes32[] memory proof = new bytes32[](7);
        proof[0] = bytes32(
            hex"ad813aa5f868c8ed1ee59993e6dec41d7413f752d3a55c9210ee47e2520f2725"
        );
        proof[1] = bytes32(
            hex"4e478e7fcc657a7867ea163a87d5b59ec32c24bb70a5e276b321bbf417878406"
        );
        proof[2] = bytes32(
            hex"4e5cde345663a0d80a46557fee062b579bfdb4457c6c0becad48d91ea88f6b47"
        );
        proof[3] = bytes32(
            hex"5151a2e027bffd0e02fb325cf552e5cb38a7a57a3442f5c2252769eeeb0c5e57"
        );
        proof[4] = bytes32(
            hex"60b1d9a4a8370fe91583bda4025c230552a1af6877d93cdb1aa9e316bc8fcb55"
        );
        proof[5] = bytes32(
            hex"7c964af44ad97b2bc504cedd41bbada1aabfac9f186f94e6893a01e5b75cc3e7"
        );
        proof[6] = bytes32(
            hex"1e33a079df62679b8e00bb7a444344a0bda172c337f4e015052a329eb3b0fd20"
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
