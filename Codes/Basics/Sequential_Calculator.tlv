\m4_TLV_version 1d: tl-x.org
\SV
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/ecba3769fff373ef6b8f66b3347e8940c859792d/tlv_lib/calculator_shell_lib.tlv'])

\SV
   m4_makerchip_module 

\TLV
   
   // Nigil
   // 32-Bit Sequential Calculator

   |calc
      @0
         $reset = *reset;

         // Do Not Generate Signals if Reset is Present
         
         $val1[31:0] = $reset == 1 ?  32'h0 : >>1$out;
         $val2[31:0] = $reset == 1 ?  32'h0 : $rand2[3:0];
         $op[1:0]    = $reset == 1 ?   2'h0 : $rand3[1:0];

         // Operations

         $sum[31:0]  = $val1 + $val2;
         $diff[31:0]  = $val1 - $val2;
         $prod[31:0] = $val1 * $val2;
         $quot[31:0] = $val1 / $val2;

         // Selecting Operation

         $out[31:0] = $reset == 1 ? 32'h0 : $op[1:0] == 0 ? $sum  : 
                                            $op[1:0] == 1 ? $diff : 
                                            $op[1:0] == 2 ? $prod : 
                                            $quot;
   
   // Limiting Testing Cycles
   
   *passed = *cyc_cnt > 5;
   *failed = 1'b0;

\SV
   endmodule