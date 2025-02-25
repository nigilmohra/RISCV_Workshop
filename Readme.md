# RISC-V Design using Transaction-Level Verilog 
This repository contains the documents, codes, and materials related to the RISC-V-based MYTH workshop, organized by NASSCOM India in collaboration with Steve Hoover and Kunal Ghosh. 

GitHub Repository Link : [Steve Hoover | RISCV Myth Workshop](https://github.com/stevehoover/RISC-V_MYTH_Workshop)

# Introduction to RISC-V Instruction Set Architecture and GNU Compiler Tool Chain

## Introduction

| ![Softening the Hardware (Onion)](https://github.com/user-attachments/assets/8671dd5d-9e25-4769-91c4-ee642466a42f) |
| :--------------------------------------------------: |
|           Softening the Hardware (Onion Layers)         |

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

The Makerchip IDE uses the open-source Verilator for simulation. It supports only two-state simulation and does not support don't care or high impedance states. The simulator will zero-extend or truncate when widths are mismatched.

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

Note that stage one can be separated into two separate stages, and the impact on the behavior of the circuit does not change. The pipeline stages are a physical attribute. TL-Verilog is far more flexible than SystemVerilog and avoids retiming issues.

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
