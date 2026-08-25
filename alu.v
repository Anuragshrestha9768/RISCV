module alu (
    input [31:0] src_a,
    input [31:0] src_b,
    input [3:0] alu_control,
    output reg [31:0] result,
    output reg zero
);

  // alu operation encodings
  localparam ALU_ADD  = 4'b0010;
  localparam ALU_SUB  = 4'b0110;
  localparam ALU_AND  = 4'b0000;
  localparam ALU_OR   = 4'b0001;
  localparam ALU_XOR  = 4'b0100;
  localparam ALU_SLL  = 4'b0111;
  localparam ALU_SRL  = 4'b1000;
  localparam ALU_SRA  = 4'b1001;
  localparam ALU_SLT  = 4'b1010;
  localparam ALU_SLTU = 4'b1011;
  localparam ALU_PASS = 4'b1111;  // pass through for lui

  always @(*) begin
    case (alu_control)
      ALU_ADD:  result = src_a + src_b;
      ALU_SUB:  result = src_a - src_b;
      ALU_AND:  result = src_a & src_b;
      ALU_OR:   result = src_a | src_b;
      ALU_XOR:  result = src_a ^ src_b;
      ALU_SLL:  result = src_a << src_b[4:0];
      ALU_SRL:  result = src_a >> src_b[4:0];
      ALU_SRA:  result = $signed(src_a) >>> src_b[4:0];
      ALU_SLT:  result = ($signed(src_a) < $signed(src_b)) ? 32'd1 : 32'd0;
      ALU_SLTU: result = (src_a < src_b) ? 32'd1 : 32'd0;
      ALU_PASS: result = src_b;
      default:  result = 32'd0;
    endcase

    zero = (result == 32'd0) ? 1'b1 : 1'b0;
  end

endmodule