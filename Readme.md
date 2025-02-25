# RISC-V based MYTH Workshop
This repository contains the documents, codes, and materials related to the RISC-V-based MYTH workshop, organized by NASSCOM India in collaboration with Steeve Hoover and Kunal Ghosh. 

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

## Sequential Logic

The Fibonacci series is provided as an example for the sequential circuits. The circuit is constructed such that it enters the known state when a `RESET` signal is present. For the Fibonacci code, the known state is `1`. The syntax `>>1` provides the previous value of `$val`, and `>>2` provides the value of `$val` two states prior. Similarly, `>>x` will provide the value of `$val` `x` cycles prior.
