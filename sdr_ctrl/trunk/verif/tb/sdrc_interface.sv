`timescale 1ns/1ps

interface inft_sdrcntrl #(parameter SDR_DW = 16,
                          parameter SDR_BW = 2,
                          parameter APP_AW = 26)
                          (input sys_clk, sdram_clk);

    logic resetn;

    intf_sdram #(.SDR_DW(SDR_DW), .SDR_BW(SDR_BW)) sdram_intf ();
    intf_wishBone #(.dw(SDR_DW), .APP_AW(APP_AW)) wb_intf ();

endinterface                          
