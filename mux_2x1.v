module mux_2x1 (
    input [31:0] x,
    input [31:0] y,
    input s,
    output [31:0] z
);

  assign z = (s == 1'b0) ? x : y;

endmodule