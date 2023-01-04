import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import prettier from "prettier";
import { defaultAbiCoder } from "@ethersproject/abi";
import { doubleHash } from "./no-sort";
// import { NoSortMerkleTree } from "./no-sort";

const leafNumber = 7;
// each value must be an array because of the types used in StandardMerkleTree
const leaves = [
  ["0x1111111111111111111111111111111111111111"],
  ["0x2222222222222222222222222222222222222222"],
  ["0x3333333333333333333333333333333333333333"],
  ["0x4444444444444444444444444444444444444444"],
  ["0x5555555555555555555555555555555555555555"],
  ["0x6666666666666666666666666666666666666666"],
  ["0x7777777777777777777777777777777777777777"],
  ["0x8888888888888888888888888888888888888888"],
  ["0x9999999999999999999999999999999999999999"],
  ["0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"],
  ["0xBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"],
  ["0xCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"],
  ["0xDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD"],
  ["0xEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"],
  ["0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"],
];

console.log(`Proving leaf ${leafNumber} of ${leaves.length}\n`);

console.log("Standard Merkle tree:");
printTestData(StandardMerkleTree.of(leaves, ["bytes"]), leafNumber);
// console.log('Unoptimised Merkle tree');
// printTestData(NoSortMerkleTree.of(leaves, ["address"]), leafNumber);

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
    const encodedLeaf = defaultAbiCoder.encode(["bytes"], leaf.value);
    console.log(`Encoded leaf: ${encodedLeaf}`);
    console.log(`Hashed leaf: ${doubleHash(encodedLeaf)}`);

    console.log(`Leaf: ${leafHash.index}) ${leafHash.hash.slice(2)}`);
  }

  console.log(
    `Merkle Proof: ${prettier.format(
      JSON.stringify(tree.getProof(leafIndex).map((p) => p.slice(2))),
      {
        parser: "json",
      }
    )}`.trim()
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
