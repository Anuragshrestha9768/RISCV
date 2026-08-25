module immediate_gen (
    input [31:0] instruction,
    input [6:0] opcode,
    output reg [31:0] imm_extended,
    output reg [31:0] branch_imm
);

  localparam OP_Itype  = 7'b0010011;
  localparam OP_Itype2 = 7'b0000011;
  localparam OP_Itype3 = 7'b1100111;
  localparam OP_Stype  = 7'b0100011;
  localparam OP_Btype  = 7'b1100011;
  localparam OP_Jtype  = 7'b1101111;
  localparam OP_LUI    = 7'b0110111;
  localparam OP_AUIPC  = 7'b0010111;

  always @(*) begin
    imm_extended = 32'h00000000;
    branch_imm = 32'h00000000;

    case (opcode)
      OP_Itype, OP_Itype2, OP_Itype3: begin
        // I-type: sign-extended 12-bit immediate
        imm_extended = {{20{instruction[31]}}, instruction[31:20]};
      end

      OP_Stype: begin
        // S-type: sign-extended 12-bit immediate
        imm_extended = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
      end

      OP_Btype: begin
        // B-type: sign-extended 13-bit immediate (12-bit value shifted by 1)
        branch_imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
      end

      OP_LUI, OP_AUIPC: begin
        // U-type: 20-bit immediate shifted by 12
        imm_extended = {instruction[31:12], 12'b0};
      end

      OP_Jtype: begin
        // J-type: sign-extended 21-bit immediate (20-bit value shifted by 1)
        branch_imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
      end

      default: begin
        imm_extended = 32'h00000000;
        branch_imm = 32'h00000000;
      end
    endcase
  end

endmodule