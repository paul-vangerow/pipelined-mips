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
| LB | I | L/S | 100000 | lb rt, offset(rs) | rt <- mem[rs + offset] (byte) |
| LBU | I | L/S | 100100 | lbu rt, offset(rs) | rt <- mem[rs + offset] (signed byte) |
| LH | I | L/S | 100001 | lh rt, offset(rs) | rt <- mem[rs + offset] (two bytes)
| LHU | I | L/S | 100101 | lhu rt, offset(rs) |
| LUI | I | ALU | 001111 | lui rt, imm |
| LW | I | L/S | 100011 | lw rt, offset(rs) |
| LWL | I | L/S | 100010 | lwl rt, offset(rs) |
| LWR | I | L/S | 100110 | lwr rt, offset(rs) |
| MTHI | R | ALU | 010001 | mthi rs |
| MTLO | R | ALU | 010011 | mtlo rs |
| MFLO | R | ALU | 010010 | mflo rd |
| MFHI | R | ALU | 010000 | mfhi rd |
| MULT | R | ALU | 011000 | mult rs, rt |
| MULTU | R | ALU | 011001 | multu rs, rt |
| OR | R | ALU | 100101 | or rd, rs, rt |
| ORI | I | ALU | 001101 | ori rt, rs, imm |
| SB | I | L/S | 101000 | sb rt, offset(rs) |
| SH | I | L/S | 101001 | sh rt, offset(rs) |
| SLL | R | ALU | 000000 | sll rd, rt, sa |
| SLLV | R | ALU | 000100 | sllv rd, rt, rs |
| SLT | R | ALU | 101010 | slt rd, rs, rt |
| SLTI | I | ALU | 001010 | slti rt, rs, imm |
| SLTIU | I | ALU | 001011 | sltiu rt, rs, imm |
| SLTU | R | ALU | 101011 | sltu rd, rs, rt |
| SRA | R | ALU | 000011 | sra rd, rt, sa |
| SRAV | R | ALU | 000111 | srav rd, rt, rs |
| SRL | R | ALU | 000010 | srl rd, rt, sa |
| SRLV | R | ALU | 000110 | srlv rd, rt, rs |
| SUBU | R | ALU | 100011 | subu rd, rs, rt |
| SW | I | L/S | 101011 | sw rt, offset(rs) |
| XOR | R | ALU | 100110 | xor rd, rs, rt | 
| XORI | I | ALU | 001110 | xori rt, rs, imm |
