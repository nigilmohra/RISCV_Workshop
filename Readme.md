# RISC-V based MYTH Workshop
This repository contains the documents, codes, and materials related to the RISC-V-based MYTH workshop, organized by NASSCOM India in collaboration with Steeve Hoover and Kunal Ghosh. 

GitHub Repository Link : [Steve Hoover | RISCV Myth Workshop](https://github.com/stevehoover/RISC-V_MYTH_Workshop)

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

The Fibonacci series is provided as an example for the sequential circuits. The circuit is constructed such that it enters the known state when a `RESET` signal is present. For the Fibonacci code, the known state is `1`. The syntax `>>1` provides the previous value of `$val`, and `>>2` provides the value of `$val` two states prior. Similarly, `>>x` will provide the value of `$val` `x` cycles prior.

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

### Retiming the Pipeline : Pythagorean Theorem

```Verilog
\TLV

   // Design Under Test

   |calc
      @1 // Stage
         $aa_sq[31:0] = $aa * $aa; 
         $bb_sq[31:0] = $bb * $bb;
      @2
         $cc_sq[31:0] = $aa_sq + $bb_sq;
      @3
         $cc[31:0] = sqrt($cc_sq);

```

| ![Pipeline with Simple Retiming](https://github.com/user-attachments/assets/3398c19d-242e-4f03-8f20-60c40e14f2db) |
| :------------------------------------: |
|   Architecture - A Retimed Pipeline    |

### Identifiers and Types

The type of an identifier is determined by its symbol prefix and case/delimitation style. The first token must always start with two alphabet characters. Numbers cannot appear at the beginning of the tokens; they can only be at the end or in the middle. This should not be confused with number identifiers like `>>1`.

| Token Name    | Signal Type     |
| ------------- | --------------- |
| `$lower_case` | Pipeline Signal |
| `$CamelCase`  | State Signal    |
| `$UPPER_CASE` | Keyword Signal  |

### Fibonacci Series in Pipeline

```Verilog
\TLV

   |fib
      @1
         $num[31:0] = *reset ? 1 : (>>1$num + >>2$num);
```

### Lab : Error Conditions Within Computation Pipeline

The `ERROR_SIGNALS` are OR together to check the various error conditions that can occur within a computational pipeline.

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

### Lab : Two-Cycle Calculator

The calculation happens in the first cycle, and in the second cycle, the outputs are assigned based on the `VALID SIGNAL`, which is determined by `$reset | !cnt`.
