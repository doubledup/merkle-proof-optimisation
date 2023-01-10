// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import {MerkleProof as SnowbridgeMerkleProof} from "snowbridge/utils/MerkleProof.sol";
import {MerkleProof as OpenZeppelinMerkleProof} from "openzeppelin/utils/cryptography/MerkleProof.sol";
// import {OptimisedMerkleProof as OpenZeppelinMerkleProof} from "src/OptimisedMerkleProof.sol";

contract MerkleProofTest is Test {
    uint256 leafIndex = 3;
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
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000015"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000016"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000017"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000018"),
        bytes(hex"0000000000000000000000000000000000000000000000000000000000000019")
    ];

    function setUp() external {}

    function testUnoptimisedProofLengthIndex() external {
        bytes32 expectedRoot = hex"18bbfdde0b580e2bbe3d45449000b98b7e98f66fc58f187ade7de5343eb3a15c";

        bytes32[] memory proof = new bytes32[](5);
        proof[0] = bytes32(
            hex"58e9a6ca105dd9ed36c41988e9cf55b722660d6b76f83ebc322fecc94477b2ab"
        );
        proof[1] = bytes32(
            hex"b9ea4098a5754a60725baf50899ccd2e84f4e9cd26c6ee5f8df8e164e6dffa09"
        );
        proof[2] = bytes32(
            hex"5c2ad896a3f86e0d3391c5c2ab35e31d6dc16f8843bcdb8bb77d93b733612a18"
        );
        proof[3] = bytes32(
            hex"df340c91de0b21ac6130307f468b025f0a665789dd7e8f586096566c387e8131"
        );
        proof[4] = bytes32(
            hex"f50a7b2cd8561cab32e7f43f50c64e9ad3838c2c25e45e61e6cf00a434270580"
        );

        bytes32 hashedLeaf = hashLeaf(leaves[leafIndex]);

        bytes32 computedRoot = SnowbridgeMerkleProof
            .computeRootFromProofAtPosition(
                hashedLeaf,
                leafIndex,
                leaves.length,
                proof
            );

        assertEq(computedRoot, expectedRoot);
    }

    function testUnoptimisedProofSidesArray() external {
        bytes32 expectedRoot = hex"18bbfdde0b580e2bbe3d45449000b98b7e98f66fc58f187ade7de5343eb3a15c";

        bytes32[] memory proof = new bytes32[](5);
        proof[0] = bytes32(
            hex"58e9a6ca105dd9ed36c41988e9cf55b722660d6b76f83ebc322fecc94477b2ab"
        );
        proof[1] = bytes32(
            hex"b9ea4098a5754a60725baf50899ccd2e84f4e9cd26c6ee5f8df8e164e6dffa09"
        );
        proof[2] = bytes32(
            hex"5c2ad896a3f86e0d3391c5c2ab35e31d6dc16f8843bcdb8bb77d93b733612a18"
        );
        proof[3] = bytes32(
            hex"df340c91de0b21ac6130307f468b025f0a665789dd7e8f586096566c387e8131"
        );
        proof[4] = bytes32(
            hex"f50a7b2cd8561cab32e7f43f50c64e9ad3838c2c25e45e61e6cf00a434270580"
        );

        bool[] memory hashSides = new bool[](7);
        hashSides[0] = true;
        hashSides[1] = true;
        hashSides[2] = false;
        hashSides[3] = false;
        hashSides[4] = false;

        bytes32 hashedLeaf = hashLeaf(leaves[leafIndex]);

        bytes32 computedRoot = SnowbridgeMerkleProof
            .computeRootFromProofAndSide(hashedLeaf, proof, hashSides);

        assertEq(computedRoot, expectedRoot);
    }

    function testOptimisedProof() external {
        bytes32 expectedRoot = hex"b08ed46dee2199775e04c69dc62b43614b404d05cf09b83bd064e6594d0715e9";

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = bytes32(
            hex"75b9ce82e2f316dd49c7fc23ba632b1b06c2eb9b40e86abb6fa4ba3b940dbf4b"
        );
        proof[1] = bytes32(
            hex"3e8fda3dd4a61ef41110c4b250cdf7ac07717402207d418a36a2bc5c511daebf"
        );
        proof[2] = bytes32(
            hex"52f43dcfa7482ed14dea86ede03ab138ebc7125eb97525b09f4715b615da18cf"
        );
        proof[3] = bytes32(
            hex"5642a45a5810d90f9aadaceeb5bd365b791fd637d0f986b6d19869f2d616a859"
        );

        bytes32 hashedLeaf = hashLeaf(leaves[leafIndex]);

        bytes32 computedRoot = OpenZeppelinMerkleProof.processProof(
            proof,
            hashedLeaf
        );

        assertEq(computedRoot, expectedRoot);
    }

    // Data for the following test case can be generated by adding the following code to polkadot's runtime/rococo/src/lib.rs:
    //
    // #[test]
    // fn test_optimised_merkle_root() {
    //     let leaves = vec![
    //         vec![ 0x01, 0x02, 0x03, 0x04, 0x05 ],
    //         vec![ 0x06, 0x07, 0x08, 0x09, 0x0A ],
    //         vec![ 0x0B, 0x0C, 0x0D, 0x0E, 0x0F ],
    //         vec![ 0x10, 0x11, 0x12, 0x13, 0x14 ]
    //     ];

    //     // println!("leaf: {:?}", leaves[2]);
    //     // let leaf_hash: H256 = <<Runtime as pallet_mmr::Config>::Hashing as HashT>::hash(leaves[2].as_ref());
    //     // println!("hashed leaf: {:?}", leaf_hash);

    //     // use hex_literal::hex;
    //     // let first_proof_hash: H256 = hex!("c4766a907a6650da5c51e06ffec70444ec38f3ebd9156a8c3c3271b0f6383a2d").into();

    //     // let concat_hashes = [leaf_hash.as_bytes(), first_proof_hash.as_bytes()].concat();
    //     // let first_intermediate_hash = <<Runtime as pallet_mmr::Config>::Hashing as HashT>::hash(
    //     // 	concat_hashes.as_bytes_ref());
    //     // println!("first intermediate hash: {:?}", first_intermediate_hash);

    //     let proof = beefy_merkle_tree
    //         ::merkle_proof
    //         ::<<Runtime as pallet_mmr::Config>::Hashing, _, _>(
    //             leaves, 2
    //         );
    //     println!("merkle proof: {:?}", proof);

    //     panic!("force printing output");
    // }

    function testOptimisedProofBeefyMerkleTree() external {
        bytes32 expectedRoot = hex"03877141142e4d3fa214041fb5125f2ea61a88db793b5c063cf98910619e0b54";

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = bytes32(
            hex"c4766a907a6650da5c51e06ffec70444ec38f3ebd9156a8c3c3271b0f6383a2d"
        );
        proof[1] = bytes32(
            hex"dc98d1099d7ebc2ae6c7c780c218917d5061beccbdb2ac05bc68e7b8bcc39555"
        );

        bytes32 hashedLeaf = keccak256(bytes(hex"0B0C0D0E0F"));

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
