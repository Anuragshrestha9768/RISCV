module cu (
    input [6:0] opcode,

    output reg RegWrite,
    output reg ALUSrc,
    output reg MemRead,
    output reg MemWrite,
    output reg MemToReg,
    output reg Branch,
    output reg Jump,
    output reg [1:0] ALUOp
);

  localparam OP_Rtype  = 7'b0110011;
  localparam OP_Itype  = 7'b0010011;
  localparam OP_Itype2 = 7'b0000011;
  localparam OP_Itype3 = 7'b1100111;
  localparam OP_Stype  = 7'b0100011;
  localparam OP_Btype  = 7'b1100011;
  localparam OP_Jtype  = 7'b1101111;
  localparam OP_LUI    = 7'b0110111;
  localparam OP_AUIPC  = 7'b0010111;

  always @(*) begin
    RegWrite = 1'b0;
    ALUSrc   = 1'b0;
    ALUOp    = 2'b00;
    MemRead  = 1'b0;
    MemWrite = 1'b0;
    MemToReg = 1'b0;
    Branch   = 1'b0;
    Jump     = 1'b0;

    case (opcode)
      OP_Rtype: begin
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ALUOp    = 2'b11;
      end

      OP_Itype: begin
        RegWrite = 1'b1;
        ALUSrc   = 1'b1;
        ALUOp    = 2'b10;
      end

      OP_Itype2: begin
        RegWrite = 1'b1;
        ALUSrc   = 1'b1;
        MemRead  = 1'b1;
        MemToReg = 1'b1;
        ALUOp    = 2'b00;
      end

      OP_Stype: begin
        RegWrite = 1'b0;
        MemWrite = 1'b1;
        ALUSrc   = 1'b1;
        ALUOp    = 2'b00;
      end

      OP_Btype: begin
        RegWrite = 1'b0;
        ALUSrc   = 1'b0;
        ALUOp    = 2'b01;
        Branch   = 1'b1;
      end

      OP_Jtype: begin
        RegWrite = 1'b1;
        Jump     = 1'b1;
        ALUSrc   = 1'b1;
        ALUOp    = 2'b00;
      end

      OP_Itype3: begin
        RegWrite = 1'b1;
        Jump     = 1'b1;
        ALUSrc   = 1'b1;
        ALUOp    = 2'b00;
      end

      OP_LUI: begin
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ALUOp    = 2'b00;
      end

      OP_AUIPC: begin
        RegWrite = 1'b1;
        ALUSrc   = 1'b1;
        ALUOp    = 2'b00;
      end

      default: begin
      end
    endcase
  end

endmodule