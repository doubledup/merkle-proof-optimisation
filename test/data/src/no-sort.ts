import { defaultAbiCoder } from "@ethersproject/abi";
import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import { hex } from "@openzeppelin/merkle-tree/dist/bytes";
import { getProof } from "@openzeppelin/merkle-tree/dist/core";
import { keccak256 } from "ethereum-cryptography/keccak";
import {
  bytesToHex,
  concatBytes,
  // equalsBytes,
  hexToBytes,
} from "ethereum-cryptography/utils";

export const NoSortMerkleTree = {
  of: function <T extends unknown[]>(
    values: T[],
    leafEncoding: string[]
  ): StandardMerkleTree<T> {
    const hashedValues = values.map((value, valueIndex) => ({
      value,
      valueIndex,
      hash: standardLeafHash(value, leafEncoding),
    }));
    // Don't sort hashes before combining them, unlike StandardMerkleTree
    // .sort((a, b) => compareBytes(a.hash, b.hash));

    const treeHashes = makeMerkleTree(hashedValues.map((v) => v.hash));

    const bottomLayerWidth =
      2 * (values.length - 2 ** Math.floor(Math.log2(values.length)));
    const indexedValues = values.map((value) => ({ value, treeIndex: 0 }));
    for (const [leafIndex, { valueIndex }] of hashedValues.entries()) {
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      indexedValues[valueIndex]!.treeIndex = (() => {
        if (leafIndex < bottomLayerWidth) {
          return treeHashes.length - bottomLayerWidth + leafIndex;
        } else {
          return (
            treeHashes.length - bottomLayerWidth + leafIndex - values.length
          );
        }
      })();
    }

    const tree = StandardMerkleTree.load({
      tree: treeHashes.map(bytesToHex),
      values: indexedValues,
      leafEncoding,
      format: "standard-v1",
    });

    tree.getProof = function (leaf: number | T): string[] {
      // input validity
      const valueIndex =
        typeof leaf === "number" ? leaf : tree["leafLookup"](leaf);
      tree["validateValue"](valueIndex);

      // rebuild tree index and generate proof
      const { treeIndex } = tree["values"][valueIndex]!;
      const proof = getProof(tree["tree"], treeIndex);

      // // check proof
      // const hash = tree["tree"][treeIndex]!;
      // const impliedRoot = processProof(hash, proof);
      // if (!equalsBytes(impliedRoot, tree["tree"][0]!)) {
      //   throw new Error("Unable to prove value");
      // }

      // return proof in hex format
      return proof.map(hex);
    };

    return tree;
  },
};

function standardLeafHash<T extends unknown[]>(
  value: T,
  types: string[]
): Bytes {
  return keccak256(keccak256(hexToBytes(defaultAbiCoder.encode(types, value))));
}

export function doubleHash(bytes: string): string {
  return bytesToHex(keccak256(keccak256(hexToBytes(bytes))));
}

type Bytes = Uint8Array;

function makeMerkleTree(leaves: Bytes[]): Bytes[] {
  leaves.forEach(checkValidMerkleNode);

  if (leaves.length === 0) {
    throw new Error("Expected non-zero number of leaves");
  }

  const tree = new Array<Bytes>(2 * leaves.length - 1);

  // Reverse each layer of leaves to match the leaf order in existing proofs
  const bottomLayerWidth =
    2 * (leaves.length - 2 ** Math.floor(Math.log2(leaves.length)));
  for (const [i, leaf] of leaves.entries()) {
    if (i < bottomLayerWidth) {
      tree[tree.length - bottomLayerWidth + i] = leaf;
    } else {
      tree[tree.length - bottomLayerWidth + i - leaves.length] = leaf;
    }
  }
  for (let i = tree.length - 1 - leaves.length; i >= 0; i--) {
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    tree[i] = hashPair(tree[leftChildIndex(i)]!, tree[rightChildIndex(i)]!);
  }

  return tree;
}

const checkValidMerkleNode = (node: Bytes) =>
  void (
    isValidMerkleNode(node) ||
    throwError("Merkle tree nodes must be Uint8Array of length 32")
  );
const hashPair = (a: Bytes, b: Bytes) => keccak256(concatBytes(...[a, b]));
const leftChildIndex = (i: number) => 2 * i + 1;
const rightChildIndex = (i: number) => 2 * i + 2;
const isValidMerkleNode = (node: Bytes) =>
  node instanceof Uint8Array && node.length === 32;

function throwError(message?: string): never {
  throw new Error(message);
}

// Remove validation as this would have to determine the order in which hashes are combined
// function processProof(leaf: Bytes, proof: Bytes[]): Bytes {
//   checkValidMerkleNode(leaf);
//   proof.forEach(checkValidMerkleNode);

//   return proof.reduce(hashPair, leaf);
// }
