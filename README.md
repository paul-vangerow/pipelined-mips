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

I spent a while researching trying to find what instructions are and are not in the MIPS I ISA, after a while of looking this is what I ended up planning to include

| Name | Type | Component | Opcode/Function/RT | Assembly | Application |
| :---:| :---: | :---: | :---: | :---: | :---: |
| ADDIU	| R | ALU | 001001 |
| ADDU | R | ALU | 100001 |
| AND | R | ALU | 100100 |
| ANDI | I | ALU | 001100 |
| BEQ | I | NXT | 000100 |
| BGEZ | I | NXT | 00001 |
| BGEZAL | I | NXT | 10001 |
| BGTZ | I | NXT | 000111 |
| BLEZ | I | NXT | 000110 |
| BLTZ | I | NXT | 00000 |
| BLTZAL | I | NXT | 10000 |
| BNE | I | NXT | 000101 |
| DIV | R | ALU | 011010 |
| DIVU | R | ALU | 011011 |
| J | J | NXT | 000010 |
| JALR | R | NXT | 001001 |
| JAL | J | NXT | 000011 |
| JR | R | NXT | 001000 |
| LB | I | L/S | 100000 |
| LBU | I | L/S | 100100 |
| LH | I | L/S | 100001 |
| LHU | I | L/S | 100101 |
| LUI | I | ALU | 001111 |
| LW | I | L/S | 100011 |
| LWL | I | L/S | 100010 |
| LWR | I | L/S | 100110 |
| MTHI | R | ALU | 010001 |
| MTLO | R | ALU | 010011 |
| MFLO | R | ALU | 010010 |
| MFHI | R | ALU | 010000 |
| MULT | R | ALU | 011000 |
| MULTU | R | ALU | 011001 |
| OR | R | ALU | 100101 |
| ORI | I | ALU | 001101 |
| SB | I | L/S | 101000 |
| SH | I | L/S | 101001 |
| SLL | R | ALU | 000000 |
| SLLV | R | ALU | 000100 |
| SLT | R | ALU | 101010 |
| SLTI | I | ALU | 001010 |
| SLTIU | I | ALU | 001011 |
| SLTU | R | ALU | 101011 |
| SRA | R | ALU | 000011 |
| SRAV | R | ALU | 000111 |
| SRL | R | ALU | 000010 |
| SRLV | R | ALU | 000110 |
| SUBU | R | ALU | 100011 |
| SW | I | L/S | 101011 |
| XOR | R | ALU | 100110 |
| XORI | I | ALU | 001110 |
