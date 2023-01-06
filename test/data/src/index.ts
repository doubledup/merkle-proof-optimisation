import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import prettier from "prettier";
import { defaultAbiCoder } from "@ethersproject/abi";
import { doubleHash } from "./no-sort";
import { NoSortMerkleTree } from "./no-sort";

const leafNumber = 12;
// each value must be an array because of the types used in StandardMerkleTree
const leaves = [
  ["0x0000000000000000000000000000000000000000000000000000000000000000"],
  ["0x0000000000000000000000000000000000000000000000000000000000000001"],
  ["0x0000000000000000000000000000000000000000000000000000000000000002"],
  ["0x0000000000000000000000000000000000000000000000000000000000000003"],
  ["0x0000000000000000000000000000000000000000000000000000000000000004"],
  ["0x0000000000000000000000000000000000000000000000000000000000000005"],
  ["0x0000000000000000000000000000000000000000000000000000000000000006"],
  ["0x0000000000000000000000000000000000000000000000000000000000000007"],
  ["0x0000000000000000000000000000000000000000000000000000000000000008"],
  ["0x0000000000000000000000000000000000000000000000000000000000000009"],
  ["0x0000000000000000000000000000000000000000000000000000000000000010"],
  ["0x0000000000000000000000000000000000000000000000000000000000000011"],
  ["0x0000000000000000000000000000000000000000000000000000000000000012"],
  ["0x0000000000000000000000000000000000000000000000000000000000000013"],
  ["0x0000000000000000000000000000000000000000000000000000000000000014"],
  ["0x0000000000000000000000000000000000000000000000000000000000000015"],
];
const leafEncoding = ["bytes"];

console.log(`Proving leaf ${leafNumber} of ${leaves.length}\n`);

console.log("Optimised Merkle tree:");
printTestData(StandardMerkleTree.of(leaves, leafEncoding), leafNumber);
console.log();
console.log("Unoptimised Merkle tree");
printTestData(NoSortMerkleTree.of(leaves, leafEncoding), leafNumber);

function printTestData<T extends unknown[]>(
  tree: StandardMerkleTree<T>,
  leafIndex: number
) {
  console.log(`Root: ${tree.root}`);

  const treeData = tree.dump();
  const leaf = treeData.values.find((v) => v.value === leaves[leafIndex]);
  if (!leaf) {
    console.log("No matching leaf found");
    return;
  } else {
    const leafHash = {
      index: leaf.treeIndex,
      hash: treeData.tree[leaf.treeIndex] ?? "no hash found",
    };

    console.log(`Raw leaf: ${JSON.stringify(leaf.value)}`);
    const encodedLeaf = defaultAbiCoder.encode(leafEncoding, leaf.value);
    console.log(`Encoded leaf: ${encodedLeaf}`);
    console.log(`Hashed leaf: ${doubleHash(encodedLeaf)}`);

    console.log(`Leaf: ${leafHash.index}) ${leafHash.hash.slice(2)}`);
  }

  const proof = tree.getProof(leafIndex);
  console.log(
    `Merkle Proof: ${prettier.format(
      JSON.stringify(proof.map((p) => p.slice(2))),
      {
        parser: "json",
      }
    )}`.trim()
  );

  console.log(
    `Hash sides (for unoptimised proof): ${JSON.stringify(
      hashSides(leaf.treeIndex, leaves.length)
    )}`
  );

  console.log(`Tree:\n${tree.render()}`.trim());

  // // Uncomment this to see the leaf hashes in original order
  // const leafHashes = treeData.values.map((v) => treeData.tree[v.treeIndex]);
  // console.log(
  //   `Leaves: ${prettier.format(JSON.stringify(leafHashes), {
  //     parser: "json",
  //   })}`.trim()
  // );

  // // Uncomment this to see the full StandardMerkleTree
  // console.log(
  //   `Tree dump: ${prettier.format(JSON.stringify(treeData), {
  //     parser: "json",
  //   })}`
  // );
}

function hashSides(index: number, width: number): boolean[] {
  const proofLength = Math.ceil(Math.log2(width));

  function parentIndex(i: number): number {
    return Math.floor((i - 1) / 2);
  }

  // indices of the accumulated hashes after they're combined with the proof hashes
  const indices = Array.from(Array(proofLength - 1).keys()).reduce(
    (acc, _) => acc.concat([parentIndex(acc[acc.length - 1]!)]),
    [index]
  );

  console.log(`Tree indices for hashSides: ${JSON.stringify(indices)}`);

  // true when proof hash is on the left, so the accumulated hash is on the right
  // right children have an even index in the tree
  return indices.map((n) => n % 2 == 0);
}
