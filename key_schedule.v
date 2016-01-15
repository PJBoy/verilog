`ifndef util
    `define util
    `include "./util.v"
`endif

module key_schedule(
    input  wire [79:0] x,   // Key material produced as output by the (i-1)th round
    input  wire [4:0] i,    // The round counter
    output wire [79:0] r    // Key material accepted as input by the (i+1)th round
);

// Rotation left by 61, not bothering with bits 76..79 and 15..19
assign {r[75:61], r[60:20], r[14:0]} = {x[14:0], x[79:39], x[33:19]};

// S-box bits 15..18
sbox g0(.r(r[79:76]), .x(x[18:15]));

// XOR bits 34..38 with i
assign r[19:15] = x[38:34] ^ i;

endmodule
