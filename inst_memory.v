module inst_memory (
    input [31:0] PC,
    output reg [31:0] inst
);

  // 256 x 32-bit memory
  reg [31:0] mem[0:255];
  integer i;

  initial begin
    // initialize all to NOP
    for (i = 0; i < 256; i = i + 1) begin
      mem[i] = 32'h00000013;  // NOP
    end

    // Test program:
    // x10 = 45, x11 = 65, x12 = x10 + x11 = 110
    // x13 = x12 + 85 = 195
    // store x13 to memory address 0x100

    mem[0] = 32'h02D00513;  // ADDI x10, x0, 45   (LI a0, 45)
    mem[1] = 32'h04100593;  // ADDI x11, x0, 65   (LI a1, 65)
    mem[2] = 32'h00B50633;  // ADD  x12, x10, x11 (ADD a2, a0, a1)
    mem[3] = 32'h05560693;  // ADDI x13, x12, 85  (ADDI a3, a2, 85)
    mem[4] = 32'h10000713;  // ADDI x14, x0, 256  (LI a4, 256) [ADDRESS]
    mem[5] = 32'h00D72023;  // SW   x13, 0(x14)   (SW a3, 0(a4))
    mem[6] = 32'h00000013;  // NOP
    mem[7] = 32'hFE1FF06F;  // JAL  x0, -32       (HALT: infinite loop)
  end

  always @(*) begin
    inst = mem[PC[9:2]];  // word-aligned access
  end

endmodule