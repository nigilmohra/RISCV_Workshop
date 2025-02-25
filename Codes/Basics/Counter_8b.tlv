\m4_TLV_version 1d: tl-x.org
\SV
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/ecba3769fff373ef6b8f66b3347e8940c859792d/tlv_lib/calculator_shell_lib.tlv'])

\SV
   m4_makerchip_module 

\TLV

   // Nigil
   // 8-Bit Free Running Counter
   
   |calc
      @0
         $reset = *reset;
 
         $cnt[7:0] = $reset ? 0 : (>>1$cnt + 1);
         
   // Limiting Simulation
   
   *passed = *cyc_cnt > 20;
   *failed = 1'b0;

\SV
   endmodule