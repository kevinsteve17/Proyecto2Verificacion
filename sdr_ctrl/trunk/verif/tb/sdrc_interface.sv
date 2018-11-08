`timescale 1ns/1ps

interface inft_sdrcntrl #(parameter SDR_DW = 32,
                          parameter SDR_BW = 2,
                          parameter APP_AW = 26)
                          (sys_clk, sdram_clk);

    logic resetn;
    input sdram_clk;
    input sys_clk;

    intf_sdram #(.SDR_DW(SDR_DW), .SDR_BW(SDR_BW)) sdram_intf (sdram_clk);
    intf_wishBone #(.dw(SDR_DW), .APP_AW(APP_AW)) wb_intf ();

endinterface                          
