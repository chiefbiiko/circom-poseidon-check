const assert = require("assert")
const { buildPoseidon } = require("circomlibjs")
const prove = require("./index")

describe("Circom Poseidon", () => {
  let poseidon
  before(async () => {
    poseidon = await buildPoseidon()
  })

  it("should yield same zero hash from circomlib and circomlibjs", async () => {
    const zeroHashA = Buffer.from(poseidon(["0"])).toString("hex")
    const { proof, publicSignals:[zeroHashB] } = await prove("0")
    assert.equal(zeroHashB, zeroHashA)
  })
})
