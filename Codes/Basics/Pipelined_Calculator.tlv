\m4_TLV_version 1d: tl-x.org
\SV
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/ecba3769fff373ef6b8f66b3347e8940c859792d/tlv_lib/calculator_shell_lib.tlv'])

\SV
   m4_makerchip_module 

\TLV
   
   // Nigil
   // Two-Cycle Calculator

   |calc
      @1
         $reset = *reset;      
         
         // Generate Random Values

         $val1[31:0] = >>2$out[3:0];
         $val2[31:0] = $rand2[3:0];
         $op[1:0]    = $rand3[1:0];
   
         // Operations

         $sum[31:0]  = $val1 + $val2;
         $diff[31:0]  = $val1 - $val2;
         $prod[31:0] = $val1 * $val2;
         $quot[31:0] = $val1 / $val2;

         // Validation Counter / Operation Performed Alternate Cycles

         $cnt = $reset == 1 ? 1'h0 : >>1$cnt + 1;

         // Selecting Operation
      @2
         $valid     = ($reset|!$cnt);
         $out[31:0] = $valid == 1 ? 32'h0 : 
                                            $op[1:0] == 0 ? $sum  : 
                                            $op[1:0] == 1 ? $diff : 
                                            $op[1:0] == 2 ? $prod : 
                                            $quot; 
   
   // Limiting Testing Cycles
   
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule