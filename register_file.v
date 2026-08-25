module register_file (
    input CLK,
    input [4:0] READREG1,
    input [4:0] READREG2,
    input [4:0] WRITEREG,
    input WRITEENABLE,
    input [31:0] WRITEDATA,
    output reg [31:0] REGOUT1,
    output reg [31:0] REGOUT2
);

  reg [31:0] regs[0:31];
  integer i;

  initial begin
    for (i = 0; i < 32; i = i + 1) begin
      regs[i] = 32'h00000000;
    end
  end

  // write except for x0
  always @(posedge CLK) begin
    if (WRITEENABLE && (WRITEREG != 5'b00000)) begin
      $display("Time: %0t, Write to x%d = 0x%h", $time, WRITEREG, WRITEDATA);
      regs[WRITEREG] <= WRITEDATA;
    end
  end

  // x0 is hardwired to 0
  always @(*) begin
    REGOUT1 = (READREG1 == 5'b00000) ? 32'h00000000 : regs[READREG1];
    REGOUT2 = (READREG2 == 5'b00000) ? 32'h00000000 : regs[READREG2];
  end

endmodule