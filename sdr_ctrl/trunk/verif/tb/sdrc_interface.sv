interface inft_sdrcntrl #(parameter SDR_DW = 16,
                          parameter SDR_BW = 2,
                          parameter dw = 32,
                          parameter APP_AW = 26);

    logic sys_clk;

    intf_sdram #(.SDR_DW(SDR_DW), .SDR_BW(SDR_BW)) sdram_intf ();
    intf_WishBone #(.dw(dw), .APP_AW(APP_AW)) wb_intf ();

endinterface                          
