`include "./round.v"
`include "./key_schedule.v"

module encrypt_v1(
    input  wire [79:0] K,   // Key to use for encryption
    input  wire [63:0] M,   // Plaintext message to encrypt
    output wire [63:0] C    // Encrypted ciphertext message
);

wire [63:0] x_r [0:30];
wire [79:0] k_r [0:30];

round g0(.r(x_r[0]), .x(M), .k(K));
key_schedule g1(.r(k_r[0]), .x(K), .i(5'd1));
genvar i;   // Generates a tonne of arguement width warnings, but stable
generate
    for (i=5'd0; i<30; i=i+1)
    begin: d
        round g2(.r(x_r[i+1]), .x(x_r[i]), .k(k_r[i]));
        key_schedule g3(.r(k_r[i+1]), .x(k_r[i]), .i(i+2));
    end
endgenerate
key_addition g4(.r(C), .x(x_r[30]), .k(k_r[30]));

endmodule
