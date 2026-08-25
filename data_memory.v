module data_memory (
    input [31:0] address,
    input [31:0] write_data,
    input MemRead,
    input MemWrite,
    input CLK,
    output reg [31:0] read_data
);

  reg [31:0] mem[0:255];
  integer i;

  initial begin
    for (i = 0; i < 256; i = i + 1) begin
      mem[i] = 32'h00000000;
    end
  end

  always @(posedge CLK) begin
    if (MemWrite) begin
      mem[address[9:2]] <= write_data;
    end
  end

  always @(*) begin
    if (MemRead) begin
      read_data = mem[address[9:2]];
    end else begin
      read_data = 32'h00000000;
    end
  end

endmodule