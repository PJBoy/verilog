`include "./round.v"
`include "./key_schedule.v"

module encrypt_v3(
    input  wire clk,

    input  wire [79:0] K,
    input  wire [63:0] M,
    output wire [63:0] C
);

reg [63:0] x_i [0:30];
reg [79:0] k_i [0:30];
wire [63:0] x_r [0:30];
wire [79:0] k_r [0:30];

genvar i;   // Generates a tonne of arguement width warnings, but stable
generate
    for (i=5'd29; i>=0; i=i-1)
    begin: d
        round g0(.r(x_r[i+1]), .x(x_i[i]), .k(k_i[i]));
        key_schedule g1(.r(k_r[i+1]), .x(k_i[i]), .i(i+2));
    end
endgenerate
round g2(.r(x_r[0]), .x(M), .k(K));
key_schedule g3(.r(k_r[0]), .x(K), .i(5'd1));
key_addition g4(.r(C), .x(x_i[30]), .k(k_i[30]));

integer ii;
always @(negedge clk)
begin
    for(ii=0; ii<31; ii=ii+1)
    begin
        x_i[ii] = x_r[ii];
        k_i[ii] = k_r[ii];
    end
end

endmodule
