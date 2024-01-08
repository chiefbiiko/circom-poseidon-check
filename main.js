const {buildPoseidon} = require('circomlibjs')
const { BigNumber } = require('@ethersproject/bignumber')

main()

async function main() {
    // async function loadDeps() {
    //     const { groth16 } = await import('snarkjs')
    //     // const { utils: ffutils } = await import('ffjavascript')
    //     return { groth16, ffutils }
    //   }
      
      async function prove() {
        const { groth16 } = await import('snarkjs')
        // const { groth16 } = await loadDeps()
        // console.log("inputs", input)
        // console.log("sinputs", ffutils.stringifyBigInts(input))
        const { proof } = await groth16.fullProve(
        //   ffutils.stringifyBigInts(input),
          {},
          "artifacts/circuits/check.wasm",
          "artifacts/circuits/check.zkey"
        )
        return (
          '0x' +
          bigNumToHex(proof.pi_a[0]).slice(2) +
          bigNumToHex(proof.pi_a[1]).slice(2) +
          bigNumToHex(proof.pi_b[0][1]).slice(2) +
          bigNumToHex(proof.pi_b[0][0]).slice(2) +
          bigNumToHex(proof.pi_b[1][1]).slice(2) +
          bigNumToHex(proof.pi_b[1][0]).slice(2) +
          bigNumToHex(proof.pi_c[0]).slice(2) +
          bigNumToHex(proof.pi_c[1]).slice(2)
        )
      }

      console.log("circom zero hash ...")
      await prove()

    const poseidon = await buildPoseidon()
    const zeroHash = poseidon(["0"])
    console.log("js zeroHash", zeroHash)
}

function bigNumToHex(number, length = 32) {
    let result =
      '0x' +
      (number instanceof Buffer
        ? number.toString('hex')
        : BigNumber.from(number).toHexString().replace('0x', '')
      ).padStart(length * 2, '0')
    if (result.indexOf('-') > -1) {
      result = '-' + result.replace('-', '')
    }
    return result
  }