\m4_TLV_version 1d: tl-x.org
\SV
   m4_include_lib(['https://raw.githubusercontent.com/BalaDhinesh/RISC-V_MYTH_Workshop/master/tlv_lib/risc-v_shell_lib.tlv'])
\SV
   m4_makerchip_module   
\TLV


   // Test
   //
   // Regs:
   //  r10 (a0): In: 0, Out: final sum
   //  r12 (a2): 10
   //  r13 (a3): 1..10
   //  r14 (a4): Sum

   // External to Functions:

   m4_asm(ADD, r10, r0, r0)             // Initialize r10 (a0) to 0.

   // Function

   m4_asm(ADD, r14, r10, r0)            // Initialize Sum Reg a4 with 0x0
   m4_asm(ADDI, r12, r10, 1010)         // Store Count of 10 in Reg a2.
   m4_asm(ADD, r13, r10, r0)            // Initialize Intermediate Sum Reg a3 with 0

   // Loop

   m4_asm(ADD, r14, r13, r14)           // Incremental Addition
   m4_asm(ADDI, r13, r13, 1)            // Increment Intermediate Reg +1
   m4_asm(BLT, r13, r12, 1111111111000) // If a3 is less than a2, Branch to Label Named <Loop>
   m4_asm(ADD, r10, r14, r0)            // Store Result to Reg a0 
   
   // Optional

   // m4_asm(JAL, r7, 00000000000000000000) // Unused

   m4_define_hier(['M4_IMEM'], M4_NUM_INSTRS)

   // Nigil 

   |cpu
      @0
         
         // Program Counter
         
         $reset = *reset;
         $pc[31:0] = (>>1$reset) ? '0 : >>1$taken_br ? >>1$br_tgt_pc : >>1$pc + 32'h4;
         
         // Instruction Memory
         
         $imem_rd_en         = !>>1$reset ? 1 : 0;
         $imem_rd_addr[31:0] = $pc[M4_IMEM_INDEX_CNT+1:2];
         
      @1
         // Fetch Instruction Data
         
         $instr[31:0] = $imem_rd_data[31:0];
         
         // Instruction Type Decode
         
         $is_i_instr = $instr[6:2] ==? 5'b0000x || $instr[6:2] ==? 5'b001x0 || $instr[6:2] ==? 5'b11001;
         $is_r_instr = $instr[6:2] ==? 5'b01011 || $instr[6:2] ==? 5'b011x0 || $instr[6:2] ==? 5'b10100;
         $is_s_instr = $instr[6:2] == 5'b0100x;
         $is_u_instr = $instr[6:2] == 5'b0x101;
         $is_b_instr = $instr[6:2] == 5'b11000;
         $is_j_instr = $instr[6:2] == 5'b11011;
         
         // Immediate Instruction Decode
         
         $imm[31:0] = $is_i_instr   ? {{21{$instr[31]}}, $instr[30:20]} :
                      $is_s_instr   ? {{21{$instr[31]}}, $instr[30:25], $instr[11:8], $instr[7]} :
                      $is_b_instr   ? {{20{$instr[31]}}, $instr[7], $instr[30:25], $instr[11:8], 1'b0} :
                      $is_u_instr   ? {$instr[31], $instr[30:20], $instr[19:12], 12'b0} :
                      $is_j_instr   ? {{12{$instr[31]}}, $instr[19:12], $instr[20], $instr[30:21], 1'b0} :
                      32'b0;
         
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
            
         // Below Extract Instruction Fields Code // Nigil
         
         $dec_bits[10:0] = {$funct7[5], $funct3, $opcode};
         
         $is_beq  = $dec_bits ==? 11'bx_000_1100011;
         $is_bne  = $dec_bits ==? 11'bx_001_1100011;
         $is_blt  = $dec_bits ==? 11'bx_100_1100011;
         $is_bge  = $dec_bits ==? 11'bx_101_1100011;
         $is_bltu = $dec_bits ==? 11'bx_110_1100011;
         $is_bgeu = $dec_bits ==? 11'bx_111_1100011;
         $is_addi = $dec_bits ==? 11'bx_000_0010011;
         $is_add  = $dec_bits ==? 11'b0_000_0110011;
         
         // Below Basic Instruction Set Decode, 2 Read and 1 Write Register File
         
         ?$rs1_valid
            $rf_rd_en1    = $rs1_valid;
            $rf_rd_index1 = $rs1;
            
         ?$rs2_valid
            $rf_rd_en2    = $rs2_valid;
            $rf_rd_index2 = $rs2;
            
         $src1_value[31:0] = $rf_rd_data1;
         $src2_value[31:0] = $rf_rd_data2;
         
         // Arithmetic and Logic Unit, Below Register File
         
         $result[31:0] = $is_addi ? $src1_value + $imm :
                         $is_add  ? $src2_value + $src1_value : 32'bx;
                         
         // Below Arithemtic and Logic Unit
         
         $rf_wr_en = ($rd == 5'h0) ? 1'b0 : $rd_valid;
         
         ?$rf_wr_en
            $rf_wr_index = $rd;
            
         $rf_wr_data  = $result;
         
         // Branch Instructions Check
         
         $taken_br = $is_beq  ? ($src1_value == $src2_value) :
                     $is_bne  ? ($src1_value != $src2_value) :
                     $is_blt  ? ($src1_value < $src2_value) ^ ($src1_value[31] != $src2_value[31]) :
                     $is_bge  ? ($src1_value > $src2_value) ^ ($src1_value[31] != $src2_value[31]) :
                     $is_bltu ? ($src1_value <= $src2_value) :
                     $is_bgeu ? ($src1_value >= $src2_value) :
                     1'b0;
         
         // Branch Instruction Address Update
         
         $br_tgt_pc = $pc + $imm;

         // Limit Simulation Cycle and Test
         
         *passed = *cyc_cnt > 10;
         *passed = |cpu/xreg[10]>>5$value == (1+2+3+4+5+6+7+8+9);
         *failed = 1'b0;
         
         `BOGUS_USE($is_beq $is_bne $is_blt $is_bge $is_bltu $is_bgeu)
         
   |cpu
      m4+imem(@1)      // Args: (Read)
      m4+rf(@1, @1)    // Args: (Read, Write) - Equal - No Register Bypass Required
      //m4+dmem(@4)    // Args: (Read / Write)

   m4+cpu_viz(@4)      // Visuals
\SV
   endmodule
