# Merkle proof optimisation

To run the [tests](test/MerkleProof.t.sol), install [foundry](https://getfoundry.sh/) and run `forge test` from the root of this repository.

To get an estimate of the gas consumption of each test, see the output from `forge test`. Each passing test produces a line ending in
`(gas: _)`. Alternatively, run `forge snapshot` and view the [results](.gas-snapshot).

## Changing the leaves used

- Update the `leaves` & `leafIndex` in the [test data generator](test/data/src/index.ts), optionally changing the `leafEncoding` if
necessary.
- Ensure [pnpm](https://pnpm.io/) is installed and run the test data generator from its directory with
  `cd test/data/ && pnpm start && cd -`.
- Use the output of the test data generator to update the following variables in the [tests](test/MerkleProof.t.sol):
    - At the top level of the contract:
        - `leafIndex`
        - `leaves`
    - Within each test case:
        - `expectedRoot`
        - `proof`
        - `hashSides` (for the test that uses this)
- Run `forge test` or `forge snapshot` as before.
