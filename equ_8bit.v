module equ_8bit(
    input  wire signed [7:0] x,
    input  wire signed [7:0] y,
    output wire              r
);

wire t1[7:0], t2[7:0];

assign {t1[7],t1[6],t1[5],t1[4],t1[3],t1[2],t1[1],t1[0]} = {y[7],y[6],y[5],y[4],y[3],y[2],y[1],y[0]} ~^ {x[7],x[6],x[5],x[4],x[3],x[2],x[1],x[0]};
assign r = & {t1[7],t1[6],t1[5],t1[4],t1[3],t1[2],t1[1],t1[0]};

endmodule
