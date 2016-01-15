// Direct subtraction; result will be overflow != negative.
// Iff y>x, x-y<0; iff subtraction overflows, n will be inverted

module sub_1bit(input wire x, y, ci, output wire co);

wire t0, t1, t2;

and (t0, y, ci);
nor (t1, y, ci);
    nor (t2, x, t1);
        or (co, t0, t2);

endmodule

module lth_8bit(
    input  wire signed [7:0] x,
    input  wire signed [7:0] y,
    output                   r
);

wire c[6:0], of, n;

// Bit 0
wire t0;
not (t0, x[0]);
    and (c[0], t0, y[0]);

// Bit 1..6
sub_1bit g1(.co(c[1]), .x(x[1]), .y(y[1]), .ci(c[0]));
sub_1bit g2(.co(c[2]), .x(x[2]), .y(y[2]), .ci(c[1]));
sub_1bit g3(.co(c[3]), .x(x[3]), .y(y[3]), .ci(c[2]));
sub_1bit g4(.co(c[4]), .x(x[4]), .y(y[4]), .ci(c[3]));
sub_1bit g5(.co(c[5]), .x(x[5]), .y(y[5]), .ci(c[4]));
sub_1bit g6(.co(c[6]), .x(x[6]), .y(y[6]), .ci(c[5]));

// Bit 7
wire t1, t2, t3;
xnor (t1, x[7], y[7]);          // Parameter sign-equivalence
xor (t2, x[7], y[7]);           // Half-sub
    xor (n, t2, c[6]);          // Result sign
        xor (t3, x[7], n);      // Sign exclusivity
            and (of, t1, t3);   // Overflow
// Finally
xor (r, of, n);

endmodule // 32 gates, 30 wires


//-----------------------------------------------------------------------------------------------------------


// Subtraction by negation and addition (borrowing largely from sub_8bit;
// result will be overflow != negative

module add_1bit(input wire x, y, ci, output wire co);

wire t0, t1, t2;

and (t0, x, y);
or (t1, x, y);
    and (t2, t1, ci);
        or (co, t0, t2);

endmodule

module lth_8bit_alternate_a(
    input  wire signed [7:0] x,
    input  wire signed [7:0] y,
    output                   r
);

wire yy[7:0], c[7:0], of, n;

assign {yy[7],yy[6],yy[5],yy[4],yy[3],yy[2],yy[1],yy[0]} = ~{y[7],y[6],y[5],y[4],y[3],y[2],y[1],y[0]};
assign c[0] = 1'b1;

// Bit 0..6
add_1bit g0(.co(c[1]), .x(x[0]), .y(yy[0]), .ci(c[0]));
add_1bit g1(.co(c[2]), .x(x[1]), .y(yy[1]), .ci(c[1]));
add_1bit g2(.co(c[3]), .x(x[2]), .y(yy[2]), .ci(c[2]));
add_1bit g3(.co(c[4]), .x(x[3]), .y(yy[3]), .ci(c[3]));
add_1bit g4(.co(c[5]), .x(x[4]), .y(yy[4]), .ci(c[4]));
add_1bit g5(.co(c[6]), .x(x[5]), .y(yy[5]), .ci(c[5]));
add_1bit g6(.co(c[7]), .x(x[6]), .y(yy[6]), .ci(c[6]));

// Bit 7
wire t0, t1, t2;
xnor (t0, x[7], yy[7]);         // Parameter sign-equivalence
xor (t1, x[7], yy[7]);          // Half-add
    xor (n, t1, c[7]);          // Result sign
        xor (t2, x[7], n);      // Sign exclusivity
            and (of, t0, t2);   // Overflow
// Finally
xor (r, of, n);

endmodule // 43 gates, 43 wires


//-----------------------------------------------------------------------------------------------------------


// Compare bits from right to left;
// the result will be y[n] for max(n)<7 && y[n]!=x[n],
// or x[7] if y[6:0]==x[6:0], or 0 if y==x

module compare(input wire x, y, tin, output wire tout);

wire t0, t1, t2, t3, t4;

not (t0, x);
not (t1, y);
    and (t2, t0, y);            // True iff y>x
    nand (t3, t1, x);           // False iff x>y
        or (t4, t2, tin);       // y>x: explicitly set t
            and (tout, t3, t4); // x>y: explicitly clear t

endmodule

module lth_8bit_alternate_b(
    input  wire signed [7:0] x,
    input  wire signed [7:0] y,
    output wire              r
);

wire t0[7:0];

wire t1;
not (t1, x[0]);
    and (t0[0], t1, y[0]);  // True iff y[0]>x[0]

compare g1(.tout(t0[1]), .x(x[1]), .y(y[1]), .tin(t0[0]));
compare g2(.tout(t0[2]), .x(x[2]), .y(y[2]), .tin(t0[1]));
compare g3(.tout(t0[3]), .x(x[3]), .y(y[3]), .tin(t0[2]));
compare g4(.tout(t0[4]), .x(x[4]), .y(y[4]), .tin(t0[3]));
compare g5(.tout(t0[5]), .x(x[5]), .y(y[5]), .tin(t0[4]));
compare g6(.tout(t0[6]), .x(x[6]), .y(y[6]), .tin(t0[5]));
compare g7(.tout(r),     .x(y[7]), .y(x[7]), .tin(t0[6]));

endmodule // 44 gates, 44 wires
