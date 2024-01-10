const { groth16 } = require("snarkjs")

module.exports = async function prove(msg) {
  return await groth16.fullProve(
    { msg: msg.toString() },
    "artifacts/circuits/check.wasm",
    "artifacts/circuits/check.zkey"
  )
}
