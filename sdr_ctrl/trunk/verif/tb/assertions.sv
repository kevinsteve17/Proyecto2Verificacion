module whitebox(intf_whitebox whitebox_if);

property full_empty_p_0;
  @(negedge whitebox_if.sdram_clk)
  $fell(whitebox_if.sdram_resetn) |->                                                                     // reset
  $rose(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)           |->
  $stable(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)[*600])  |-> ##[0:100]   // NOP stable 100us
  $rose(!whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && !whitebox_if.sdr_we_n)         |-> ##[0:100]   // recharge LHL
  $rose(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)           |-> ##[0:100]   // NOP
  $rose(!whitebox_if.sdr_ras_n && !whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)         |-> ##[0:100]   // autorefresh LLH
  $rose(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)           |-> ##[0:100]   // NOP
  $rose(!whitebox_if.sdr_ras_n && !whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)                         // autorefresh LLH
endproperty

 /* always_comb begin
    assert property #0 ($rose(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n) |->
                        $stable(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)[*600]);
                         
                         /*$stable(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)[*N_CYCLES]) |->
                         ##N (!whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && !whitebox_if.sdr_we_n) |->
                         $rose(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n) |->
                         ##N (!whitebox_if.sdr_ras_n && !whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n); |->
                         $rose(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n) |->
                         ##N (!whitebox_if.sdr_ras_n && !whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n);)
  end*/

endmodule