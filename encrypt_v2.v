`include "./round.v"
`include "./key_schedule.v"

module encrypt_v2(
    input  wire clk,    // Signals next step
    input  wire req,    // Signals start of routine
    output wire ack,    // Set when finished routine
    input  wire [79:0] K,   // Key to use for encryption
    input  wire [63:0] M,   // Plaintext message to encrypt
    output wire [63:0] C    // Encrypted ciphertext message
);

reg ack_i;
reg [4:0] i;
reg [63:0] x_i;
reg [79:0] k_i;
wire [63:0] x_r;
wire [79:0] k_r;

round g0(.r(x_r), .x(x_i), .k(k_i));
key_schedule g1(.r(k_r), .x(k_i), .i(i));
key_addition g2(.r(C), .x(x_r), .k(k_r));
assign ack = ack_i;

always @(posedge req)
begin
    x_i = M;
    k_i = K;
    assign i = 1;
end

always @(negedge req)
    assign ack_i = 1'b0;

always @(posedge clk)
begin
    if (req == 1'b1)
    begin
        if (i == 5'd31)
            assign ack_i = 1'b1;
        x_i = x_r;
        k_i = k_r;
        assign i = i+1;
    end
end

endmodule
