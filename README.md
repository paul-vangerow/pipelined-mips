# Mips CPU

## Introduction

This file will be documentation of my planning and execution when creating this MIPS based CPU.

I will base it of the MIPS 1 ISA since this is the one we studied, though I may look into expansion depending on how I get along since other aspects of the CPU such as coprocessors sound quite interesting.

The primary goal for myself is to implement the following features:

1. Full support for **all** MIPS I Instructions, based on the spec found here: [GORDON](http://www.cs.gordon.edu/courses/cs311/handouts-2015/MIPS%20ISA.pdf)
2. Complete implementation of a memory mapped AVALON bus, based on the spec found here: [INTEL](https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/manual/mnl_avalon_spec.pdf)
3. The CPU should be fully piplined (Utilising 5 Pipleine stages)
4. All hazards should be dealt with

This is the original plan, though it may deviate with time and other requirements. Including the implementation of anything additional should I find it interesting enough to implement.


## Instructions

There are 3 main types of MIPS instructions:

- R-Type: Dealing with 3 registers
- J-Type: Dealing with a single large immediate value (Address)
- I-Type: Dealing with 2 registers and one immediate value

These instructions can be split up based on the operations they do and what internal components they operate on.

I spent a while researching trying to find what instructions are and are not in the MIPS I ISA, after a while of looking this is what I ended up planning to include the following:

| Name | Type | Component | Opcode/Function/RT | Assembly | Application |
| :---:| :---: | :---: | :---: | :---: | :---: |
| ADDIU	| R | ALU | 001001 | addiu rt, rs, imm | rt <- rs + imm |
| ADDU | R | ALU | 100001 | addu rd, rs, rt | rd <- rs + rt |
| AND | R | ALU | 100100 | and rd, rs, rt | rd <- rs & rt |
| ANDI | I | ALU | 001100 | andi rt, rs, imm | rt <- rs & imm |
| BEQ | I | NXT | 000100 | beq rs, rt, imm | if (rs = rt): PC = PC + (4*offset) |
| BGEZ | I | NXT | 00001 | bgez rs, imm | if (rs >= 0): PC = PC + (4*offset) |
| BGEZAL | I | NXT | 10001 | bgezal rs, imm | if (rs >= 0): ra = PC + 8, PC = PC + (4*offset) |
| BGTZ | I | NXT | 000111 | bgtz rs, imm | if (rs > 0): PC = PC + (4*offset) |
| BLEZ | I | NXT | 000110 | blez rs, imm | if (rs <= 0): PC = PC + (4*offset) |
| BLTZ | I | NXT | 00000 | bltz rs, imm | if (rs < 0): PC = PC + (4*offset) |
| BLTZAL | I | NXT | 10000 | bltzal rs, imm | if (rs < 0): ra = PC + 8, PC = PC + (4*offset) |
| BNE | I | NXT | 000101 | bne rs, rt, imm | if (rs != rt): PC = PC + (4*offset) |
| DIV | R | ALU | 011010 | div rs, rt | LO <- rs / rt, HI <- rs % rt |
| DIVU | R | ALU | 011011 | divu rs, rt | LO <- rs / rt, HI <- rs % rt |
| J | J | NXT | 000010 | j addr | PC = addr*4 |
| JALR | R | NXT | 001001 | jalr rd, rs | rd <- PC + 8, PC = 4*rs |
| JAL | J | NXT | 000011 | jal addr | ra <- PC + 8, PC = 4*addr |
| JR | R | NXT | 001000 | jr rs | PC = 4*rs |
| LB | I | L/S | 100000 | lb rt, offset(rs) | rt <- mem[rs + offset] (signed byte) |
| LBU | I | L/S | 100100 | lbu rt, offset(rs) | rt <- mem[rs + offset] (unsigned byte) |
| LH | I | L/S | 100001 | lh rt, offset(rs) | rt <- mem[rs + offset] (two bytes, signed) |
| LHU | I | L/S | 100101 | lhu rt, offset(rs) | rt <- mem[rs + offset] (two bytes, unsigned) |
| LUI | I | ALU | 001111 | lui rt, imm | rt <- imm << 16 |
| LW | I | L/S | 100011 | lw rt, offset(rs) | rt <- mem[rs + offset] (word) |
| LWL | I | L/S | 100010 | lwl rt, offset(rs) | rt <- mem[rs + offset] (figure out later) |
| LWR | I | L/S | 100110 | lwr rt, offset(rs) | rt <- mem[rs + offset] (figure out later) |
| MTHI | R | ALU | 010001 | mthi rs | HI <- rs |
| MTLO | R | ALU | 010011 | mtlo rs | LO <- rs |
| MFLO | R | ALU | 010010 | mflo rd | rd <- LO |
| MFHI | R | ALU | 010000 | mfhi rd | rd <- HI |
| MULT | R | ALU | 011000 | mult rs, rt | HI, LO <- rs * rt (signed) |
| MULTU | R | ALU | 011001 | multu rs, rt | HI, LO <- rs * rt (unsigned) |
| OR | R | ALU | 100101 | or rd, rs, rt | rd <- rs \| rt |
| ORI | I | ALU | 001101 | ori rt, rs, imm | rt <- rs \| imm |
| SB | I | L/S | 101000 | sb rt, offset(rs) | mem[rs + offset] <- rt (byte) |
| SH | I | L/S | 101001 | sh rt, offset(rs) | mem[rs + offset] <- rt (2 Bytes) |
| SLL | R | ALU | 000000 | sll rd, rt, sa | rd <- rt << sa |
| SLLV | R | ALU | 000100 | sllv rd, rt, rs | rd <- rt << rs |
| SLT | R | ALU | 101010 | slt rd, rs, rt | rd <- (rs < rt) (signed) |
| SLTI | I | ALU | 001010 | slti rt, rs, imm | rt <- (rs < imm) (signed) |
| SLTIU | I | ALU | 001011 | sltiu rt, rs, imm | rt <- (rs < imm) (unsigned) |
| SLTU | R | ALU | 101011 | sltu rd, rs, rt | rd <- (rs < rt) (unsigned) |
| SRA | R | ALU | 000011 | sra rd, rt, sa | rd <- rt >> sa (signed) |
| SRAV | R | ALU | 000111 | srav rd, rt, rs | rd <- rt >> rs (signed) |
| SRL | R | ALU | 000010 | srl rd, rt, sa | rd <- rt >> sa (unsigned) |
| SRLV | R | ALU | 000110 | srlv rd, rt, rs | rd <- rt >> rs (unsigned) |
| SUBU | R | ALU | 100011 | subu rd, rs, rt | rd <- rs - rt |
| SW | I | L/S | 101011 | sw rt, offset(rs) | mem[rs + offset] <- rt
| XOR | R | ALU | 100110 | xor rd, rs, rt | rd <- rs ^ rt |
| XORI | I | ALU | 001110 | xori rt, rs, imm | rt <- rs ^ imm |

## Pipelining

The next step involved figuring out the pipeline for the CPU. For this, I will be using the standard 5 pipeline stages that MIPS was originally designed for. These are as follows:

- Fetch
- Decode
- Execute
- Memory Access
- Writeback

Each of these will be responsible for certain aspects of instructions and will have to interface with previous stages to ensure that no hazards occur. 

### Fetch

During this stage of the pipeline, instructions are fetched from memory. Since I aim to interface with the avalon bus, data will not immediately be available - so only a request can be made for the data. Due to this the following must occur:

- A Data fetch request has to be made, with the PC as the address.
- The fetch stage has to be stallable, since any other memory accesses should take priority over it

### Decode

During this stage, unless there was some sort of delay, the CPU will recieve the instruction from the memory. Here the CPU should decode the instruction and break it down into whatever control signals are required, delaying each by as much as needed for the following pipeline stages. Register fetch should also occur during this stage, with data being output into further stall registers.

### Execute

This stage involves pretty much all of the execution of the arithmetic and logic instructions, with all calculations taking place and values being calculated. This is the first stage from which on data hazards can occur, thereby it can also take inputs from stages further along the pipeline in case any of the used variables has its value changed. Branch conditionals are also calculated during this stage, ensuring that the next value of PC is calculated correctly.

### Memory Access

Here all of the read and write requests are created and submitted to the avalon bus. Read requests are sent off, with data returning on the next clock cycle. Any memory access will stall the fetch occuring at the same time since memory access cannot be simultaneous (applies to possible changes in the PC values too).

### Writeback

And the final stage is writing back to the register file (any calculated ALU values or any returning values from the memory).

## Hazards 

A big issue when dealing with a piplined CPU is that hazards must be dealt with. There are a couple of hazards that could occur:

- Data Hazards
- Control Hazards
- Structural Hazards

### Structural Hazards

The first one is stuctural hazards, a hazard that occurs when two instructions require the same resource at different pipeline stages. In this case the only real resource that could be accessed simultaneously is the memory and the register file, of which the register file is unlikely to cause issues since simultaneous memory reading and writing is permitted. The only cause for concern is parallel memory accesses, which have been addressed already: Since memory access instructions are more rare, they will simply stall the next memory fetch if memory access is required.

### Data Hazards

A data hazard occurs when two instructions use the same data at different pipeline stages. This will happen primarily due to an instruction writing to a register which will be used as an input in a following instruction - resulting in the fetched register value being outdated.

This can happen in a number of ways as new register values are found in two of the pipeline stages, and can be needed in two of the pipeline stages. The main way I will try to implement this is through data bypassing, where data that is to be written to a certain register is available to previous pipeline stages. 

### Control Hazards

Control hazards occur when instructions are loaded that cannot be used. In this case this will occur when a jump or branch instruction has not yet changed the PC properly, causing the following instruction to be fetched from the wrong location. 

I decided to fix this in the way MIPS I was designed, through use of a branch delay slot. This means that the branch instruction only really has its effect after the next instruction has already been loaded, something necessary as it would be impossible to know what the outcome of a conditional branch is during the first cycle, when the instruction hasn't even been loaded yet. To make this work then though, it means that all PC calculations must occur during the DECODE stage of the pipeline, providing the next PC value by the end of it, and allowing the correctly branched to (or jumped to) instruction to be correctly loaded.

## CPU Design

With the general gist of all the issues sorted, it was time to start thinking about the actual design of the CPU and how each part was actually going to work. I figured the easiest way to implement the pipelined functionality would be by making each stage of the pipeline its own 'block', with a well defined behaviour and set inputs and outputs. Through this approach I would be able to figure out each part bit by bit, hopefully making the whole CPU design process a lot more intuitive. 

### FETCH

**Functionality**
- Send a read request through the Avalon bus for the instruction at address (PC)
- Pre-Increment the PC (Allows for modification by fetch stall and Jump/Branch)
- Deal with the Reset (Start)
- Deal with the PC being 0 (Stop)

**Ports**
- Fetch Stall
- Current PC Value
- PC Jump Value
- Initiate Jump
- Avalon Connection

### DECODE

**Functionality**
- Recieve the read value from the Avalon bus
- Decode the instruction and convert it into its individual control signals
- Read Register Values

**Ports**
- Avalon Connection
- Register Read Connection (Address, ReadData) for two registers.
- Control Signals (Opcode, rt, rd, rs, function code, shamt, address, imm)
- Register Value outputs

### Register File

**Functionality**
- Contain 32 registers
- Abillity to write to 1 register and read from 2

**Ports**
- 3 Address ports
- Write Enable
- Read Data (1/2)

### Execute

**Functionality**
- Calculate ALU output based on register inputs and control inputs
- Calculate branch conditionals based on registers

**Ports**
- RT, RS
- Register Write Enable
- Jump Enable
- Jump Address
- Control signals
- LO/HI Write Enable
- LO/HI Write Data

### Memory

**Functionality**
- Interface with the Avalon bus to either send or request data (according to control signals)

**Ports**
- Control Signals
- Avalon Bus

### Writeback

**Functionality**
- Write data from the Avalon bus to a register
- Write data from the ALU to a register

**Ports**
- ALU Output
- Control Signals
- Avalon Bus
- Register File Write Enable
- Register Write Data
- Register Write Address

### Hazard Manager

**Functionality**
- Deal with data hazards by storing register addresses and output values from ALU and MEM
- Do the correct comparisons and provide pipeline stages values

**Ports**
- Control Signals
- More control signals
- Register value outputs

I will in all likelihood add this component at the end and make modifications to the other components to ensure that it works correctly.


