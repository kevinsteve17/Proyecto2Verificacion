`include "sdrc_environment.sv"
`include "sdrc_driver.sv"
`include "sdrc_monitor.sv"

program testcase(inft_sdrcntrl intf);
  sdrc_environment env = new(intf);
         
  initial
    begin

    $display("-------------------------------------- ");
    $display(" Case-1: Single Write/Read Case        ");
    $display("-------------------------------------- ");
    // single write and single read
    env.drv.reset();
    env.drvr.BurstWrite(32'h4_0000,8'h4);
    #1000;
    burst_read();
    end
endprogram
