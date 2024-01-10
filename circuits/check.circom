pragma circom 2.1.7;

include "../node_modules/circomlib/circuits/poseidon.circom";

template Check() {
    signal input msg;
    signal output hash;
    component hasher = Poseidon(1);
    hasher.inputs[0] <== msg;
    hash <== hasher.out;
}

component main { public [msg] } = Check();