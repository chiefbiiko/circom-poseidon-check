#!/bin/bash -e

POWERS_OF_TAU=15
mkdir -p artifacts/circuits
if [ ! -f artifacts/circuits/ptau$POWERS_OF_TAU ]; then
  echo "Downloading powers of tau $POWERS_OF_TAU"
  curl -L https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_$POWERS_OF_TAU.ptau --create-dirs -o artifacts/circuits/ptau$POWERS_OF_TAU
fi

echo "Compile the circuit"
cd ./artifacts/circuits
circom --version # v2.1.7
circom --O2 --verbose --inspect ../../circuits/check.circom --r1cs --wasm --sym --prime bn128
cp ./check_js/check.wasm ./check.wasm
cd ../..

echo "Init .zkey file"
./node_modules/.bin/snarkjs groth16 setup artifacts/circuits/check.r1cs artifacts/circuits/ptau$POWERS_OF_TAU artifacts/circuits/tmp_check.zkey

echo "Contribute to phase 2 of the ceremony"
./node_modules/.bin/snarkjs zkey contribute artifacts/circuits/tmp_check.zkey artifacts/circuits/check.zkey --name="alice" -v -e="qwe"

echo "Generate Solidity verifier"
./node_modules/.bin/snarkjs zkey export solidityverifier artifacts/circuits/check.zkey artifacts/circuits/Verifier$1.sol

echo "Update the contract name in the Solidity verifier"
sed -i.bak "s/contract Groth16Verifier/contract Verifier${1}/g" artifacts/circuits/Verifier$1.sol

./node_modules/.bin/snarkjs r1cs info artifacts/circuits/check.r1cs