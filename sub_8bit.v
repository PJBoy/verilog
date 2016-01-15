module hadd_1bit(input wire x, y, output wire r, c);

xor (r, x, y);
and (c, x, y);

endmodule

module add_1bit(input wire x, y, ci, output wire r, co);

wire t0, t1, t2;

hadd_1bit g0(.r(t0), .c(t1), .x(x), .y(y));
    hadd_1bit g1(.r(r), .c(t2), .x(t0), .y(ci));
        or (co, t1, t2);

endmodule

module sub_8bit(
    input  wire              op,
    input  wire              ci,
    input  wire signed [7:0] x,
    input  wire signed [7:0] y,
    output wire              of,
    output wire signed [7:0] r
);

wire yy[7:0], co[7:0];

assign {yy[7],yy[6],yy[5],yy[4],yy[3],yy[2],yy[1],yy[0], co[0]} = {y[7],y[6],y[5],y[4],y[3],y[2],y[1],y[0], ci} ^ {9{op}};

// Bit 0..6
add_1bit g0(.r(r[0]), .co(co[1]), .x(x[0]), .y(yy[0]), .ci(co[0]));
add_1bit g1(.r(r[1]), .co(co[2]), .x(x[1]), .y(yy[1]), .ci(co[1]));
add_1bit g2(.r(r[2]), .co(co[3]), .x(x[2]), .y(yy[2]), .ci(co[2]));
add_1bit g3(.r(r[3]), .co(co[4]), .x(x[3]), .y(yy[3]), .ci(co[3]));
add_1bit g4(.r(r[4]), .co(co[5]), .x(x[4]), .y(yy[4]), .ci(co[4]));
add_1bit g5(.r(r[5]), .co(co[6]), .x(x[5]), .y(yy[5]), .ci(co[5]));
add_1bit g6(.r(r[6]), .co(co[7]), .x(x[6]), .y(yy[6]), .ci(co[6]));

// Bit 7
wire t0, t1, t2, t3;
xnor (t0, x[7], yy[7]);         // Parameter sign-equivalence
xor (t1, x[7], yy[7]);          // Half-add
    xor (r[7], t1, co[7]);      // Full-add
    xor (t2, t1, co[7]);        // Result sign
        xor (t3, x[7], t2);     // Sign exclusivity
            and (of, t0, t3);   // Overflow
endmodule

