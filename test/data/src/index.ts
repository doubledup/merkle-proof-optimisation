import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import prettier from "prettier";
import { NoSortMerkleTree } from "./no-sort";

const leafIndex = 3;
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
  ["0x0000000000000000000000000000000000000000000000000000000000000016"],
  ["0x0000000000000000000000000000000000000000000000000000000000000017"],
  ["0x0000000000000000000000000000000000000000000000000000000000000018"],
  ["0x0000000000000000000000000000000000000000000000000000000000000019"]
];
const leafEncoding = ["bytes"];

console.log(`Proving leaf ${leafIndex} of ${leaves.length}\n`);

console.log(`leafIndex: ${leafIndex}`);
const formattedLeaves = leaves
  .map((leaf) => `    ${leafEncoding[0]}(hex"${(leaf[0] ?? "no leaf").slice(2)}"),`)
  .join("\n");
console.log(
  `leaves: \n[\n${formattedLeaves.slice(0, formattedLeaves.length - 1)}\n]`
);
console.log();

console.log("Unoptimised proof:");
printTestData(NoSortMerkleTree.of(leaves, leafEncoding), leafIndex);
console.log();
console.log("Optimised proof:");
printTestData(StandardMerkleTree.of(leaves, leafEncoding), leafIndex);

function printTestData<T extends unknown[]>(
  tree: StandardMerkleTree<T>,
  leafInd: number
) {
  console.log(`expectedRoot: hex"${tree.root.slice(2)}"`);

  const treeData = tree.dump();
  const leaf = treeData.values.find((v) => v.value === leaves[leafInd]);
  if (!leaf) {
    console.log("No matching leaf found");
    return;
  } else {
    // Uncomment this and move the imports to the top to show the intermediate values when hashing a leaf
    // import { defaultAbiCoder } from "@ethersproject/abi";
    // import { doubleHash } from "./no-sort";
    // console.log(`Raw leaf: ${JSON.stringify(leaf.value)}`);
    // const encodedLeaf = defaultAbiCoder.encode(leafEncoding, leaf.value);
    // console.log(`Encoded leaf: ${encodedLeaf}`);
    // console.log(`Hashed leaf: ${doubleHash(encodedLeaf)}`);
    //
    // Uncomment this to show the leaf's tree index & hash
    // const leafHash = {
    //   index: leaf.treeIndex,
    //   hash: treeData.tree[leaf.treeIndex] ?? "no hash found",
    // };
    // console.log(
    //   `Leaf (tree index ${leafHash.index}): ${leafHash.hash.slice(2)}`
    // );
  }

  const proof = tree.getProof(leafInd);
  console.log(
    `proof: ${prettier.format(JSON.stringify(proof.map((p) => p.slice(2))), {
      parser: "json",
    })}`.trim()
  );

  console.log(
    `hashSides (for unoptimised proof): ${JSON.stringify(
      hashSides(leaf.treeIndex, leaves.length)
    ).trim()}`
  );

  // // Uncomment this to show the Merkle tree structure
  // console.log(`Tree:\n${tree.render()}`.trim());

  // // Uncomment this to show the leaf hashes in original order
  // const leafHashes = treeData.values.map((v) => treeData.tree[v.treeIndex]);
  // console.log(
  //   `Leaves: ${prettier.format(JSON.stringify(leafHashes), {
  //     parser: "json",
  //   })}`.trim()
  // );

  // // Uncomment this to show the full StandardMerkleTree
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

  // Uncomment this to show the tree index for each intermediate hash, starting with the leaf
  // console.log(`Tree indices for hashSides: ${JSON.stringify(indices)}`);

  // true when proof hash is on the left, so the accumulated hash is on the right
  // right children have an even index in the tree
  return indices.map((n) => n % 2 == 0);
}
