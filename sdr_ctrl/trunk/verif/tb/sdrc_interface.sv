interface inft_sdrcntrl #(parameter sdr_data_width = 16,
                          parameter sdr_byte_width = 2,
                          parameter dw = 32,
                          parameter app_addr_w = 26);

    logic sdram_clk;
    logic sdram_resetn;
    logic sys_clk;

    intf_sdram #(.sdr_data_width(sdr_data_width), .sdr_byte_width(sdr_byte_width)) sdram_intf ();
    intf_WishBone #(.dw(dw), .app_addr_w(app_addr_w)) wb_intf ();

endinterface                          
