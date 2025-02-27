# RISC-V Design using Transaction-Level Verilog 
This repository contains the documents, codes, and materials related to the RISC-V-based MYTH workshop, organized by NASSCOM India in collaboration with Steve Hoover and Kunal Ghosh. 

_The reference solutions for the lab and practices can be found in this_ [_Solution_](https://github.com/stevehoover/RISC-V_MYTH_Workshop/blob/master/reference_solutions.tlv). _The solutions do not include code; they include only the design visualizations._

# Introduction to RISC-V Instruction Set using GNU Compiler Tool Chain and Spike Simulator

| ![Combined Picture](https://github.com/user-attachments/assets/177470e5-b616-44f9-9bcc-009d7b61a476) |
| :--------------------------------------------------: |
|           Softening the Hardware (Onion Layers) and Digital Machine Structure        |

The idea is to implement different `C` programs, convert them to object code (which is the assembly language), and run them using the RISC-V compiler built into the GNU Compiler Collection (GCC). Then, debugging is done using the Spike Simulator to develop a basic understanding of the Instruction Set Architecture (ISA) and how high-level language code is broken down into multiple instructions.

Apart from standard C/C++ and Fortran language support, the **GCC Compiler** supports multiple architectures and platforms, including RISC-V, ARM, x86, and many others, enabling developers to write code on one platform and later compile it to run on others.

The **Spike Simulator** is an **Instruction Set Simulator** specifically design for RISC-V, an open source instruction set architecture. It is an official simulator for RISC-V, used to model and simulate the processors. 

Create a small `C` program that performs the addition of numbers from 1 to `N`. Run the program using the commands `gcc <FILE_NAME.c>` and `./a.out`.

## Generate RISC-V Object File

Either one of the above two codes can be used to generate the object file. 

```bash
riscv64-unknown-elf-gcc -O1 -mabi=lp64 -march=rv64i -o <OBJECT_FILE_NAME.o> <C_PRG_FILE_NAME.c>
```

```bash
riscv64-unknown-elf-gcc -Ofast -mabi=lp64 -march=rv64i -o <OBJECT_FILE_NAME.o> <C_PRG_FILE_NAME.c>
```

## Assembly Code

The first command provides an extended version of the assembly code. The second command will provide a `piped` version of the code.

```bash
riscv64-unknown-elf-objdump -d sum.o
```

```bash
riscv64-unknown-elf-objdump -d sum.o | less
```

| ![IM01 Assembly Code](https://github.com/user-attachments/assets/e6d4811b-7f98-4dc0-898f-0118cc69d539) |
| :--------------------------------------------------: |
|           Assembly Language Codes - Sum of 'N' Numbers (-Ofast)        |


## Debugging - Spike Simulator

The Spike simulator is invoked using the spike disassemble command. By using the `until` command, the program can be executed starting from a particular address. Pressing `ENTER` executes the consecutive steps. The updates to the registers can be viewed using the `reg` command. 

In the assembly code, by using the appropriate syntax, parts of the code can be easily navigated. For example, `/main` finds all instances of 'main,' and pressing 'n' repeatedly will help you find the correct instance.

```bash
spike -d pk <OBJECT_FILE_NAME.o>
```

```bash
(spike) until pc 0 <ADDRESS_TILL_EXECUTION>
```

```bash
(spike) reg <CORE> <REGISTER_NAME>
```

|![IM02 Spike Simulator](https://github.com/user-attachments/assets/0a93b620-156a-498c-86a5-0b9d64bcc7dc) |
| :--------------------------------------------------: |
|           Debugging using Spike Simulator       |

_The explanation of the shell commands can be found on the internet. Lectures on signed and unsigned integers were viewed, but no notes were made._

# Introduction to Application Binary Interface (ABI)

An Application Binary Interface (ABI) is a set of rules and conventions that define how different components of a program interact at the binary level. It acts as an intermediary between various program modules or between the program and the operating system, ensuring seamless interoperability among software components, even when they are written in different programming languages or compiled with different compilers. Below is ABI symbolic register names for RV64I. 

|![image](https://github.com/user-attachments/assets/9f4a7a5a-ba65-42b6-9af2-0d6b24d254fd) |
| :--------------------------------------------------: |
|          ABI RISC-V Symbolic Register Names      |

### Lab : Call to Assembly Language from a High-Level Language Program

| ![IM01 C Program and ISA Program Interact](https://github.com/user-attachments/assets/0dc5444d-117b-4d28-8d58-4e76447b109a) |
| :--------------------------------------------------: |
|          Assembly Language and High-Level (C Program) Codes      |

|![IM02 Load Program Interacts with C Program](https://github.com/user-attachments/assets/cd5e39ac-d2c7-4176-a145-bd29c0deceb0) |
| :--------------------------------------------------: |
|          Main Program Showing Execution of `load.S' Assembly Call    |

# Digital Logic Design with Transaction Level Verilog

For the initial simulation and design, the Makerchip IDE is used. Detailed explanations and guidance on using the IDE can be found here in this [Link](https://www.makerchip.com/sandbox/#)

Note that the Makerchip IDE platform does not recognize `TAB` for indentation; instead, use three spaces for indentation. `CTRL + ]` is used to indent the code to the right, and `CTRL + [` is used to indent the code to the left. Also, note that in TL-Verilog, using `*reset` refers to SystemVerilog code defined in macros.

## Combinational Logic

As a standard approach for learning any hardware description language, the process starts with the implementation of basic logic gates. The logical operators are similar to those in Verilog, with the primary difference being that there is no need for explicit declaration of the inputs and outputs. 

This is a basic example of a simple **2-to-1 8-Bit Multiplexer**.

```Verilog
\TLV

$out[7:0] = $sel ? $in1[7:0] : $in2[7:0]
```
### Lab : Combinational Calculator

| ![IM01_Combinational_Calculator](https://github.com/user-attachments/assets/690332f4-02eb-4093-8dc1-a52af1964cc0) |
| :--------------------------------------------------: |
|           Figure 1. Combinational Calculator - Makerchip IDE Output          |


## Sequential Logic

Once the combinational circuits are completed, the next step is to move on to the sequential circuits. A basic Fibonacci series is provided as an example for the sequential circuits. The circuit is constructed such that it enters the known state when a `RESET` signal is present. For the Fibonacci code, the known state is `1`. The syntax `>>1` provides the previous value of `$val`, and `>>2` provides the value of `$val` two states prior. Similarly, `>>x` will provide the value of `$val` `x` cycles prior.

```Verilog
\TLV

   // Fibonacci Series Example

   $num[31:0] = $reset ? 1 : (>>1$num + >>2$num);
```

This is a simple **8-Bit Free Running Counter**.

```Verilog
\TLV
   
   // 8-Bit Free Running Counter
   
   |calc
      @0
         $reset = *reset;
 
         $cnt[7:0] = $reset ? 0 : (>>1$cnt + 1);
         
   // Limiting Simulation
   
   *passed = *cyc_cnt > 20;
   *failed = 1'b0;
```

_The Makerchip IDE uses the open-source Verilator for simulation. It supports only two-state simulation and does not support don't care or high impedance states. The simulator will zero-extend or truncate when widths are mismatched._

### Lab : Sequential Calculator

| ![IM03_Sequential_Calculator](https://github.com/user-attachments/assets/cada27b6-bcb6-45d5-adfb-75f9a026231d) |
| :--------------------------------------------------: |
|           Figure 2. Sequential Calculator - Makerchip IDE Output          |

## Pipelined Logic

Transaction-Level Verilog allows modeling of a design as timing abstracts. The following is a pipeline implementation of the **32-Bit Pythagorean Theorem**, which uses the timing-abstract concept. The green lines represent registers.

| ![Pythagorean Theorem Timing Abstract Diagram](https://github.com/user-attachments/assets/1740a233-43db-4dcc-9dea-993d84299544) |
| :--------------------------------------------------: |
|           Architecture - A Simple Pipeline           |

```Verilog
\TLV

   |calc
      @1 // Stage
         $aa_sq[31:0] = $aa * $aa; 
         $bb_sq[31:0] = $bb * $bb;
      @2
         $cc_sq[31:0] = $aa_sq + $bb_sq;
      @3
         $cc[31:0] = sqrt($cc_sq);
```

Stage one can be divided into two separate stages without affecting the behavior of the circuit. The pipeline stages are a physical attribute. TL-Verilog offers greater flexibility than SystemVerilog and helps avoid retiming issues.

### Retiming the Pipeline : Pythagorean Theorem Example

```Verilog
\TLV

   // Design Under Test

   |calc
      @2 // Stage
         $aa_sq[31:0] = $aa * $aa; 
         $bb_sq[31:0] = $bb * $bb;
      @4
         $cc_sq[31:0] = $aa_sq + $bb_sq;
      @6
         $cc[31:0] = sqrt($cc_sq);

```

| ![Pipeline with Simple Retiming](https://github.com/user-attachments/assets/3398c19d-242e-4f03-8f20-60c40e14f2db) |
| :------------------------------------: |
|   Architecture - A Retimed Pipeline    |

### Identifiers and Types (Misc)

The type of an identifier is determined by its symbol prefix and case/delimitation style. The first token must always start with two alphabet characters. Numbers cannot appear at the beginning of the tokens; they can only be at the end or in the middle. This should not be confused with number identifiers like `>>1`.

| Token Name    | Signal Type     |
| ------------- | --------------- |
| `$lower_case` | Pipeline Signal |
| `$CamelCase`  | State Signal    |
| `$UPPER_CASE` | Keyword Signal  |

### Lab : Error Conditions Within Computation Pipeline

The `ERROR_SIGNALS` are OR together to check the various error conditions that can occur within a computational pipeline. The idea of this exercise is to develop a visual understanding of how the TL-Verilog code is translated into the diagram / architecture in the visualization pane. 

```Verilog
\TLV

   // Error in Pipeline

   |error
      @1
         $err1 = $bad_input || $illegal_op;
      @3
         $err2 = $over_flow || $err1;
      @6
         $err3 = $div_by_zero || $err2;

   // Limiting Testing Cycles
   
   *passed = *cyc_cnt > 10;
   *failed = 1'b0;
```

|  ![IM04_Errors_Pipeline](https://github.com/user-attachments/assets/7f9a06bf-fe4c-481e-abf3-48bcb6f3c51e) |
| :------------------------------------: |
|   Figure 3. Errors in Pipeline During Computation - Makerchip IDE Output (Excercise)    |

### Lab : Two-Cycle Calculator (Pipeline)

The calculation happens in the first cycle, and in the second cycle, the outputs are assigned based on the `VALID SIGNAL`, which is determined by `$reset | !cnt`.

| ![IM05_Pipelined_Calculator](https://github.com/user-attachments/assets/0cc3b070-6d5b-4678-8a38-3d02605f35d9) |
| :------------------------------------: |
|   Figure 4. Two-Cycle (Pipelined) Calculator - Makechip IDE Output    |

## Structure of TL-Verilog Code (Misc)

```
\m4_TLV_version 1d: t1-x.org
```

The above line specifies the version of TL-Verilog, and `tl-x.org` provides the documentation link. `M4` is a macro language, which, when used, expands in the navigation window of the Maker chip IDE, defining the input, output, clock, and reset signals of the module.

## Validity

Validity offers easier debugging, cleaner design, better error checking, and automated clock gating. It allows Sandpiper to inject `DONT_CARES` when the inputs are not valid. The syntax of valid is `?$valid`.

### Example : Accumulation of Distance

```Verilog

\TLV

   |calc
      @1
         $reset = *reset;
      
      ?$valid
         @1 // Stage
            $aa_sq[31:0] = $aa[3:0] * $aa[3:0]; 
            $bb_sq[31:0] = $bb[3:0] * $bb[3:0];
         @2
            $cc_sq[31:0] = $aa_sq + $bb_sq;
         @3
            $cc[31:0]    = sqrt($cc_sq);
            
      @4
         $tot_dist[63:0] = $reset ? '0 :
                           $valid ? >>1$tot_dist + $cc : // Accumulate
                                    >>1$tot_dist;        // Retain
```

| ![IM07_Total_Distance](https://github.com/user-attachments/assets/38d13a7d-51af-4764-a600-0be68a41b0e7) |
| :------------------------------------: |
|   Figure 5. Total Distance Accumulator - Makechip IDE Output    |

A `VALID` signal is used to determine whether the distance is valid. If it is not valid, the previous value of the distance is held. 

### Lab : Two Cycle Calculator with Validity

| ![IM08_Calculator_Validated](https://github.com/user-attachments/assets/63dd24f1-b368-4240-8841-477e45bbd24d) | 
| :------------------------------------: |
|   Figure 6. Pipelined Calculator with Validity Condition - Makechip IDE Output    |

### Lab : Calculator with Single-Value Memory

| ![IM06_Memory_Calculator](https://github.com/user-attachments/assets/21389f6a-2659-4470-ad7c-20234db75e23) |
| :------------------------------------: |
|   Figure 7. Pipelined Calculator with Single Value Memory - Makechip IDE Output    |

*Lecture on Brief introduction on Hierarchy and Lexical Re-entrance using Conway's Game of Life is Skipped.*

# Basic RISC-V CPU Micro-Architecture

The [RISC-V Shell](https://github.com/stevehoover/RISC-V_MYTH_Workshop/blob/master/risc-v_shell.tlv) can be found in the GitHub repository by Steve Hoover. 

## Fetch Address and Instruction

### Program Counter and Instruction Memory

```Verilog
\TLV

   |cpu
      @0
         $reset = *reset;
         $pc[31:0] = (>>1$reset) ? '0 : >>1$pc + 32'h4;
```

For designing the instruction memory uncomment the macros `m4+imem(@1)` and `m4+cpu_viz(@4)`. Then `INST_MEM_EN` is activated in complement with the previous value of the `RST`. 

```Verilog
// Below the Program Counter Statement

         $imem_rd_en         = !>>1$reset ? 1 : 0;
         $imem_rd_addr[31:0] = $pc[M4_IMEM_INDEX_CNT+1:2];

      @1
         $instr[31:0] = $imem_rd_data[31:0];
```

| ![IM09_Fetch_PC_InMem](https://github.com/user-attachments/assets/a1d4988a-09be-4f58-ac49-0c194d49a4b0) |
| :------------------------------------: |
|   Figure 8. Fetch Address from Program Counter and Instruction Data - Makechip IDE Output    |

## Decode Instructions

### Decode Instruction Type

`instr[6:2]` determines instruction type: I, R, S, B, J and U. **The simple idea behind instruction decode logic design is to eliminate common cases between different instructions and create instances that identify the type of instruction based on their differences. For example, the difference can be a single bit, which can be represented as don't-cares**.

| ![IM09_Instruction_Type_Decode](https://github.com/user-attachments/assets/139957d1-5f09-428e-9090-f4d1769468a5) |
| :------------------------------------: |
|  Instruction Types for RISC-V Processor   |

```Verilog
// Below Instruction Fetch Assignment

         $is_i_instr = $instr[6:2] ==? 5'b0000x || $instr[6:2] ==? 5'b001x0 || $instr[6:2] ==? 5'b11001;
         $is_r_instr = $instr[6:2] ==? 5'b01011 || $instr[6:2] ==? 5'b011x0 || $instr[6:2] ==? 5'b10100;
         $is_s_instr = $instr[6:2] == 5'b0100x;
         $is_u_instr = $instr[6:2] == 5'b0x101;
         $is_b_instr = $instr[6:2] == 5'b11000;
         $is_j_instr = $instr[6:2] == 5'b11011;
```

### Decode Immediate Instructions

Form `$imm[31:0]` based on the instruction type.

|  ![IM10_Immediate_Instruction_Decode](https://github.com/user-attachments/assets/262dccf6-45df-42b8-9437-624f6a1ca88d) |
| :------------------------------------: |
|  Immediate Instruction Decode for RISC-V Processor   |

```Verilog
// Below Instruction Type Decode

         $imm[31:0] = $is_i_instr   ? {{21{$instr[31]}}, $instr[30:20]} :
                      $is_s_instr   ? {{21{$instr[31]}}, $instr[30:25], $instr[11:8], $instr[7]} :
                      $is_b_instr   ? {{20{$instr[31]}}, $instr[7], $instr[30:25], $instr[11:8], 1'b0} :
                      $is_u_instr   ? {$instr[31], $instr[30:20], $instr[19:12], 12'b0} :
                      $is_j_instr   ? {{12{$instr[31]}}, $instr[19:12], $instr[20], $instr[30:21], 1'b0} :
                      32'b0;        
```

### Decode - Extracting Instruction Fields

| ![IM11_Extract_Instruction_Fields](https://github.com/user-attachments/assets/7872a044-c2e9-47cf-bd85-0763194185c3) |
| :------------------------------------: |
|  Immediate Instruction Decode for RISC-V Processor   |

```Verilog
// Below Immediate Instruction Decode, Note Immediate Instructions are Taken Care

         $rs1_valid    = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
         $rs2_valid    = $is_r_instr || $is_s_instr || $is_b_instr;
         $rd_valid     = $is_r_instr || $is_i_instr || $is_u_instr || $is_j_instr;
         $funct3_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
         $funct7_valid = $is_r_instr;

         $opcode[6:0]    = $instr[6:0];

         ?$rs1_valid
            $rs1[4:0]    = $instr[19:15];

         ?$rs2_valid
            $rs2[4:0]    = $instr[24:20];

         ?$rd_valid
            $rd[4:0]     = $instr[11:7];

         ?$funct3_valid
            $funct3[2:0] = $instr[14:12];

         ?$funct7_valid
            $funct7[6:0] = $instr[31:25];
```

### Decode Individual Instructions

|<img width="959" alt="RISC-V Basic Instruction Set" src="https://github.com/user-attachments/assets/b54373f7-7e29-477e-9a81-86cc220bc74d" />|
| :------------------------------------: |
|  RISCV-32 Basic Instruction Set   |

```Verilog
// Below Extract Instruction Fields Code

         $dec_bits[10:0] = {$funct7[5], $funct3, $opcode};

         $is_beq  = $dec_bits ==? 11'bx_000_1100011;
         $is_bne  = $dec_bits ==? 11'bx_001_1100011;
         $is_blt  = $dec_bits ==? 11'bx_100_1100011;
         $is_bge  = $dec_bits ==? 11'bx_101_1100011;
         $is_bltu = $dec_bits ==? 11'bx_110_1100011;
         $is_bgeu = $dec_bits ==? 11'bx_111_1100011;
         $is_addi = $dec_bits ==? 11'bx_000_0010011;
         $is_add  = $dec_bits ==? 11'b0_000_0110011;
```
### Lab : Single-Cycle RISC-V Fetch and Decode Implementation

|![IM13_RISCV_Fetch_Decode_Logics](https://github.com/user-attachments/assets/4dc26133-68d1-4510-9d61-55f0e6af015e)|
| :------------------------------------: |
|  Figure 9. RISCV-32 Fetch and Decode Implementation - Makerchip IDE Output   |

### Register File Read and Write

Use the decoded fields to write and read data to the registers. To generate the register file, uncomment the macro `m4+rf (@1, @1)`.

|![IM03 Read and Write Register File](https://github.com/user-attachments/assets/a281cd12-8edf-4bf2-acc8-a65875e74f4c) |
| :------------------------------------: |
|  Dual-Read and Single Write Register File  |

#### Read

```Verilog
// Below Basic Instruction Set Decode, Read

         ?$rs1_valid
            $rf_rd_en1         = $rs1_valid;
            $rf_rd_index1[4:0] = $rs1[4:0];
            
         ?$rs2_valid
            $rf_rd_en2         = $rs2_valid;
            $rf_rd_index2[4:0] = $rs2[4:0];
            
         $src1_value[31:0] = $rf_rd_data1;
         $src2_value[31:0] = $rf_rd_data2;
```

#### Write

```Verilog
         // Below Arithemtic and Logic Unit, Register Write

         $rf_wr_en = ($rd == 5'h0) ? 1'b0 : $rd_valid;
         
         ?$rf_wr_en
            $rf_wr_index[4:0] = $rd[4:0];
            
         $rf_wr_data[31:0]  = $result[31:0];       
```

### Simple Arithmetic and Logic Unit (ALU) Design

```Verilog
         // Arithmetic and Logic Unit, Below Register File

         $result[31:0] = $is_addi ? $src1_value + $imm :
                         $is_add  ? $src2_value + $src1_value : 32'bx;
         
```

### Branch Instructions

The Program Counter is modified to calculate the branch address based on the immediate value. If the `TAKEN_BRANCH` is high, the Program Counter is updated with the branch address; otherwise, the address is incremented by 4 by default.

```Verilog

         // Updated Program Counter

         $pc[31:0] = (>>1$reset) ? '0 : >>1$taken_br ? >>1$br_tgt_pc : >>1$pc + 32'h4;

         // Branch Instructions Check
         
         $taken_br = $is_beq  ? ($src1_value == $src2_value) :
                     $is_bne  ? ($src1_value != $src2_value) :
                     $is_blt  ? ($src1_value <  $src2_value) ^ ($src1_value[31] != $src2_value[31]) :
                     $is_bge  ? ($src1_value >  $src2_value) ^ ($src1_value[31] != $src2_value[31]) :
                     $is_bltu ? ($src1_value <= $src2_value) :
                     $is_bgeu ? ($src1_value >= $src2_value) :
                     1'b0;
                     
         // Branch Instruction Address Update
         
         $br_tgt_pc[31:0] = $pc + $imm;
```

### Lab : Single-Cycle RISC-V32I Implementation

|![IM02 Non-Pipelined Processor](https://github.com/user-attachments/assets/55ca5410-6c11-4e61-b6fd-db7c693ef43f) |
| :------------------------------------: |
|  Figure 10. Single Cycle RISC-V Micro-Architecture Implementation - Makerchip IDE Output  |

# Pipelining the RISC-V CPU Micro-Architecture

## Pipelining and Hazards

Pipelining is done to improve the throughput of instruction execution by allowing multiple instructions to be processed simultaneously, but at different stages of execution. In a pipelined processor, the execution of an instruction is divided into several stages **Fetch, Decode, Execute, Memory Access and Write Back**. 

While pipelining offers significant performance benefits, it also introduces some challenges like **Data Hazards, Control Hazards (Branch), Structural Hazards, Pipelined Stalls and Bubble Insertions**. 

The **Data Hazards** occur when one instruction depends on the result of another instruction that has not completed its execution. **Read-after-Write (RAW)** is when an instruction reads data that is yet to be written by a previous instruction. **Write-after-Write (WAW)** is when two instructions write to the same register, but the write order must be preserved. **Write-after-Read (WAR)** is when a register is written to before it is read by a following instruction.

The **Control Hazards** arise from branch instructions (conditional jumps), where the processor needs to determine the next instruction to execute. If a branch is mis-predicted, the pipeline must be flushed, and the correct instructions need to be fetched, resulting in a performance penalty.

The **Structural Hazards** occur when the hardware resources required by multiple instructions in the pipeline conflict.

### Lab : Pipelined RISC-V Processor

Based on the RISC-V architecture in `D04_SLIDE37`, modify the pipeline design by changing the macro `m4+rf(@1, @1)` to `m4+rf(@2, @3)`. Additionally, add a `VALID_SIGNAL` to validate the instructions.
 
| ![IM01 Pipelined RISC-V Processor](https://github.com/user-attachments/assets/9641615f-fe71-41c4-a253-a609cc97dfea) |
| :------------------------------------: |
|  Figure 11. Pipelined RISC-V Micro-Architecture Implementation - Makerchip IDE Output  |

## Data Memory and Jump Instruction Support 

### Lab : Data Memory - Load and Store Instructions (Memory Access and Write-Back)

The data memory has a similar implementation to the instruction memory. Uncomment the macro `m4+dmem(@4)`. Add `VALID_SIGNALS` for load and store instructions to avoid data hazards.

|![image](https://github.com/user-attachments/assets/b40088d1-4d24-41de-abe1-5548a9102efc) |
| :------------------------------------: |
|  Figure 12. Pipelined RISC-V Micro-Architecture with Load and Store Instruction Implementation - Makerchip IDE Output  |

### Lab : Five Stage Pipelined RISC-V Processor (Complete Implementation)

| ![image](https://github.com/user-attachments/assets/a427d703-db50-4f3a-b5ee-fc4996f5f6ac) |
| :------------------------------------: |
|  Figure 13. Five State Pipelined RISC-V Micro-Architecture - Makerchip IDE Output  |

# Acknowledgements

1. [Steve Hoover](https://github.com/stevehoover), Founder Redwood EDA 
2. [Kunal Ghosh](https://github.com/kunalg123), Founder VSD
3. [Shivani Shah](https://github.com/shivanishah269), Hardware Architect at Nvidia
