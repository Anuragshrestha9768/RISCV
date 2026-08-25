# RISC-V RV32I Single-Cycle Processor

A complete implementation of a RISC-V RV32I single-cycle processor in Verilog, designed for educational purposes and hardware design learning.

## Overview

This project implements a fully functional RISC-V RV32I processor that executes one instruction per clock cycle. The processor supports the base integer instruction set and is designed to be modular and easy to understand, making it suitable for learning computer architecture concepts.

## Architecture

The processor follows a classic single-cycle datapath design with the following components:

```
+----------------+     +----------------+     +------------------+
|      PC        |---->|   Instruction  |---->|  Control Unit    |
+----------------+     |    Memory      |     +------------------+
        |              +----------------+            |
        |                                             v
        |              +----------------+     +----------------+
        +------------->| Register File  |---->|      ALU       |
                       +----------------+     +----------------+
                              |                        |
                              |                        v
                              |                +----------------+
                              +--------------->|   Data Memory  |
                                               +----------------+
```

## Project Structure

```
RISC-V-Processor/
├── alu.v                 # Arithmetic Logic Unit
├── alu_control.v         # ALU Operation Decoder
├── cu.v                  # Main Control Unit
├── data_memory.v         # Data Memory (256 x 32-bit)
├── immediate_gen.v       # Immediate Value Generator
├── inst_memory.v         # Instruction Memory (256 x 32-bit)
├── mux_2x1.v             # 2-to-1 Multiplexer
├── register_file.v       # Register File (32 x 32-bit)
├── riscv_top.v           # Top-Level Module
└── riscv_top_tb.v        # Testbench
```

## Supported Instructions

### R-Type Instructions
| Instruction | Description |
|------------|-------------|
| add | Addition |
| sub | Subtraction |
| and | Bitwise AND |
| or | Bitwise OR |
| xor | Bitwise XOR |
| sll | Shift Left Logical |
| srl | Shift Right Logical |
| sra | Shift Right Arithmetic |
| slt | Set Less Than (Signed) |
| sltu | Set Less Than (Unsigned) |

### I-Type Instructions
| Instruction | Description |
|------------|-------------|
| addi | Add Immediate |
| andi | Bitwise AND Immediate |
| ori | Bitwise OR Immediate |
| xori | Bitwise XOR Immediate |
| slli | Shift Left Logical Immediate |
| srli | Shift Right Logical Immediate |
| srai | Shift Right Arithmetic Immediate |
| slti | Set Less Than Immediate (Signed) |
| sltiu | Set Less Than Immediate (Unsigned) |
| lw | Load Word |
| jalr | Jump and Link Register |

### S-Type Instructions
| Instruction | Description |
|------------|-------------|
| sw | Store Word |

### B-Type Instructions
| Instruction | Description |
|------------|-------------|
| beq | Branch if Equal |
| bne | Branch if Not Equal |
| blt | Branch if Less Than (Signed) |
| bge | Branch if Greater or Equal (Signed) |
| bltu | Branch if Less Than (Unsigned) |
| bgeu | Branch if Greater or Equal (Unsigned) |

### J-Type Instructions
| Instruction | Description |
|------------|-------------|
| jal | Jump and Link |

### U-Type Instructions
| Instruction | Description |
|------------|-------------|
| lui | Load Upper Immediate |
| auipc | Add Upper Immediate to PC |

## Test Program

The processor includes a test program that demonstrates basic functionality:

```assembly
# Test Program
ADDI x10, x0, 45    # Load 45 into x10
ADDI x11, x0, 65    # Load 65 into x11
ADD  x12, x10, x11  # x12 = x10 + x11 = 110
ADDI x13, x12, 85   # x13 = x12 + 85 = 195
ADDI x14, x0, 256   # Load memory address 256
SW   x13, 0(x14)    # Store x13 to memory address 256
NOP                 # No operation
JAL  x0, -32        # Infinite loop (halt)
```

**Expected Result**: After execution, memory address `0x100` should contain `195` (`0x000000C3`).

## Getting Started

### Prerequisites
- Icarus Verilog (for simulation)
- GTKWave (optional, for waveform viewing)

### Installation

```bash
# Clone the repository
git clone https://github.com/Anuragshrestha9768/RISCV.git

# Navigate to project directory
cd RISCV
```

### Compilation and Simulation

```bash
# Compile all modules
iverilog -o riscv_sim \
  alu.v \
  alu_control.v \
  cu.v \
  data_memory.v \
  immediate_gen.v \
  inst_memory.v \
  mux_2x1.v \
  register_file.v \
  riscv_top.v \
  riscv_top_tb.v

# Run simulation
vvp riscv_sim

# View waveforms (optional)
gtkwave riscv.vcd
```

### Alternative: Single-File Compilation

If you prefer to compile everything in one file:

```bash
# Combine all modules into a single file
cat alu.v alu_control.v cu.v data_memory.v immediate_gen.v inst_memory.v mux_2x1.v register_file.v riscv_top.v riscv_top_tb.v > riscv_single.v

# Compile
iverilog -o riscv_sim riscv_single.v

# Run
vvp riscv_sim
```

## Simulation Output

When you run the simulation, you should see output similar to:

```
pc: 0x00000000, inst: 0x02d00513, alu: 0x00000000, zero: 1
Time: 10, Write to x10 = 0x0000002d
pc: 0x00000004, inst: 0x04100593, alu: 0x0000002d, zero: 0
Time: 20, Write to x11 = 0x00000041
pc: 0x00000008, inst: 0x00b50633, alu: 0x00000041, zero: 0
Time: 30, Write to x12 = 0x0000006e
pc: 0x0000000c, inst: 0x05560693, alu: 0x0000006e, zero: 0
Time: 40, Write to x13 = 0x000000c3
pc: 0x00000010, inst: 0x10000713, alu: 0x00000100, zero: 0
Time: 50, Write to x14 = 0x00000100
pc: 0x00000014, inst: 0x00d72023, alu: 0x00000100, zero: 0
pc: 0x00000018, inst: 0x00000013, alu: 0x00000100, zero: 0
pc: 0x0000001c, inst: 0xfe1ff06f, alu: 0x00000100, zero: 0
```

## Module Descriptions

### ALU (alu.v)
Performs arithmetic and logical operations based on a 4-bit control signal. Supports addition, subtraction, bitwise operations, shifts, and comparisons.

### ALU Control (alu_control.v)
Decodes the ALU operation based on ALUOp, funct3, funct7, and opcode signals.

### Control Unit (cu.v)
Generates all control signals for the processor based on the opcode.

### Data Memory (data_memory.v)
256-word (32-bit) data memory with read and write capabilities.

### Immediate Generator (immediate_gen.v)
Generates sign-extended immediate values for all instruction formats (I, S, B, U, J).

### Instruction Memory (inst_memory.v)
256-word (32-bit) instruction memory containing the test program.

### Register File (register_file.v)
32 registers of 32 bits each. Register x0 is hardwired to zero.

### Top-Level Module (riscv_top.v)
Connects all components together to form the complete processor.

### Testbench (riscv_top_tb.v)
Simulates the processor and verifies correct operation.

## Extending the Processor

To add new instructions or features:

1. Add new ALU operations: Modify alu.v and update alu_control.v
2. Add new control signals: Modify cu.v to generate new signals
3. Add new instructions: Update instruction encoding in alu_control.v and cu.v
4. Expand memory: Increase the memory array size in memory modules


