# RISC-V based MYTH Workshop
This repository contains the documents, codes, and materials related to the RISC-V-based MYTH workshop, organized by NASSCOM India in collaboration with Steeve Hoover and Kunal Ghosh. **The source codes can be found in the folder Codes**.

GitHub Repository Link : [Steve Hoover | RISCV Myth Workshop](https://github.com/stevehoover/RISC-V_MYTH_Workshop)

# Digital Logic Design with Transaction Level Verilog

For the initial simulation and design, the Makerchip IDE is used. Detailed explanations and guidance on using the IDE can be found here in this [Link](https://www.makerchip.com/sandbox/#). 

Note that the Makerchip IDE platform does not recognize `TAB` for indentation; instead, use three spaces for indentation. `CTRL + ]` is used to indent the code to the right, and `CTRL + [` is used to indent the code to the left. Also, note that in TL-Verilog, using `*reset` refers to SystemVerilog code defined in macros.

## Combinational Logic

As a standard approach for learning any hardware description language, the process starts with the implementation of basic logic gates. The logical operators are similar to those in Verilog, with the primary difference being that there is no need for explicit declaration of the inputs and outputs. 

This is a basic example of a simple **2-to-1 8-Bit Multiplexer**.

```Verilog
\TLV

$out[7:0] = $sel ? $in1[7:0] : $in2[7:0]
```
### Lab : Combinational Calculator

```Verilog
\TLV

   // Nigil
   // Generate Random Vectors

   $val1[31:0] = $rand1[3:0];
   $val2[31:0] = $rand2[3:0];
   $op[1:0]    = $rand3[1:0];

   // All Arithmetic Operations are Computed, then Output is Selected based on the OpCode.

   $sum[31:0]  = $val1 + $val2;
   $diff[31:0] = $val1 - $val2;
   $prod[31:0] = $val1 * $val2;
   $quot[31:0] = $val1 / $val2;

   // Selecting Operation

   $out[31:0] = $op[1:0] == 0 ? $sum : $op[1:0] == 1 ? $diff : $op[1:0] == 2 ? $prod : $quot;
   
   // Limiting Testing Cycles
   
   *passed = *cyc_cnt > 50;
   *failed = 1'b0;
```
