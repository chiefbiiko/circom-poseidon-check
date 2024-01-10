#!/bin/bash -e
POWERS_OF_TAU=15
mkdir -p artifacts/circuits
if [ ! -f artifacts/circuits/ptau$POWERS_OF_TAU ]; then
  curl -L https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_$POWERS_OF_TAU.ptau --create-dirs -o artifacts/circuits/ptau$POWERS_OF_TAU
fi
cd ./artifacts/circuits
circom --version # v2.1.7
circom --O2 --verbose --inspect ../../circuits/check.circom --r1cs --wasm --sym --prime bn128
cp ./check_js/check.wasm ./check.wasm
cd ../..
./node_modules/.bin/snarkjs groth16 setup artifacts/circuits/check.r1cs artifacts/circuits/ptau$POWERS_OF_TAU artifacts/circuits/tmp_check.zkey
./node_modules/.bin/snarkjs zkey contribute artifacts/circuits/tmp_check.zkey artifacts/circuits/check.zkey --name="alice" -v -e="aaa"
./node_modules/.bin/snarkjs r1cs info artifacts/circuits/check.r1cs