module whitebox(intf_whitebox whitebox_if);

//Inmediate assertions
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

// Concurrent assertions

// Rule 3.00
 wb_init: assert property ( @(posedge whitebox_if.wb_clk_i) ($rose whitebox_if.wb_clk_i |=> $fell whitebox_if.wb_rst_i) else $error ("Wishbone Protocol Rule 3.00 violated");

// Rule 3.05
 wb_reset_1clk: assert property(@(posedge whitebox_if.wb_clk_i) ($rose whitebox_if.wb_clk_i |=> ##[1] $fell whitebox_if.wb_rst_i))

// Rule 3.10  Seringa  ... 

// Rule 


endmodule