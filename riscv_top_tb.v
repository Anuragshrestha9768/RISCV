`timescale 1ns / 1ps

module riscv_top_tb;

  reg CLK;
  reg RESET;
  wire [31:0] pc_out;
  wire [31:0] inst_out;
  wire [31:0] alu_result_out;

  riscv_top uut (
      .CLK(CLK),
      .RESET(RESET),
      .pc_out(pc_out),
      .inst_out(inst_out),
      .alu_result_out(alu_result_out)
  );

  always #5 CLK = ~CLK;

  initial begin
    $dumpfile("riscv.vcd");
    $dumpvars(0, riscv_top_tb);

    CLK   = 0;
    RESET = 1;
    #20;
    RESET = 0;

    // run for 300ns
    #300;
    $finish;
  end

  // print progress on each clock edge
  always @(posedge CLK) begin
    if (!RESET) begin
      $display("pc: 0x%h, inst: 0x%h, alu: 0x%h, zero: %b", 
               pc_out, inst_out, alu_result_out, uut.zero);
    end
  end

endmodule