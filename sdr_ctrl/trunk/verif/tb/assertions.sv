module whitebox(intf_whitebox whitebox_if);

property sdram_init;
  @(negedge whitebox_if.sdram_clk)
  $fell(whitebox_if.sdram_resetn) |=>                                                                     // reset
  $stable(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)[*500]   |-> ##[0:100]   // NOP stable 100us
  $rose(!whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && !whitebox_if.sdr_we_n)         |-> ##[0:100]   // recharge LHL
  $rose(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)           |-> ##[0:100]   // NOP
  $rose(!whitebox_if.sdr_ras_n && !whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)         |-> ##[0:100]   // autorefresh LLH
  $rose(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n)           |-> ##[0:100]   // NOP
  $rose(!whitebox_if.sdr_ras_n && !whitebox_if.sdr_cas_n && whitebox_if.sdr_we_n);                        // autorefresh LLH
endproperty

// Property of Rule 3.00
property wb_init;
@(posedge whitebox_if.wb_clk_i)
$rose whitebox_if.wb_clk_i |=> $fell whitebox_if.wb_rst_i
endproperty

// Property of Rule 3.05
property wb_reset;
@(posedge whitebox_if.wb_clk_i)
$rose whitebox_if.wb_clk_i |=> ##[1] $fell whitebox_if.wb_rst_i
endproperty

// Property of Rule 3.10
property wb_reset;
@(posedge whitebox_if.wb_clk_i)
$rose whitebox_if.wb_rst_i |=> ##[1] $fell whitebox_if.wb_rst_i
endproperty



// Sdram init assertion
sdram_initialization: assert property (sdram_init) else $error ("SDRAM_INIT FAILED!!!!!!!!!");

// Rule 3.00
 wb_initialization: assert property (wb_init) else $error ("Wishbone Protocol Rule 3.00 violated");

// Rule 3.05
 wb_reset_1_clk: assert property(wb_reset) else $error ("Wishbone Protocol Rule 3.05 violated");

// Rule 3.10  Seringa  ... 

// Rule 


endmodule
