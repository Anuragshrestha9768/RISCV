module alu_control (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    input [6:0] opcode,
    output reg [3:0] ALU_operation
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
  localparam ALU_PASS = 4'b1111;

  localparam OP_LUI   = 7'b0110111;

  always @(*) begin
    case (ALUOp)
      2'b00: begin
        // load/store, jal, jalr, auipc
        if (opcode == OP_LUI) begin
          ALU_operation = ALU_PASS;
        end else begin
          ALU_operation = ALU_ADD;
        end
      end

      2'b01: begin
        // branch - compute rs1 - rs2 for comparison
        ALU_operation = ALU_SUB;
      end

      2'b10: begin
        // i-type - use funct3
        case (funct3)
          3'b000: ALU_operation = ALU_ADD;
          3'b001: ALU_operation = ALU_SLL;
          3'b010: ALU_operation = ALU_SLT;
          3'b011: ALU_operation = ALU_SLTU;
          3'b100: ALU_operation = ALU_XOR;
          3'b101: ALU_operation = ALU_SRL;
          3'b110: ALU_operation = ALU_OR;
          3'b111: ALU_operation = ALU_AND;
        endcase

        // srai if funct7 bit 6 is set
        if (funct3 == 3'b101 && funct7[6] == 1'b1) begin
          ALU_operation = ALU_SRA;
        end
      end

      2'b11: begin
        // r-type - use funct7 and funct3
        case ({
          funct7, funct3
        })
          10'b0000000_000: ALU_operation = ALU_ADD;
          10'b0100000_000: ALU_operation = ALU_SUB;
          10'b0000000_001: ALU_operation = ALU_SLL;
          10'b0000000_010: ALU_operation = ALU_SLT;
          10'b0000000_011: ALU_operation = ALU_SLTU;
          10'b0000000_100: ALU_operation = ALU_XOR;
          10'b0000000_101: ALU_operation = ALU_SRL;
          10'b0100000_101: ALU_operation = ALU_SRA;
          10'b0000000_110: ALU_operation = ALU_OR;
          10'b0000000_111: ALU_operation = ALU_AND;
          default: ALU_operation = ALU_ADD;
        endcase
      end

      default: ALU_operation = ALU_ADD;
    endcase
  end

endmodule