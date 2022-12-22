import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import prettier from "prettier";
import { NoSortMerkleTree } from "./no-sort";

const values = [
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

const standardTree = StandardMerkleTree.of(values, ["address"]);
console.log("Standard Merkle Root:", standardTree.root);
console.log(
  prettier.format(JSON.stringify(standardTree.dump()), { parser: "json" })
);

const noSortTree = NoSortMerkleTree.of(values, ["address"]);
console.log("Unsorted Merkle Root:", noSortTree.root);
console.log(
  prettier.format(JSON.stringify(noSortTree.dump()), { parser: "json" })
);
