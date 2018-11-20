module whitebox(intf_whitebox whitebox_if);

//Inmediate assertion
  always_comb begin
    sdram_init: assert #0 ($rose(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n) |->
                           $stable(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)[*N_CYCLES]);
                         
                         /*$stable(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)[*N_CYCLES]) |->
                         ##N (!whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && !whitebox_if.sdr_we_n) |->
                         $rose(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n) |->
                         ##N (!whitebox_if.sdr_ras_n && !whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n); |->
                         $rose(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n) |->
                         ##N (!whitebox_if.sdr_ras_n && !whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n);)*/
  end

endmodule