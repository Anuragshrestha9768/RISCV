module riscv_top (
    input CLK,
    input RESET,
    output [31:0] pc_out,
    output [31:0] inst_out,
    output [31:0] alu_result_out
);

  // control signals
  wire RegWrite, ALUSrc, MemRead, MemWrite, MemToReg, Branch, Jump;
  wire [1:0] ALUOp;
  wire [3:0] alu_control;

  // pc
  reg [31:0] PC;
  wire [31:0] next_PC;
  wire PCWrite;

  // instruction memory
  wire [31:0] inst;

  // register file
  wire [31:0] rs1_data, rs2_data, write_data;

  // immediate generator
  wire [31:0] imm_extended;
  wire [31:0] branch_imm;

  // alu
  wire [31:0] alu_src_b, alu_result;
  wire zero;

  // data memory
  wire [31:0] mem_read_data;

  // adders
  wire [31:0] pc_plus_4;
  wire [31:0] branch_target;

  // mux selects
  wire pc_sel;
  wire branch_taken;

  // pc register
  always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
      PC <= 32'h00000000;
    end else if (PCWrite) begin
      PC <= next_PC;
    end
  end

  // pc + 4
  assign pc_plus_4 = PC + 32'd4;

  // instruction memory
  inst_memory imem (
      .PC  (PC),
      .inst(inst)
  );

  // control unit
  cu control (
      .opcode(inst[6:0]),
      .RegWrite(RegWrite),
      .ALUSrc(ALUSrc),
      .MemRead(MemRead),
      .MemWrite(MemWrite),
      .MemToReg(MemToReg),
      .Branch(Branch),
      .Jump(Jump),
      .ALUOp(ALUOp)
  );

  // immediate generator
  immediate_gen imm_gen (
      .instruction(inst),
      .opcode(inst[6:0]),
      .imm_extended(imm_extended),
      .branch_imm(branch_imm)
  );

  // register file
  register_file rf (
      .CLK(CLK),
      .READREG1(inst[19:15]),
      .READREG2(inst[24:20]),
      .WRITEREG(inst[11:7]),
      .WRITEENABLE(RegWrite),
      .WRITEDATA(write_data),
      .REGOUT1(rs1_data),
      .REGOUT2(rs2_data)
  );

  // alu control
  alu_control alu_ctrl (
      .ALUOp(ALUOp),
      .funct3(inst[14:12]),
      .funct7(inst[31:25]),
      .opcode(inst[6:0]),
      .ALU_operation(alu_control)
  );

  // alu source mux - select between rs2 and immediate
  mux_2x1 alu_src_mux (
      .x(rs2_data),
      .y(imm_extended),
      .s(ALUSrc),
      .z(alu_src_b)
  );

  // alu
  alu alu_inst (
      .src_a(rs1_data),
      .src_b(alu_src_b),
      .alu_control(alu_control),
      .result(alu_result),
      .zero(zero)
  );

  // branch target = pc + 4 + branch_imm
  assign branch_target = pc_plus_4 + branch_imm;

  // data memory
  data_memory dmem (
      .address   (alu_result),
      .write_data(rs2_data),
      .MemRead   (MemRead),
      .MemWrite  (MemWrite),
      .CLK       (CLK),
      .read_data (mem_read_data)
  );

  // write-back mux - select between alu result and memory data
  mux_2x1 wb_mux (
      .x(alu_result),
      .y(mem_read_data),
      .s(MemToReg),
      .z(write_data)
  );

  // pc mux - select between pc+4 and branch target
  assign branch_taken = Branch & zero;
  assign pc_sel = branch_taken | Jump;

  mux_2x1 pc_mux (
      .x(pc_plus_4),
      .y(branch_target),
      .s(pc_sel),
      .z(next_PC)
  );

  // pc always writes (single-cycle)
  assign PCWrite = 1'b1;

  // debug outputs
  assign pc_out = PC;
  assign inst_out = inst;
  assign alu_result_out = alu_result;

endmodule