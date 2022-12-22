import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import { keccak256 } from "ethereum-cryptography/keccak";
import {
  hexToBytes,
  concatBytes,
  bytesToHex,
} from "ethereum-cryptography/utils";
import { defaultAbiCoder } from "@ethersproject/abi";

export const NoSortMerkleTree = {
  of: function<T extends unknown[]>(
    values: T[],
    leafEncoding: string[]
  ): StandardMerkleTree<T> {
    const hashedValues = values.map((value, valueIndex) => ({
      value,
      valueIndex,
      hash: standardLeafHash(value, leafEncoding),
    }));

    const tree = makeMerkleTree(hashedValues.map((v) => v.hash));

    const indexedValues = values.map((value) => ({ value, treeIndex: 0 }));
    for (const [leafIndex, { valueIndex }] of hashedValues.entries()) {
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      indexedValues[valueIndex]!.treeIndex = tree.length - leafIndex - 1;
    }

    return StandardMerkleTree.load({
      tree: tree.map(bytesToHex),
      values: indexedValues,
      leafEncoding,
      format: "standard-v1",
    });
  }
}

function standardLeafHash<T extends unknown[]>(
  value: T,
  types: string[]
): Bytes {
  return keccak256(keccak256(hexToBytes(defaultAbiCoder.encode(types, value))));
}

type Bytes = Uint8Array;

function compareBytes(a: Bytes, b: Bytes): number {
  const n = Math.min(a.length, b.length);

  for (let i = 0; i < n; i++) {
    if (a[i] !== b[i]) {
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      return a[i]! - b[i]!;
    }
  }

  return a.length - b.length;
}

function makeMerkleTree(leaves: Bytes[]): Bytes[] {
  leaves.forEach(checkValidMerkleNode);

  if (leaves.length === 0) {
    throw new Error("Expected non-zero number of leaves");
  }

  const tree = new Array<Bytes>(2 * leaves.length - 1);

  for (const [i, leaf] of leaves.entries()) {
    tree[tree.length - 1 - i] = leaf;
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
const hashPair = (a: Bytes, b: Bytes) =>
  keccak256(concatBytes(...[a, b].sort(compareBytes)));
const leftChildIndex = (i: number) => 2 * i + 1;
const rightChildIndex = (i: number) => 2 * i + 2;
const isValidMerkleNode = (node: Bytes) =>
  node instanceof Uint8Array && node.length === 32;

function throwError(message?: string): never {
  throw new Error(message);
}
