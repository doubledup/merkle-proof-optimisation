// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {MerkleProof as OpenZeppelinMerkleProof} from "openzeppelin/utils/cryptography/MerkleProof.sol";

library OptimisedMerkleProof {
    function processProof(bytes32[] memory proof, bytes32 leaf)
        public
        pure
        returns (bytes32)
    {
        return OpenZeppelinMerkleProof.processProof(proof, leaf);
    }
}
