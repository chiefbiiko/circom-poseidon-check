# circom-poseidon-check

We have a Circom circuit that fails after we have done a major upgrade from circom 0.5.45 to 2.1.7. After some debugging it is clear that the Poseidon hashes computed via `circomlibjs` do not match with those calculated with `circomlib` within our circuit, see [test.js](./test.js).

```
npm install
npm run build
npm test
```

Needs `circom@2.1.7` installed on the system.