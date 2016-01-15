`ifndef util
    `define util
    `include "./util.v"
`endif

module round(
    input  wire [63:0] x,   // State produced as output by the (i-1)th round
    input  wire [79:0] k,   // Key material produced by the ith round
    output wire [63:0] r    // State accepted as input by the (i+1)th round
);

wire [63:0] key_r;
key_addition g0(.r(key_r), .x(x), .k(k));

wire [3:0] split_r [0:15];
split_0 g1(
    .rF(split_r[15]),
    .rE(split_r[14]),
    .rD(split_r[13]),
    .rC(split_r[12]),
    .rB(split_r[11]),
    .rA(split_r[10]),
    .r9(split_r[9]),
    .r8(split_r[8]),
    .r7(split_r[7]),
    .r6(split_r[6]),
    .r5(split_r[5]),
    .r4(split_r[4]),
    .r3(split_r[3]),
    .r2(split_r[2]),
    .r1(split_r[1]),
    .r0(split_r[0]),
    .x(key_r)
);

wire [3:0] sbox_r [0:15];
genvar i;
generate
    for (i=15; i>=0; i=i-1)
        sbox g2(.r(sbox_r[i]), .x(split_r[i]));
endgenerate

wire [63:0] merge_r;
merge_0 g3(
    .r(merge_r),
    .xF(sbox_r[15]),
    .xE(sbox_r[14]),
    .xD(sbox_r[13]),
    .xC(sbox_r[12]),
    .xB(sbox_r[11]),
    .xA(sbox_r[10]),
    .x9(sbox_r[9]),
    .x8(sbox_r[8]),
    .x7(sbox_r[7]),
    .x6(sbox_r[6]),
    .x5(sbox_r[5]),
    .x4(sbox_r[4]),
    .x3(sbox_r[3]),
    .x2(sbox_r[2]),
    .x1(sbox_r[1]),
    .x0(sbox_r[0])
);

perm g4(.r(r), .x(merge_r));

endmodule
