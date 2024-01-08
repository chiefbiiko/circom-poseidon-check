pragma circom 2.1.7;

include "../node_modules/circomlib/circuits/poseidon.circom";

template Check() {
    signal output zero_hash;
    component hasher = Poseidon(1);
    hasher.inputs[0] <== 0;
    zero_hash <== hasher.out;
    log(">> zero hash", zero_hash);
}

component main = Check();